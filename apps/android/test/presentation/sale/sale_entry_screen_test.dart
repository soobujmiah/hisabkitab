import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/application/sale/sale_service.dart';
import 'package:songjog/data/local/in_memory_store.dart';
import 'package:songjog/data/repositories/business_repository.dart';
import 'package:songjog/domain/models/transaction.dart';
import 'package:songjog/domain/services/diagnostic_collector.dart';
import 'package:songjog/l10n/app_text.dart';
import 'package:songjog/presentation/sale/sale_entry_screen.dart';

void main() {
  const locale = AppLocale.bangla;

  String t(String key) => AppText.get(locale, key);

  late InMemoryStore store;
  late DiagnosticCollector collector;
  late SaleEntryService service;

  Finder findField(String label) =>
      find.widgetWithText(TextField, t(label), skipOffstage: false);

  Finder completeSaleButton() => find.widgetWithText(
    FilledButton,
    t('complete_sale'),
    skipOffstage: false,
  );

  Finder returnableFinder() =>
      find.widgetWithText(Text, t('returnable'), skipOffstage: false);

  Future<void> tapCompleteSale(WidgetTester tester) async {
    final button = completeSaleButton();
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
  }

  Future<void> ensureCompleteSaleVisible(WidgetTester tester) async {
    final button = completeSaleButton();
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
  }

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SaleEntryScreen(service: service)),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    store = InMemoryStore();
    collector = DiagnosticCollector();
    service = SaleEntryService(DefaultBusinessRepository(store), collector);
  });

  testWidgets('save is disabled until the first line is complete', (
    tester,
  ) async {
    await pumpScreen(tester);
    await ensureCompleteSaleVisible(tester);
    expect(tester.widget<FilledButton>(completeSaleButton()).onPressed, isNull);

    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(completeSaleButton()).onPressed, isNull);

    await tester.enterText(findField('price'), '850');
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(completeSaleButton()).onPressed,
      isNotNull,
    );
  });

  testWidgets('a fully paid sale is saved with the right totals', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.enterText(findField('amount_paid'), '850');
    await tester.pumpAndSettle();

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transactions = await store.loadTransactions();
    expect(transactions, hasLength(1));
    expect(transactions.single.totalMinor, 85000);
    expect(transactions.single.paidMinor, 85000);
    expect(transactions.single.paymentStatus, PaymentStatus.paid);
    expect(transactions.single.lines.single.description, 'Mouse');
  });

  testWidgets('a partial payment leaves the due amount', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.enterText(findField('amount_paid'), '300');
    await tester.pumpAndSettle();

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.paidMinor, 30000);
    expect(transaction.dueMinor, 55000);
    expect(transaction.paymentStatus, PaymentStatus.partial);
  });

  testWidgets('multi-line totals are summed on save', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '100');
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(FilledButton, t('add_line'), skipOffstage: false),
    );
    await tester.pumpAndSettle();
    await tester.enterText(findField('line_description').last, 'Windows setup');
    await tester.enterText(findField('price').last, '50');
    await tester.pumpAndSettle();

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.lines, hasLength(2));
    expect(transaction.totalMinor, 15000);
    expect(transaction.paymentStatus, PaymentStatus.unpaid);
  });

  testWidgets('overpayment is clamped to the total', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.enterText(findField('amount_paid'), '900');
    await tester.pumpAndSettle();

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.paidMinor, 85000);
    expect(transaction.paymentStatus, PaymentStatus.paid);
  });

  testWidgets('overpayment shows returnable change', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.pumpAndSettle();
    // Paid 900 for total 850 -> returnable 50
    await tester.enterText(findField('amount_paid'), '900');
    await tester.pumpAndSettle();

    // Returnable should be visible
    expect(returnableFinder(), findsOneWidget);
    // Money should show ৳৫০ in Bangla mode (Bangla numerals)
    expect(find.textContaining('৫০', skipOffstage: false), findsWidgets);
    // Due should be 0
    expect(find.textContaining('৳০', skipOffstage: false), findsWidgets);
  });

  testWidgets('exact payment shows no returnable', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.enterText(findField('amount_paid'), '850');
    await tester.pumpAndSettle();

    expect(returnableFinder(), findsNothing);
  });

  testWidgets('partial payment shows no returnable but shows due', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.enterText(findField('amount_paid'), '300');
    await tester.pumpAndSettle();

    expect(returnableFinder(), findsNothing);
    expect(find.textContaining('বাকি', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Bangla numerals used for money in Bangla mode', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.pumpAndSettle();

    // Total should show Bangla digits ৮৫০ with ৳
    expect(find.textContaining('৳', skipOffstage: false), findsWidgets);
    expect(find.textContaining('৮৫০', skipOffstage: false), findsOneWidget);
    // Should not contain Latin 850 in Bangla mode for total
    expect(find.text('৳850', skipOffstage: false), findsNothing);
  });

  testWidgets('payment method selection is stored', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(findField('line_description'), 'Mouse');
    await tester.enterText(findField('price'), '850');
    await tester.enterText(findField('amount_paid'), '850');
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(
        DropdownButtonFormField<PaymentMethod?>,
        t('payment_method_unset'),
        skipOffstage: false,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(t('cash'), skipOffstage: false).last);
    await tester.pumpAndSettle();

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.paymentMethod, PaymentMethod.cash);
  });
}

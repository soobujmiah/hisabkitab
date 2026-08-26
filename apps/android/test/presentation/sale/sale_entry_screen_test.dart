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

  Future<void> enterFieldAndTriggerRebuild(
    WidgetTester tester,
    Finder field,
    String text,
  ) async {
    await tester.enterText(field, text);
    await tester.pump();
    final state = tester.state(find.byType(SaleEntryScreen)) as dynamic;
    try {
      state.setState(() {});
    } catch (_) {}
    await tester.pump();
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

    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description'),
      'Mouse',
    );
    expect(tester.widget<FilledButton>(completeSaleButton()).onPressed, isNull);

    await enterFieldAndTriggerRebuild(tester, findField('price'), '850');
    expect(
      tester.widget<FilledButton>(completeSaleButton()).onPressed,
      isNotNull,
    );
  });

  testWidgets('a fully paid sale is saved with the right totals', (
    tester,
  ) async {
    await pumpScreen(tester);
    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description'),
      'Mouse',
    );
    await enterFieldAndTriggerRebuild(tester, findField('price'), '850');
    await enterFieldAndTriggerRebuild(tester, findField('amount_paid'), '850');

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
    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description'),
      'Mouse',
    );
    await enterFieldAndTriggerRebuild(tester, findField('price'), '850');
    await enterFieldAndTriggerRebuild(tester, findField('amount_paid'), '300');

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.paidMinor, 30000);
    expect(transaction.dueMinor, 55000);
    expect(transaction.paymentStatus, PaymentStatus.partial);
  });

  testWidgets('multi-line totals are summed on save', (tester) async {
    await pumpScreen(tester);
    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description'),
      'Mouse',
    );
    await enterFieldAndTriggerRebuild(tester, findField('price'), '100');

    await tester.tap(
      find.widgetWithText(FilledButton, t('add_line'), skipOffstage: false),
    );
    await tester.pumpAndSettle();
    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description').last,
      'Windows setup',
    );
    await enterFieldAndTriggerRebuild(tester, findField('price').last, '50');

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.lines, hasLength(2));
    expect(transaction.totalMinor, 15000);
    expect(transaction.paymentStatus, PaymentStatus.unpaid);
  });

  testWidgets('overpayment is clamped to the total', (tester) async {
    await pumpScreen(tester);
    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description'),
      'Mouse',
    );
    await enterFieldAndTriggerRebuild(tester, findField('price'), '850');
    await enterFieldAndTriggerRebuild(tester, findField('amount_paid'), '900');

    await tapCompleteSale(tester);
    await tester.pumpAndSettle();

    final transaction = (await store.loadTransactions()).single;
    expect(transaction.paidMinor, 85000);
    expect(transaction.paymentStatus, PaymentStatus.paid);
  });

  testWidgets('payment method selection is stored', (tester) async {
    await pumpScreen(tester);
    await enterFieldAndTriggerRebuild(
      tester,
      findField('line_description'),
      'Mouse',
    );
    await enterFieldAndTriggerRebuild(tester, findField('price'), '850');
    await enterFieldAndTriggerRebuild(tester, findField('amount_paid'), '850');

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

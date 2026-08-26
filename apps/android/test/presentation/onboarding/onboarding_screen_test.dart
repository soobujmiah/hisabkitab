import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/application/onboarding/onboarding_service.dart';
import 'package:songjog/data/local/in_memory_store.dart';
import 'package:songjog/data/repositories/business_repository.dart';
import 'package:songjog/l10n/app_text.dart';
import 'package:songjog/presentation/onboarding/onboarding_screen.dart';

void main() {
  late InMemoryStore store;
  late OnboardingService service;

  Finder get saveButton =>
      find.widgetWithText(FilledButton, AppText.get(AppLocale.bangla, 'continue'));

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(service: service),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    store = InMemoryStore();
    service = OnboardingService(DefaultBusinessRepository(store));
  });

  testWidgets('save is disabled while the workspace name is empty',
      (tester) async {
    await pumpScreen(tester);
    final button = tester.widget<FilledButton>(saveButton);
    expect(button.onPressed, isNull);
  });

  testWidgets('save stays disabled for a whitespace-only name', (tester) async {
    await pumpScreen(tester);
    await tester.enterText(find.byType(TextField).first, '   ');
    await tester.pump();
    final button = tester.widget<FilledButton>(saveButton);
    expect(button.onPressed, isNull);
  });

  testWidgets('save enables when the name is typed and creates the workspace',
      (tester) async {
    await pumpScreen(tester);
    await tester.enterText(find.byType(TextField).first, 'Demo Shop');
    await tester.pump();
    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final profile = await store.loadBusinessProfile();
    expect(profile, isNotNull);
    expect(profile!.name, 'Demo Shop');
  });
}

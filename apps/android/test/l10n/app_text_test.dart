import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/application/sale/sale_service.dart';
import 'package:songjog/l10n/app_text.dart';

void main() {
  group('AppText script purity', () {
    test('Bangla mode contains no Latin letters in UI copy', () {
      final banglaValues = AppText.values[AppLocale.bangla]!;
      // Allowed Latin exceptions: none for app-authored UI text, except maybe technical?
      // We check that values do not contain [A-Za-z] unless they are in allowlist.
      // For this test, we enforce no Latin letters at all in Bangla UI copy.
      final latinRegex = RegExp(r'[A-Za-z]');
      for (final entry in banglaValues.entries) {
        // Skip keys that are allowed to have Latin? Currently none.
        // Money formatting is handled separately, not via AppText.
        if (latinRegex.hasMatch(entry.value)) {
          // Allowlist: check if value contains only allowed Latin like BDT? But BDT should not be in bn.
          // For now, fail if any Latin found in bn.
          fail(
            'Bangla key "${entry.key}" contains Latin letters: "${entry.value}"',
          );
        }
      }
    });

    test('English mode contains no Bengali script', () {
      final englishValues = AppText.values[AppLocale.english]!;
      final bengaliRegex = RegExp(r'[\u0980-\u09FF]');
      for (final entry in englishValues.entries) {
        if (bengaliRegex.hasMatch(entry.value)) {
          fail(
            'English key "${entry.key}" contains Bengali script: "${entry.value}"',
          );
        }
      }
    });

    test('All keys present in both locales', () {
      final banglaKeys = AppText.values[AppLocale.bangla]!.keys.toSet();
      final englishKeys = AppText.values[AppLocale.english]!.keys.toSet();
      expect(banglaKeys, englishKeys);
    });

    test('New keys for returnable and language exist', () {
      expect(AppText.get(AppLocale.bangla, 'returnable'), 'ফেরত');
      expect(AppText.get(AppLocale.english, 'returnable'), 'Change');
      expect(AppText.get(AppLocale.bangla, 'change_due'), 'ফেরত দিতে হবে');
      expect(AppText.get(AppLocale.english, 'change_due'), 'Change due');
      expect(AppText.get(AppLocale.bangla, 'language'), 'ভাষা');
      expect(AppText.get(AppLocale.english, 'language'), 'Language');
      expect(AppText.get(AppLocale.bangla, 'language_bangla'), 'বাংলা');
      expect(AppText.get(AppLocale.bangla, 'language_english'), 'ইংরেজি');
      expect(AppText.get(AppLocale.english, 'language_bangla'), 'Bangla');
      expect(AppText.get(AppLocale.english, 'language_english'), 'English');
    });
  });

  group('Money formatting with locale', () {
    test('minorToTaka formats correctly', () {
      expect(minorToTaka(85000), '850');
      expect(minorToTaka(350), '3.50');
    });

    test('toBanglaDigits converts correctly', () {
      expect(toBanglaDigits('850'), '৮৫০');
      expect(toBanglaDigits('3.50'), '৩.৫০');
      expect(toBanglaDigits('BDT 850'), 'BDT ৮৫০');
    });

    test('Bangla money uses Bangla numerals and ৳', () {
      String money(int minor, AppLocale locale) {
        final taka = minorToTaka(minor);
        final display = locale == AppLocale.bangla
            ? toBanglaDigits(taka)
            : taka;
        return locale == AppLocale.bangla ? '৳$display' : 'BDT $display';
      }

      expect(money(85000, AppLocale.bangla), '৳৮৫০');
      expect(money(5000, AppLocale.bangla), '৳৫০');
      expect(money(0, AppLocale.bangla), '৳০');
      expect(money(85000, AppLocale.english), 'BDT 850');
    });

    test('English money uses Latin digits and BDT', () {
      String money(int minor, AppLocale locale) {
        final taka = minorToTaka(minor);
        final display = locale == AppLocale.bangla
            ? toBanglaDigits(taka)
            : taka;
        return locale == AppLocale.bangla ? '৳$display' : 'BDT $display';
      }

      expect(money(85000, AppLocale.english), contains('BDT'));
      expect(money(85000, AppLocale.english), contains('850'));
      expect(money(85000, AppLocale.english), isNot(contains('৮৫০')));
    });

    test('calculateReturnable works for normal, exact, overpayment', () {
      // Normal: paid < total -> returnable 0
      expect(calculateReturnable(30000, 85000), 0);
      // Exact: paid == total -> 0
      expect(calculateReturnable(85000, 85000), 0);
      // Overpayment: paid > total -> excess
      expect(calculateReturnable(90000, 85000), 5000);
      expect(calculateReturnable(100000, 85000), 15000);
    });
  });
}

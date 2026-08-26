enum AppLocale { bangla, english }

/// UI copy contract. The presentation layer must select one locale and never
/// mix scripts on the same screen (see docs/LOCALIZATION_POLICY.md).
///
/// Script purity: in `bangla` mode only Bengali-script UI text is rendered;
/// in `english` mode only Latin-script UI text. Transliterated words are
/// written in Bengali script in `bangla` mode.
class AppText {
  const AppText._();

  static const Map<AppLocale, Map<String, String>> values = {
    AppLocale.bangla: {
      'app_name': 'সংযোগ',
      'welcome': 'স্বাগতম',
      'tagline': 'আপনার ব্যবসার হিসাব, এক জায়গায়।',
      'tagline_sub': 'বিক্রি, বাকি, খরচ ও লাভ—সহজভাবে।',
      'create_account': 'অ্যাকাউন্ট খুলুন',
      'login': 'লগইন',
      'take_tour': 'অ্যাপটি ঘুরে দেখুন',
      'workspace_saved': 'সংরক্ষণ সম্পন্ন হয়েছে',
      'settings': 'সেটিংস',
      'settings_title': 'সেটিংস',
      'workspace_title': 'আপনার প্রতিষ্ঠান সম্পর্কে বলুন',
      'workspace_name': 'প্রতিষ্ঠানের নাম',
      'workspace_type': 'প্রতিষ্ঠানের ধরন',
      'business_type': 'ব্যবসা বা সেবার ধরন',
      'phone': 'মোবাইল নম্বর',
      'address': 'ঠিকানা',
      'subtype': 'অতিরিক্ত ধরন',
      'continue': 'এগিয়ে যান',
      'skip': 'এখন নয়',
      'save': 'সংরক্ষণ করুন',
      'onboarding_saved': 'অনুশীলন সংরক্ষণ হয়েছে',
      // Export & diagnostics
      'export_section': 'এক্সপোর্ট',
      'export_my_data': 'আমার ডেটা এক্সপোর্ট করুন',
      'export_my_data_hint': 'ব্যবসার প্রোফাইল ও লেনদেন',
      'export_diagnostics': 'ডায়াগনস্টিক্স এক্সপোর্ট করুন',
      'export_diagnostics_hint': 'ডিবাগিং তথ্য—গোপন তথ্য ছাড়া',
      'export_in_progress': 'এক্সপোর্ট হচ্ছে…',
      'export_saved': 'ফাইল সংরক্ষিত হয়েছে',
      'export_failed': 'এক্সপোর্ট ব্যর্থ হয়েছে',
      'share': 'শেয়ার করুন',
      'record_test_event': 'টেস্ট ডায়াগনস্টিক ইভেন্ট রেকর্ড করুন',
      'test_event_recorded': 'টেস্ট ইভেন্ট রেকর্ড হয়েছে',
      'version': 'ভার্সন',
    },
    AppLocale.english: {
      'app_name': 'Songjog',
      'welcome': 'Welcome',
      'tagline': 'Your business accounts, in one place.',
      'tagline_sub': 'Sales, dues, expenses and profit—made simple.',
      'create_account': 'Create account',
      'login': 'Log in',
      'take_tour': 'Take a tour',
      'workspace_saved': 'Workspace saved',
      'settings': 'Settings',
      'settings_title': 'Settings',
      'workspace_title': 'Tell us about your organization',
      'workspace_name': 'Organization name',
      'workspace_type': 'Organization type',
      'business_type': 'Business or service type',
      'phone': 'Phone number',
      'address': 'Address',
      'subtype': 'Additional type',
      'continue': 'Continue',
      'skip': 'Not now',
      'save': 'Save',
      // Export & diagnostics
      'export_section': 'Export',
      'export_my_data': 'Export my data',
      'export_my_data_hint': 'Business profile and transactions',
      'export_diagnostics': 'Export diagnostics',
      'export_diagnostics_hint': 'Debugging info—no secrets',
      'export_in_progress': 'Exporting…',
      'export_saved': 'File saved',
      'export_failed': 'Export failed',
      'share': 'Share',
      'record_test_event': 'Record a test diagnostic event',
      'test_event_recorded': 'Test event recorded',
      'version': 'Version',
    },
  };

  static String get(AppLocale locale, String key) => values[locale]![key]!;
}

enum AppLocale { bangla, english }

/// UI copy contract. The presentation layer must select one locale and never
/// mix scripts on the same screen.
class AppText {
  const AppText._();

  static const Map<AppLocale, Map<String, String>> values = {
    AppLocale.bangla: {
      'app_name': 'সংযোগ',
      'welcome': 'স্বাগতম',
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
    },
    AppLocale.english: {
      'app_name': 'Songjog',
      'welcome': 'Welcome',
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
    },
  };

  static String get(AppLocale locale, String key) => values[locale]![key]!;
}

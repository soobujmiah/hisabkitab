import 'package:flutter/material.dart';

import '../../app/app_services.dart';
import '../../l10n/app_text.dart';
import '../onboarding/onboarding_screen.dart';
import '../settings/settings_screen.dart';
import '../workspace/workspace_home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.services,
    this.locale = AppLocale.bangla,
    this.onLocaleChanged,
  });

  final AppServices services;
  final AppLocale locale;
  final ValueChanged<AppLocale>? onLocaleChanged;

  String t(String key) => AppText.get(locale, key);

  Future<void> _startOnboarding(BuildContext context) async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => OnboardingScreen(
          service: services.onboarding,
          locale: locale,
          diagnostics: services.diagnostics,
        ),
      ),
    );
    if (completed == true && context.mounted) {
      // A completed onboarding replaces the welcome page: the workspace
      // home is where the owner works from here on.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => WorkspaceHomePage(
            services: services,
            locale: locale,
            onLocaleChanged: onLocaleChanged,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('workspace_saved'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: t('settings'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SettingsScreen(
                  services: services,
                  locale: locale,
                  onLocaleChanged: onLocaleChanged,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.account_balance_wallet_rounded, size: 72),
              const SizedBox(height: 24),
              Text(
                t('app_name'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                t('tagline'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                t('tagline_sub'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _startOnboarding(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(t('create_account')),
                ),
              ),
              const SizedBox(height: 12),
              // Authentication and the product tour are later release gates;
              // shown as intentionally disabled in this milestone.
              OutlinedButton(
                onPressed: null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(t('login')),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: null,
                child: Text(t('take_tour')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app_services.dart';
import 'l10n/app_text.dart';
import 'presentation/welcome/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final services = await AppServices.create();
  _installGlobalErrorHandlers(services);

  runApp(SongjogApp(services: services));
}

/// Routes uncaught framework and platform errors into the diagnostic
/// collector so they appear in the diagnostic export without masking the
/// default handling.
void _installGlobalErrorHandlers(AppServices services) {
  final diagnostics = services.diagnostics;

  FlutterError.onError = (details) {
    diagnostics.record(
      level: 'error',
      category: 'render',
      operation: 'flutter_error',
      message: details.exceptionAsString(),
      error: details.exceptionAsString(),
      stackTrace: details.stack?.toString(),
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    diagnostics.record(
      level: 'error',
      category: 'other',
      operation: 'unhandled_exception',
      message: error.toString(),
      stackTrace: stack.toString(),
    );
    return true;
  };
}

class SongjogApp extends StatelessWidget {
  const SongjogApp({super.key, required this.services, this.locale = AppLocale.bangla});

  final AppServices services;
  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppText.get(locale, 'app_name'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF126B5A),
        scaffoldBackgroundColor: const Color(0xFFF7F8F6),
      ),
      home: WelcomePage(services: services, locale: locale),
    );
  }
}

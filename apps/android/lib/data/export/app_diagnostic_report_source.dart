import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/services/diagnostic_collector.dart';
import '../../domain/services/diagnostic_report.dart';
import '../../domain/services/export_service_impl.dart';

/// Application-level [DiagnosticReportSource]: combines the live
/// [DiagnosticCollector] (session + persisted events) with version and
/// device metadata captured once at startup.
///
/// Metadata is captured asynchronously in [AppServices] and injected here so
/// that [build] stays synchronous and deterministic.
class AppDiagnosticReportSource implements DiagnosticReportSource {
  const AppDiagnosticReportSource({
    required this.collector,
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.deviceModel,
    required this.osVersion,
    this.locale,
    this.runtimeMode,
  });

  final DiagnosticCollector collector;
  final String appVersion;
  final String buildNumber;
  final String platform;
  final String deviceModel;
  final String osVersion;
  final String? locale;
  final String? runtimeMode;

  @override
  DiagnosticReport build() {
    return collector.buildReport(
      appVersion: appVersion,
      buildNumber: buildNumber,
      platform: platform,
      deviceModel: deviceModel,
      osVersion: osVersion,
      locale: locale,
      runtimeMode: runtimeMode,
    );
  }
}

/// Default (non-Android-test) version metadata, used when package_info
/// cannot be read.
const kFallbackPackageInfo = '0.0.0 (0)';

String formatPackageInfo(PackageInfo info) =>
    '${info.version} (${info.buildNumber})';

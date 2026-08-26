import 'diagnostic_event.dart';
import 'diagnostic_redaction.dart';

/// The complete, export-ready diagnostic report for the running application.
///
/// All values pass through [DiagnosticRedaction] at serialization time so a
/// report can never carry credentials, even if a future caller adds a
/// sensitive field.
class DiagnosticReport {
  const DiagnosticReport({
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.deviceModel,
    required this.events,
    this.osVersion,
    this.locale,
    this.runtimeMode,
  });

  /// Application version (pubspec `version:`).
  final String appVersion;

  /// Build number (pubspec `+N`).
  final String buildNumber;

  /// Platform family (for example `android`).
  final String platform;

  /// Device model identifier reported by the OS.
  final String deviceModel;

  /// OS version string (for example `16` / `API 36`), when available.
  final String? osVersion;

  /// Active locale tag (for example `bn`, `en`).
  final String? locale;

  /// Runtime mode: `debug`, `profile`, or `release`.
  final String? runtimeMode;

  final List<DiagnosticEvent> events;

  Map<String, Object?> toMap() {
    return DiagnosticRedaction.sanitize({
      'schema_version': 1,
      'app_version': appVersion,
      'build_number': buildNumber,
      'platform': platform,
      'device_model': deviceModel,
      if (osVersion != null) 'os_version': osVersion,
      if (locale != null) 'locale': locale,
      if (runtimeMode != null) 'runtime_mode': runtimeMode,
      'events': events.map((event) => event.toMap()).toList(growable: false),
    });
  }
}

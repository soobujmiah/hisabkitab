import 'diagnostic_event.dart';
import 'diagnostic_redaction.dart';

class DiagnosticReport {
  const DiagnosticReport({
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.deviceModel,
    required this.events,
  });

  final String appVersion;
  final String buildNumber;
  final String platform;
  final String deviceModel;
  final List<DiagnosticEvent> events;

  Map<String, Object?> toMap() {
    return DiagnosticRedaction.sanitize({
      'app_version': appVersion,
      'build_number': buildNumber,
      'platform': platform,
      'device_model': deviceModel,
      'events': events.map((event) => event.toMap()).toList(growable: false),
    });
  }
}

import 'diagnostic_event.dart';
import 'diagnostic_report.dart';

class DiagnosticCollector {
  DiagnosticCollector({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final List<DiagnosticEvent> _events = [];

  void record({
    required String level,
    required String message,
    String? operation,
  }) {
    _events.add(
      DiagnosticEvent(
        timestamp: _clock(),
        level: level,
        message: message,
        operation: operation,
      ),
    );
    if (_events.length > 200) {
      _events.removeRange(0, _events.length - 200);
    }
  }

  DiagnosticReport buildReport({
    required String appVersion,
    required String buildNumber,
    required String platform,
    required String deviceModel,
  }) {
    return DiagnosticReport(
      appVersion: appVersion,
      buildNumber: buildNumber,
      platform: platform,
      deviceModel: deviceModel,
      events: List.unmodifiable(_events),
    );
  }
}

import 'diagnostic_event.dart';
import 'diagnostic_report.dart';
import 'diagnostic_store.dart';

/// Records bounded diagnostic events for the current session.
///
/// Retention is delegated to [DiagnosticStore] (single source of the
/// bounded-retention rule). Optionally, each recorded event is also passed
/// to [persist] so that the persistent diagnostic log can survive process
/// restarts and crashes.
class DiagnosticCollector {
  DiagnosticCollector({
    DateTime Function()? clock,
    DiagnosticStore? store,
    Future<void> Function(DiagnosticEvent event)? persist,
  })  : _clock = clock ?? DateTime.now,
        _store = store ?? DiagnosticStore(),
        _persist = persist;

  final DateTime Function() _clock;
  final DiagnosticStore _store;
  final Future<void> Function(DiagnosticEvent event)? _persist;

  /// Events recorded so far, newest last.
  List<DiagnosticEvent> get events => _store.events;

  void record({
    required String level,
    required String message,
    String? id,
    String? category,
    String? operation,
    String? error,
    String? stackTrace,
    Map<String, Object?> details = const {},
  }) {
    final event = DiagnosticEvent(
      timestamp: _clock(),
      level: level,
      message: message,
      id: id,
      category: category,
      operation: operation,
      error: error,
      stackTrace: stackTrace,
      details: details,
    );
    _store.add(event);
    final persist = _persist;
    if (persist != null) {
      // Persistence must never break the recording path.
      persist(event).catchError((Object _) {});
    }
  }

  DiagnosticReport buildReport({
    required String appVersion,
    required String buildNumber,
    required String platform,
    required String deviceModel,
    String? osVersion,
    String? locale,
    String? runtimeMode,
  }) {
    return DiagnosticReport(
      appVersion: appVersion,
      buildNumber: buildNumber,
      platform: platform,
      deviceModel: deviceModel,
      osVersion: osVersion,
      locale: locale,
      runtimeMode: runtimeMode,
      events: List.unmodifiable(_store.events),
    );
  }
}

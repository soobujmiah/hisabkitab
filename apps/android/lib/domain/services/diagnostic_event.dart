import 'dart:convert';

/// A structured, bounded diagnostic record.
///
/// Events are intentionally non-secret by construction: callers must not pass
/// credentials in [message], [error], or [details]. Everything placed in
/// [details] additionally passes through [DiagnosticRedaction] at report time
/// (see `diagnostic_report.dart`).
class DiagnosticEvent {
  const DiagnosticEvent({
    required this.timestamp,
    required this.level,
    required this.message,
    this.id,
    this.category,
    this.operation,
    this.error,
    this.stackTrace,
    this.details = const {},
  });

  /// Timestamp recorded when the event happened (UTC at serialization time).
  final DateTime timestamp;

  /// One of: `debug`, `info`, `warning`, `error`.
  final String level;

  final String message;

  /// Operation/correlation identifier, when the event belongs to a tracked
  /// operation. Used to correlate failures across export/sync/database paths.
  final String? id;

  /// Structured error category: `database`, `export`, `sync`, `lifecycle`,
  /// `render`, `network`, `onboarding`, or `other`.
  final String? category;

  /// Human-readable operation name (for example `export_user_data`).
  final String? operation;

  /// Exception summary (`Exception: detail` style), when available.
  final String? error;

  /// Stack trace, when available.
  final String? stackTrace;

  /// Extra structured context. Keys matching secret patterns are removed by
  /// [DiagnosticRedaction] before export.
  final Map<String, Object?> details;

  Map<String, Object?> toMap() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'level': level,
        'message': message,
        if (id != null) 'id': id,
        if (category != null) 'category': category,
        if (operation != null) 'operation': operation,
        if (error != null) 'error': error,
        if (stackTrace != null) 'stack_trace': stackTrace,
        if (details.isNotEmpty) 'details': details,
      };

  /// Rehydrates an event from its serialized form (used by the persistent
  /// diagnostic log). Unknown or malformed fields degrade to their absent
  /// state rather than throwing.
  factory DiagnosticEvent.fromMap(Map<String, Object?> map) {
    String? stringOf(Object? value) => value is String ? value : null;
    return DiagnosticEvent(
      timestamp: _parseTimestamp(map['timestamp']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      level: stringOf(map['level']) ?? 'info',
      message: stringOf(map['message']) ?? '',
      id: stringOf(map['id']),
      category: stringOf(map['category']),
      operation: stringOf(map['operation']),
      error: stringOf(map['error']),
      stackTrace: stringOf(map['stack_trace']),
      details: map['details'] is Map
          ? (map['details'] as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            )
          : const {},
    );
  }

  String toJsonLine() => jsonEncode(toMap());

  static DiagnosticEvent? tryParseLine(String line) {
    try {
      final decoded = jsonDecode(line);
      if (decoded is! Map) return null;
      return DiagnosticEvent.fromMap(
        decoded.map((key, value) => MapEntry(key.toString(), value)),
      );
    } catch (_) {
      return null;
    }
  }

  static DateTime? _parseTimestamp(Object? value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }
}

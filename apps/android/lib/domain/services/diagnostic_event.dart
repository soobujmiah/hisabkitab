class DiagnosticEvent {
  const DiagnosticEvent({
    required this.timestamp,
    required this.level,
    required this.message,
    this.operation,
  });

  final DateTime timestamp;
  final String level;
  final String message;
  final String? operation;

  Map<String, Object?> toMap() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'level': level,
        'message': message,
        if (operation != null) 'operation': operation,
      };
}

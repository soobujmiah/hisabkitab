import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/domain/services/diagnostic_event.dart';

void main() {
  test('serializes diagnostic event without secrets', () {
    final event = DiagnosticEvent(
      timestamp: DateTime.utc(2026, 8, 26, 1, 0),
      level: 'error',
      message: 'Database migration failed',
      operation: 'migration',
    );

    final map = event.toMap();

    expect(map['level'], 'error');
    expect(map['message'], 'Database migration failed');
    expect(map['operation'], 'migration');
    expect(map.containsKey('token'), isFalse);
    expect(map.containsKey('api_key'), isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/domain/services/diagnostic_event.dart';
import 'package:songjog/domain/services/diagnostic_store.dart';

void main() {
  test('retains only the configured number of newest events', () {
    final store = DiagnosticStore(maxEvents: 2);
    final first = DiagnosticEvent(
      timestamp: DateTime(2026, 8, 26),
      level: 'error',
      message: 'first',
    );
    final second = DiagnosticEvent(
      timestamp: DateTime(2026, 8, 26, 0, 1),
      level: 'warning',
      message: 'second',
    );
    final third = DiagnosticEvent(
      timestamp: DateTime(2026, 8, 26, 0, 2),
      level: 'error',
      message: 'third',
    );

    store
      ..add(first)
      ..add(second)
      ..add(third);

    expect(store.events, [second, third]);
  });

  test('clear removes all events', () {
    final store = DiagnosticStore();
    store.add(
      DiagnosticEvent(
        timestamp: DateTime(2026, 8, 26),
        level: 'info',
        message: 'event',
      ),
    );

    store.clear();

    expect(store.events, isEmpty);
  });
}

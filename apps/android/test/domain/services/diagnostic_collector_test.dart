import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/domain/services/diagnostic_collector.dart';

void main() {
  test('keeps the most recent 200 diagnostic events', () {
    var tick = 0;
    final collector = DiagnosticCollector(clock: () => DateTime(2026, 8, 26, 0, tick++));

    for (var i = 0; i < 205; i++) {
      collector.record(level: 'error', message: 'event-$i', operation: 'test');
    }

    final report = collector.buildReport(
      appVersion: '0.1.0',
      buildNumber: '1',
      platform: 'android',
      deviceModel: 'test-device',
    );

    expect(report.events, hasLength(200));
    expect(report.events.first.message, 'event-5');
    expect(report.events.last.message, 'event-204');
  });
}

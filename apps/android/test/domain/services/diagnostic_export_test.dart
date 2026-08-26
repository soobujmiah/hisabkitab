import 'package:flutter_test/flutter_test.dart';

import '../../../lib/domain/services/diagnostic_event.dart';
import '../../../lib/domain/services/diagnostic_export.dart';
import '../../../lib/domain/services/diagnostic_report.dart';
oid main() {
  test('serializes diagnostic report without secrets', () {
    final report = DiagnosticReport(
      appVersion: '0.1.0',
      buildNumber: '1',
      platform: 'android',
      deviceModel: 'test-device',
      events: [
        DiagnosticEvent(
          timestamp: DateTime.utc(2026, 1, 1),
          level: 'error',
          message: 'example failure',
          operation: 'save',
        ),
      ],
    );

    final json = DiagnosticExport.toJson(report: report);
    expect(json, contains('example failure'));
    expect(json, contains('diagnostic'));
    expect(json, isNot(contains('api_key')));
  });
}

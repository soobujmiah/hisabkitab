import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../lib/domain/services/diagnostic_event.dart';
import '../../../lib/domain/services/diagnostic_export.dart';
import '../../../lib/domain/services/diagnostic_report.dart';

void main() {
  DiagnosticReport _report({
    List<DiagnosticEvent> events = const [],
    String appVersion = '0.1.0',
    String buildNumber = '1',
  }) {
    return DiagnosticReport(
      appVersion: appVersion,
      buildNumber: buildNumber,
      platform: 'android',
      deviceModel: 'test-device',
      osVersion: '16',
      locale: 'bn',
      runtimeMode: 'debug',
      events: events,
    );
  }

  test('serializes the full expected diagnostic field set', () {
    final report = _report(
      events: [
        DiagnosticEvent(
          timestamp: DateTime.utc(2026, 1, 1),
          level: 'error',
          message: 'example failure',
          id: 'op-123',
          category: 'export',
          operation: 'export_user_data',
          error: 'Exception: disk full',
          stackTrace: 'at test.dart:1',
          details: {'path': '/storage/emulated/0/example'},
        ),
      ],
    );

    final json = DiagnosticExport.toJson(
      report: report,
      filename: 'songjog_diagnostics_20260101_000000.json',
    );
    final decoded = jsonDecode(json) as Map<String, Object?>;

    expect(decoded['kind'], 'diagnostic');
    expect(decoded['filename'], 'songjog_diagnostics_20260101_000000.json');
    final body = decoded['report'] as Map<String, Object?>;
    expect(body['schema_version'], 1);
    expect(body['app_version'], '0.1.0');
    expect(body['build_number'], '1');
    expect(body['platform'], 'android');
    expect(body['device_model'], 'test-device');
    expect(body['os_version'], '16');
    expect(body['locale'], 'bn');
    expect(body['runtime_mode'], 'debug');

    final event = (body['events'] as List).single as Map<String, Object?>;
    expect(event['timestamp'], '2026-01-01T00:00:00.000Z');
    expect(event['level'], 'error');
    expect(event['message'], 'example failure');
    expect(event['id'], 'op-123');
    expect(event['category'], 'export');
    expect(event['operation'], 'export_user_data');
    expect(event['error'], 'Exception: disk full');
    expect(event['stack_trace'], 'at test.dart:1');
    expect(event['details'], {'path': '/storage/emulated/0/example'});
  });

  test('serialization is stable for identical input', () {
    final events = [
      DiagnosticEvent(
        timestamp: DateTime.utc(2026, 2, 3, 4),
        level: 'warning',
        message: 'sync retry',
        operation: 'sync',
      ),
    ];
    final first = DiagnosticExport.toJson(
      report: _report(events: events),
      filename: 'songjog_diagnostics_20260203_040000.json',
    );
    final second = DiagnosticExport.toJson(
      report: _report(events: events),
      filename: 'songjog_diagnostics_20260203_040000.json',
    );
    expect(first, second);
  });

  test('empty diagnostic state produces a valid report with no events', () {
    final json = DiagnosticExport.toJson(
      report: _report(),
      filename: 'songjog_diagnostics_20260101_000000.json',
    );
    final decoded = jsonDecode(json) as Map<String, Object?>;
    final body = decoded['report'] as Map<String, Object?>;
    expect(body['events'], isEmpty);
    expect(body['app_version'], '0.1.0');
  });

  test('error state keeps error records and stack traces', () {
    final report = _report(
      events: [
        DiagnosticEvent(
          timestamp: DateTime.utc(2026, 3, 1),
          level: 'error',
          message: 'export failed',
          category: 'export',
          operation: 'export_user_data',
          error: 'FileSystemException: unable to write',
          stackTrace: '#0 write\n#1 save',
        ),
      ],
    );
    final json = DiagnosticExport.toJson(
      report: report,
      filename: 'songjog_diagnostics_20260301_000000.json',
    );
    expect(json, contains('FileSystemException: unable to write'));
    expect(json, contains('#0 write'));
    expect(json, contains('"category": "export"'));
  });

  test('redacts secrets nested in event details', () {
    final report = _report(
      events: [
        DiagnosticEvent(
          timestamp: DateTime.utc(2026, 1, 1),
          level: 'error',
          message: 'auth failure',
          details: {
            'endpoint': 'https://example.com/api',
            'access_token': 'leak-me',
            'user_password': 'leak-me-too',
            'retries': 3,
          },
        ),
      ],
    );
    final json = DiagnosticExport.toJson(
      report: report,
      filename: 'songjog_diagnostics_20260101_000000.json',
    );
    expect(json, contains('https://example.com/api'));
    expect(json, isNot(contains('leak-me')));
    expect(json, isNot(contains('access_token')));
    expect(json, isNot(contains('user_password')));
  });

  test('isDiagnosticPayload detects diagnostic exports only', () {
    final json = DiagnosticExport.toJson(
      report: _report(),
      filename: 'songjog_diagnostics_20260101_000000.json',
    );
    expect(DiagnosticExport.isDiagnosticPayload(json), isTrue);
    expect(DiagnosticExport.isDiagnosticPayload('{"kind":"user_data"}'), isFalse);
    expect(DiagnosticExport.isDiagnosticPayload('not json'), isFalse);
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/data/local/in_memory_store.dart';
import 'package:songjog/domain/models/business_profile.dart';
import 'package:songjog/domain/models/transaction.dart';
import 'package:songjog/domain/services/diagnostic_event.dart';
import 'package:songjog/domain/services/diagnostic_report.dart';
import 'package:songjog/domain/services/export_service_impl.dart';
import 'package:songjog/domain/services/export_type.dart';

class _FakeReportSource implements DiagnosticReportSource {
  _FakeReportSource(this.report);

  final DiagnosticReport report;

  @override
  DiagnosticReport build() => report;
}

void main() {
  final fixedClock = DateTime.utc(2026, 8, 26, 10, 30, 45);

  Future<LocalStore> storeWithTransaction() async {
    final store = InMemoryStore();
    await store.saveBusinessProfile(const BusinessProfile(
      id: 'p1',
      name: 'Demo',
      workspaceKind: WorkspaceKind.business,
      businessType: BusinessType.retail,
    ));
    await store.saveTransaction(TransactionRecord(
      id: 't1',
      type: TransactionType.sale,
      createdAt: DateTime(2026, 8, 20),
      paymentStatus: PaymentStatus.paid,
      paidMinor: 1000,
      lines: const [
        TransactionLine(
          id: 'l1',
          description: 'Item',
          quantity: 1,
          sellingPriceMinor: 1000,
        ),
      ],
    ));
    return store;
  }

  DiagnosticReport makeReport(List<DiagnosticEvent> events) {
    return DiagnosticReport(
      appVersion: '0.1.0',
      buildNumber: '1',
      platform: 'android',
      deviceModel: 'redmi-turbo-4-pro',
      osVersion: '16',
      locale: 'bn',
      runtimeMode: 'debug',
      events: events,
    );
  }

  group('DefaultExportService user data', () {
    test('produces a deterministic JSON payload with stable filename and MIME', () async {
      final service = DefaultExportService(
        store: await storeWithTransaction(),
        clock: () => fixedClock,
      );

      final payload = await service.export(
        const ExportRequest(type: ExportType.userData),
      );

      expect(payload.mimeType, 'application/json');
      expect(payload.filename, 'songjog_data_20260826_103045.json');
      final decoded = jsonDecode(payload.content) as Map<String, Object?>;
      expect((decoded['manifest'] as Map<String, Object?>)['kind'], 'user_data');
      expect((decoded['manifest'] as Map<String, Object?>)['created_at'], '2026-08-26T10:30:45.000Z');
      expect(payload.content, contains('Demo'));
      expect(payload.content, contains('"t1"'));
    });

    test('applies date-range filtering to exported transactions', () async {
      final service = DefaultExportService(
        store: await storeWithTransaction(),
        clock: () => fixedClock,
      );

      final payload = await service.export(
        ExportRequest(
          type: ExportType.userData,
          start: DateTime(2026, 8, 21),
          end: DateTime(2026, 8, 25),
        ),
      );

      expect(payload.content, isNot(contains('"t1"')));
      expect(payload.content, contains('Demo'));
    });

    test('rejects a range whose start is after its end', () async {
      final service = DefaultExportService(
        store: await storeWithTransaction(),
      );
      await expectLater(
        service.export(
          ExportRequest(
            type: ExportType.userData,
            start: DateTime(2026, 8, 30),
            end: DateTime(2026, 8, 1),
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  group('DefaultExportService diagnostic', () {
    test('exports report metadata and events with stable filename', () async {
      final service = DefaultExportService(
        store: InMemoryStore(),
        reportSource: _FakeReportSource(
          makeReport([
            DiagnosticEvent(
              timestamp: DateTime.utc(2026, 8, 26, 9),
              level: 'error',
              message: 'db open failed',
              category: 'database',
              operation: 'database_open',
              error: 'SqliteException: no such table',
              stackTrace: '#0 open',
            ),
          ]),
        ),
        clock: () => fixedClock,
      );

      final payload = await service.export(
        const ExportRequest(type: ExportType.diagnostic),
      );

      expect(payload.mimeType, 'application/json');
      expect(payload.filename, 'songjog_diagnostics_20260826_103045.json');
      final decoded = jsonDecode(payload.content) as Map<String, Object?>;
      expect(decoded['kind'], 'diagnostic');
      expect(decoded['filename'], payload.filename);
      final body = decoded['report'] as Map<String, Object?>;
      expect(body['app_version'], '0.1.0');
      expect(body['device_model'], 'redmi-turbo-4-pro');
      expect(body['runtime_mode'], 'debug');
      expect(body['events'], hasLength(1));
    });

    test('filters diagnostic events by the requested range', () async {
      final service = DefaultExportService(
        store: InMemoryStore(),
        reportSource: _FakeReportSource(
          makeReport([
            DiagnosticEvent(
              timestamp: DateTime.utc(2026, 8, 20),
              level: 'info',
              message: 'early event',
            ),
            DiagnosticEvent(
              timestamp: DateTime.utc(2026, 8, 26),
              level: 'error',
              message: 'late event',
            ),
          ]),
        ),
        clock: () => fixedClock,
      );

      final payload = await service.export(
        ExportRequest(
          type: ExportType.diagnostic,
          start: DateTime.utc(2026, 8, 21),
        ),
      );

      expect(payload.content, contains('late event'));
      expect(payload.content, isNot(contains('early event')));
    });

    test('throws StateError when no report source is configured', () async {
      final service = DefaultExportService(store: InMemoryStore());
      await expectLater(
        service.export(const ExportRequest(type: ExportType.diagnostic)),
        throwsStateError,
      );
    });
  });

  group('determinism', () {
    test('the same clock produces identical payloads twice', () async {
      final service = DefaultExportService(
        store: await storeWithTransaction(),
        clock: () => fixedClock,
      );
      final first = await service.export(
        const ExportRequest(type: ExportType.userData),
      );
      final second = await service.export(
        const ExportRequest(type: ExportType.userData),
      );
      expect(first.content, second.content);
      expect(first.filename, second.filename);
    });
  });
}

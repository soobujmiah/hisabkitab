import '../../data/local/in_memory_store.dart';
import 'diagnostic_event.dart';
import 'diagnostic_export.dart';
import 'diagnostic_report.dart';
import 'export_filename.dart';
import 'export_payload.dart';
import 'export_service.dart';
import 'export_type.dart';
import 'user_data_export.dart';

/// Supplies the current [DiagnosticReport] when a diagnostic export is
/// requested. The application layer implements this with the live
/// [DiagnosticCollector] plus package/device metadata.
abstract interface class DiagnosticReportSource {
  DiagnosticReport build();
}

/// Default [ExportService] covering both mandatory export kinds:
/// user data and developer diagnostics.
///
/// Behavior contract:
/// - Filenames are deterministic for a given clock (see [exportFilename]).
/// - Both payloads are stable, indented JSON with `application/json` MIME.
/// - Invalid requests (date range where `start` is after `end`) throw
///   [ArgumentError].
/// - A diagnostic request without a [DiagnosticReportSource] throws
///   [StateError] (unsupported configuration, not a user error).
/// - For diagnostic exports, an optional date range filters the included
///   events.
class DefaultExportService implements ExportService {
  const DefaultExportService({
    required this.store,
    this.reportSource,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final LocalStore store;
  final DiagnosticReportSource? reportSource;
  final DateTime Function() _clock;

  @override
  Future<ExportPayload> export(ExportRequest request) async {
    _validate(request);
    final createdAt = _clock();
    switch (request.type) {
      case ExportType.userData:
        final content = await UserDataExport.toJson(
          store: store,
          start: request.start,
          end: request.end,
          clock: _clock,
        );
        return ExportPayload(
          filename: exportFilename(
            type: ExportType.userData,
            createdAt: createdAt,
          ),
          mimeType: 'application/json',
          content: content,
        );
      case ExportType.diagnostic:
        final source = reportSource;
        if (source == null) {
          throw StateError(
            'Diagnostic export requires a DiagnosticReportSource.',
          );
        }
        final report = source.build();
        final events = _filterByRange(report.events, request);
        final filtered = DiagnosticReport(
          appVersion: report.appVersion,
          buildNumber: report.buildNumber,
          platform: report.platform,
          deviceModel: report.deviceModel,
          osVersion: report.osVersion,
          locale: report.locale,
          runtimeMode: report.runtimeMode,
          events: events,
        );
        final filename = exportFilename(
          type: ExportType.diagnostic,
          createdAt: createdAt,
        );
        return ExportPayload(
          filename: filename,
          mimeType: 'application/json',
          content: DiagnosticExport.toJson(report: filtered, filename: filename),
        );
    }
  }

  List<DiagnosticEvent> _filterByRange(
    List<DiagnosticEvent> events,
    ExportRequest request,
  ) {
    final start = request.start;
    final end = request.end;
    if (start == null && end == null) return events;
    return events.where((event) {
      final timestamp = event.timestamp;
      if (start != null && timestamp.isBefore(start)) return false;
      if (end != null && timestamp.isAfter(end)) return false;
      return true;
    }).toList(growable: false);
  }

  void _validate(ExportRequest request) {
    final start = request.start;
    final end = request.end;
    if (start != null && end != null && start.isAfter(end)) {
      throw ArgumentError.value(
        end,
        'end',
        'end must not be before start (${start.toIso8601String()})',
      );
    }
  }
}

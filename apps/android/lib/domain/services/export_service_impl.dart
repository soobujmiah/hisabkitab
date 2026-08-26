import 'diagnostic_export.dart';
import 'diagnostic_report.dart';
import 'export_payload.dart';
import 'export_service.dart';
import 'export_type.dart';
import 'user_data_export.dart';

class DefaultExportService implements ExportService {
  const DefaultExportService({required this.store});

  final dynamic store;

  @override
  Future<ExportPayload> export(ExportRequest request) async {
    switch (request.type) {
      case ExportType.userData:
        final content = await UserDataExport.toJson(
          store: store,
          start: request.start,
          end: request.end,
        );
        return ExportPayload(
          filename: 'songjog_data.json',
          mimeType: 'application/json',
          content: content,
        );
      case ExportType.diagnostic:
        throw UnsupportedError(
          'Diagnostic export requires a DiagnosticReport provider.',
        );
    }
  }
}

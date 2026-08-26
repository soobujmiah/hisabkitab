import 'export_payload.dart';
import 'export_type.dart';

abstract interface class ExportService {
  Future<ExportPayload> export(ExportRequest request);
}

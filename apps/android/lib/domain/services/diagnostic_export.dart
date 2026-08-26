import 'dart:convert';

import 'diagnostic_report.dart';
import 'export_filename.dart';
import 'export_type.dart';

class DiagnosticExport {
  const DiagnosticExport._();

  static String toJson({required DiagnosticReport report}) {
    return const JsonEncoder.withIndent('  ').convert({
      'kind': 'diagnostic',
      'filename': exportFilename(
        type: ExportType.diagnostic,
        createdAt: DateTime.now(),
      ),
      'report': report.toMap(),
    });
  }
}

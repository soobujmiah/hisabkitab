import 'dart:convert';

import 'diagnostic_report.dart';

/// Serializes a [DiagnosticReport] into the stable JSON export format.
class DiagnosticExport {
  const DiagnosticExport._();

  /// [filename] must be the exact filename used for the exported file
  /// (normally produced by [exportFilename]) so the payload, the file, and
  /// the manifest entry always agree.
  static String toJson({
    required DiagnosticReport report,
    required String filename,
  }) {
    return const JsonEncoder.withIndent('  ').convert({
      'kind': 'diagnostic',
      'filename': filename,
      'report': report.toMap(),
    });
  }

  static bool isDiagnosticPayload(String content) {
    try {
      final decoded = jsonDecode(content);
      return decoded is Map && decoded['kind'] == 'diagnostic';
    } catch (_) {
      return false;
    }
  }
}

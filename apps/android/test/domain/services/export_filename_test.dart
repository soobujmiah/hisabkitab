import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/domain/services/export_filename.dart';
import 'package:songjog/domain/services/export_type.dart';

void main() {
  test('generates deterministic user-data filenames', () {
    final name = exportFilename(
      type: ExportType.userData,
      createdAt: DateTime.utc(2026, 8, 26, 10, 30, 45),
    );
    expect(name, 'songjog_data_20260826_103045.json');
  });

  test('generates deterministic diagnostic filenames', () {
    final name = exportFilename(
      type: ExportType.diagnostic,
      createdAt: DateTime.utc(2026, 1, 2, 3, 4, 5),
    );
    expect(name, 'songjog_diagnostics_20260102_030405.json');
  });

  test('pads single-digit fields with zeros', () {
    final name = exportFilename(
      type: ExportType.userData,
      createdAt: DateTime.utc(2026, 1, 5, 6, 7, 8),
    );
    expect(name, 'songjog_data_20260105_060708.json');
  });

  test('supports a custom extension', () {
    final name = exportFilename(
      type: ExportType.userData,
      createdAt: DateTime.utc(2026, 8, 26),
      extension: 'csv',
    );
    expect(name, endsWith('.csv'));
    expect(name, startsWith('songjog_data_'));
  });

  test('filenames never contain path separators', () {
    final name = exportFilename(
      type: ExportType.diagnostic,
      createdAt: DateTime.utc(2026, 12, 31, 23, 59, 59),
    );
    expect(name.contains('/'), isFalse);
    expect(name.contains('\\'), isFalse);
    expect(name, matches(RegExp(r'^songjog_[a-z]+_\d{8}_\d{6}\.json$')));
  });
}

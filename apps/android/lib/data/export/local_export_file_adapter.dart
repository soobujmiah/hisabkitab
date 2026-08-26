import 'dart:io';

import '../../domain/services/export_payload.dart';

class LocalExportFileAdapter implements ExportFileAdapter {
  const LocalExportFileAdapter({required this.directory});

  final Directory directory;

  @override
  Future<String> save(ExportPayload payload) async {
    await directory.create(recursive: true);
    final file = File('${directory.path}/${payload.filename}');
    await file.writeAsString(payload.content, flush: true);
    return file.path;
  }

  @override
  Future<void> share(ExportPayload payload) {
    throw UnsupportedError(
      'Platform share requires an Android share adapter.',
    );
  }
}

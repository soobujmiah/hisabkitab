import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/data/export/local_export_file_adapter.dart';
import 'package:songjog/domain/services/export_payload.dart';

void main() {
  late Directory tempDirectory;
  late LocalExportFileAdapter adapter;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('songjog_export_');
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('creates a missing directory before writing', () async {
    final nested = Directory('${tempDirectory.path}/a/b/c');
    adapter = LocalExportFileAdapter(directory: nested);
    final payload = const ExportPayload(
      filename: 'songjog_data_20260826_103045.json',
      mimeType: 'application/json',
      content: '{"ok":true}',
    );

    final path = await adapter.save(payload);

    expect(path, endsWith('a/b/c/songjog_data_20260826_103045.json'));
    expect(await File(path).exists(), isTrue);
  });

  test('writes content that reads back identically', () async {
    adapter = LocalExportFileAdapter(directory: tempDirectory);
    const content = '{"manifest":{"kind":"user_data"},"transactions":[]}';
    final payload = const ExportPayload(
      filename: 'songjog_data_20260826_103045.json',
      mimeType: 'application/json',
      content: content,
    );

    final path = await adapter.save(payload);

    final readBack = await File(path).readAsString();
    expect(readBack, content);
    expect(readBack.length, content.length);
  });

  test('creates the file under the exact payload filename', () async {
    adapter = LocalExportFileAdapter(directory: tempDirectory);
    const payload = ExportPayload(
      filename: 'songjog_diagnostics_20260826_103045.json',
      mimeType: 'application/json',
      content: '{}',
    );

    final path = await adapter.save(payload);

    final names = tempDirectory.listSync().map((e) => e.path).toList();
    expect(names.length, 1);
    expect(names.single, endsWith(payload.filename));
    expect(path, endsWith(payload.filename));
  });

  test('refuses to write through a directory whose path is a file', () async {
    final blocker = File('${tempDirectory.path}/blocker');
    await blocker.writeAsString('not a directory');
    adapter = LocalExportFileAdapter(
      directory: Directory('${blocker.path}/sub'),
    );
    final payload = const ExportPayload(
      filename: 'songjog_data_20260826_103045.json',
      mimeType: 'application/json',
      content: '{}',
    );

    await expectLater(
      adapter.save(payload),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('share() is unsupported on the local adapter by design', () async {
    adapter = LocalExportFileAdapter(directory: tempDirectory);
    final payload = const ExportPayload(
      filename: 'songjog_data.json',
      mimeType: 'application/json',
      content: '{}',
    );
    expect(() => adapter.share(payload), throwsUnsupportedError);
  });
}

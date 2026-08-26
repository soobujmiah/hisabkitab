class ExportPayload {
  const ExportPayload({
    required this.filename,
    required this.mimeType,
    required this.content,
  });

  final String filename;
  final String mimeType;
  final String content;
}

abstract interface class ExportFileAdapter {
  Future<String> save(ExportPayload payload);
  Future<void> share(ExportPayload payload);
}

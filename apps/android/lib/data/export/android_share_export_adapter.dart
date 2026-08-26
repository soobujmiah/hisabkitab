import '../../domain/services/export_payload.dart';

/// Android-facing share boundary. The concrete platform channel can be
/// attached without coupling domain/application code to Android APIs.
class AndroidShareExportAdapter implements ExportFileAdapter {
  const AndroidShareExportAdapter({required this.shareCallback});

  final Future<void> Function(ExportPayload payload) shareCallback;

  @override
  Future<String> save(ExportPayload payload) {
    throw UnsupportedError('Use a local file adapter for saving exports.');
  }

  @override
  Future<void> share(ExportPayload payload) => shareCallback(payload);
}

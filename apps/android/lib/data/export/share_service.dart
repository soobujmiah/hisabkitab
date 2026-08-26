import 'package:share_plus/share_plus.dart';

/// Boundary for platform sharing. The application talks to this interface
/// only; the concrete Android implementation uses share_plus (ACTION_SEND
/// with a FileProvider, no extra runtime permissions required for
/// app-specific external storage).
abstract interface class ShareService {
  /// Shares a local file through the platform share sheet.
  ///
  /// Returns true when the share request was dispatched, false when the
  /// platform reported failure or the user dismissed the sheet.
  Future<bool> shareFile({
    required String path,
    required String mimeType,
    String? title,
  });
}

class AndroidShareService implements ShareService {
  const AndroidShareService();

  @override
  Future<bool> shareFile({
    required String path,
    required String mimeType,
    String? title,
  }) async {
    final result = await SharePlus.instance.share(
      ShareParams(
        title: title,
        files: [XFile(path)],
      ),
    );
    // `success` = the platform dispatched the share. `dismissed` and
    // `unavailable` mean no action was taken (or no sheet exists), which the
    // caller treats as "not completed".
    return result.status == ShareResultStatus.success;
  }
}

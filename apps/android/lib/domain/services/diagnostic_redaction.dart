/// Removes credentials and secret-looking keys from diagnostic data before
/// export.
///
/// Redaction is recursive: nested maps and lists are sanitized as well.
/// Blocked keys are dropped entirely (not value-masked) so that no fragment
/// of a secret can leak through downstream logging or transport.
class DiagnosticRedaction {
  const DiagnosticRedaction._();

  /// Keys that are never allowed in diagnostic exports.
  static const blockedKeys = <String>{
    'password',
    'passwd',
    'pass',
    'token',
    'access_token',
    'refresh_token',
    'id_token',
    'session_token',
    'api_key',
    'apikey',
    'secret',
    'client_secret',
    'private_key',
    'signing_key',
    'credential',
    'credentials',
    'authorization',
    'auth',
    'cookie',
    'cookies',
    'bearer',
  };

  /// Keys ending with any of these (after a separator) are treated as secret.
  static const blockedSuffixes = <String>{
    'password',
    'token',
    'api_key',
    'secret',
    'private_key',
    'credential',
    'authorization',
    'cookie',
  };

  static bool isBlockedKey(String key) {
    final lowered = key.toLowerCase();
    if (blockedKeys.contains(lowered)) return true;
    for (final suffix in blockedSuffixes) {
      if (lowered.endsWith('_$suffix') || lowered.endsWith('-$suffix')) {
        return true;
      }
    }
    return false;
  }

  /// Returns a copy of [input] with all blocked keys removed (recursively).
  static Map<String, Object?> sanitize(Map<String, Object?> input) {
    final result = <String, Object?>{};
    for (final entry in input.entries) {
      if (!isBlockedKey(entry.key)) {
        result[entry.key] = _sanitizeValue(entry.value);
      }
    }
    return result;
  }

  static Object? _sanitizeValue(Object? value) {
    if (value is Map) {
      return sanitize(
        value.map((key, v) => MapEntry(key.toString(), v)),
      );
    }
    if (value is List) {
      return value.map(_sanitizeValue).toList(growable: false);
    }
    return value;
  }
}

class DiagnosticRedaction {
  const DiagnosticRedaction._();

  static const blockedKeys = <String>{
    'password',
    'token',
    'access_token',
    'refresh_token',
    'api_key',
    'secret',
    'private_key',
  };

  static Map<String, Object?> sanitize(Map<String, Object?> input) {
    return Map.fromEntries(
      input.entries.where((entry) => !blockedKeys.contains(entry.key)),
    );
  }
}

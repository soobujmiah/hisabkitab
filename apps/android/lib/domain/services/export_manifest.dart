class ExportManifest {
  const ExportManifest({
    required this.schemaVersion,
    required this.createdAt,
    required this.kind,
    required this.sections,
  });

  final int schemaVersion;
  final DateTime createdAt;
  final String kind;
  final List<String> sections;

  Map<String, Object> toMap() => {
        'schema_version': schemaVersion,
        'created_at': createdAt.toUtc().toIso8601String(),
        'kind': kind,
        'sections': sections,
      };
}

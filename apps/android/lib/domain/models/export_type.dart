enum ExportType {
  userData,
  diagnostic,
}

class ExportRequest {
  const ExportRequest({
    required this.type,
    this.start,
    this.end,
    this.includeDocuments = true,
  });

  final ExportType type;
  final DateTime? start;
  final DateTime? end;
  final bool includeDocuments;
}

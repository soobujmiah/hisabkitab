enum ExportType {
  userData,
  diagnostic,
}

class ExportRequest {
  const ExportRequest({
    required this.type,
    this.start,
    this.end,
  });

  final ExportType type;
  final DateTime? start;
  final DateTime? end;
}

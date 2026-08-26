String exportFilename({
  required String kind,
  required DateTime createdAt,
  String extension = 'json',
}) {
  final utc = createdAt.toUtc();
  final stamp = '${utc.year.toString().padLeft(4, '0')}'
      '${utc.month.toString().padLeft(2, '0')}'
      '${utc.day.toString().padLeft(2, '0')}_'
      '${utc.hour.toString().padLeft(2, '0')}'
      '${utc.minute.toString().padLeft(2, '0')}'
      '${utc.second.toString().padLeft(2, '0')}';
  return 'songjog_${kind}_$stamp.$extension';
}

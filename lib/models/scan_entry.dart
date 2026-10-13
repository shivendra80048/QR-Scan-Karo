class ScanEntry {
  const ScanEntry({
    required this.value,
    required this.date,
    this.isGenerated = false,
  });
  final String value;
  final DateTime date;
  final bool isGenerated;
}

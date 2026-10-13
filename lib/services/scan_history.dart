import 'package:flutter/foundation.dart';
import '../models/scan_entry.dart';

class ScanHistory extends ChangeNotifier {
  ScanHistory._();
  static final ScanHistory instance = ScanHistory._();
  final List<ScanEntry> _entries = [];
  List<ScanEntry> get entries => List.unmodifiable(_entries);
  void add(String value, {bool generated = false}) {
    _entries.insert(
      0,
      ScanEntry(value: value, date: DateTime.now(), isGenerated: generated),
    );
    if (_entries.length > 100) _entries.removeLast();
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }
}

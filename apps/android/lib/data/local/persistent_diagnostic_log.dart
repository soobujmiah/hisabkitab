import 'dart:io';

import '../../domain/services/diagnostic_event.dart';

/// Appends diagnostic events to a bounded JSONL file so that the diagnostic
/// export on the *next* launch still contains evidence from a crashed or
/// force-stopped previous run.
///
/// This is deliberately simple: the log is bounded ([maxEvents]), rewritten
/// whole on each append, and tolerant of corrupted lines. It stores
/// diagnostic metadata only — never user financial data or secrets.
class PersistentDiagnosticLog {
  PersistentDiagnosticLog(this.file, {this.maxEvents = 200});

  final File file;
  final int maxEvents;

  List<DiagnosticEvent> _events = [];

  List<DiagnosticEvent> get events => List.unmodifiable(_events);

  bool get isLoaded => _loaded;
  bool _loaded = false;

  /// Loads existing events. A missing file yields an empty log; a corrupted
  /// file keeps every parseable line.
  Future<void> load() async {
    if (!await file.exists()) {
      _loaded = true;
      return;
    }
    final lines = await file.readAsLines();
    final events = <DiagnosticEvent>[];
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final event = DiagnosticEvent.tryParseLine(line);
      if (event != null) events.add(event);
    }
    if (events.length > maxEvents) {
      events.removeRange(0, events.length - maxEvents);
    }
    _events = events;
    _loaded = true;
  }

  Future<void> append(DiagnosticEvent event) async {
    await file.parent.create(recursive: true);
    _events.add(event);
    if (_events.length > maxEvents) {
      _events.removeRange(0, _events.length - maxEvents);
    }
    final buffer = StringBuffer();
    for (final item in _events) {
      buffer
        ..write(item.toJsonLine())
        ..write('\n');
    }
    await file.writeAsString(buffer.toString(), flush: true);
  }

  Future<void> clear() async {
    _events = [];
    if (await file.exists()) {
      await file.writeAsString('');
    }
  }
}

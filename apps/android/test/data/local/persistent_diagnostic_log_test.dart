import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/data/local/persistent_diagnostic_log.dart';
import 'package:songjog/domain/services/diagnostic_event.dart';

void main() {
  late Directory tempDirectory;
  late File logFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('songjog_diaglog_');
    logFile = File('${tempDirectory.path}/diagnostics.jsonl');
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  DiagnosticEvent event(String message, DateTime at) {
    return DiagnosticEvent(
      timestamp: at,
      level: 'error',
      message: message,
      category: 'export',
      operation: 'export_user_data',
    );
  }

  test('missing file loads as an empty log', () async {
    final log = PersistentDiagnosticLog(logFile);
    await log.load();
    expect(log.events, isEmpty);
    expect(log.isLoaded, isTrue);
  });

  test('appended events survive reload', () async {
    final log = PersistentDiagnosticLog(logFile);
    await log.load();
    await log.append(event('first', DateTime.utc(2026, 8, 26, 10)));
    await log.append(event('second', DateTime.utc(2026, 8, 26, 11)));

    final reloaded = PersistentDiagnosticLog(logFile);
    await reloaded.load();

    expect(reloaded.events, hasLength(2));
    expect(reloaded.events.first.message, 'first');
    expect(reloaded.events.last.message, 'second');
    expect(reloaded.events.last.category, 'export');
    expect(reloaded.events.last.operation, 'export_user_data');
    expect(reloaded.events.last.timestamp, DateTime.utc(2026, 8, 26, 11));
  });

  test('retention keeps only the newest events', () async {
    final log = PersistentDiagnosticLog(logFile, maxEvents: 3);
    await log.load();
    for (var i = 0; i < 5; i++) {
      await log.append(event('event-$i', DateTime.utc(2026, 8, 26, i)));
    }

    final reloaded = PersistentDiagnosticLog(logFile, maxEvents: 3);
    await reloaded.load();

    expect(reloaded.events.map((e) => e.message).toList(),
        ['event-2', 'event-3', 'event-4']);
  });

  test('corrupted lines are skipped without losing valid events', () async {
    await logFile.writeAsString(
      '${event('valid', DateTime.utc(2026, 8, 26)).toJsonLine()}\n'
      'this is not json\n'
      '[1,2,3]\n'
      '${event('also-valid', DateTime.utc(2026, 8, 27)).toJsonLine()}\n',
    );

    final log = PersistentDiagnosticLog(logFile);
    await log.load();

    expect(log.events.map((e) => e.message).toList(),
        ['valid', 'also-valid']);
  });

  test('clear removes all stored events', () async {
    final log = PersistentDiagnosticLog(logFile);
    await log.load();
    await log.append(event('gone', DateTime.utc(2026, 8, 26)));
    await log.clear();

    expect(log.events, isEmpty);
    final reloaded = PersistentDiagnosticLog(logFile);
    await reloaded.load();
    expect(reloaded.events, isEmpty);
  });
}

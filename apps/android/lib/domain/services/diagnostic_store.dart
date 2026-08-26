import 'diagnostic_event.dart';

class DiagnosticStore {
  DiagnosticStore({this.maxEvents = 200});

  final int maxEvents;
  final List<DiagnosticEvent> _events = [];

  void add(DiagnosticEvent event) {
    _events.add(event);
    if (_events.length > maxEvents) {
      _events.removeRange(0, _events.length - maxEvents);
    }
  }

  List<DiagnosticEvent> get events => List.unmodifiable(_events);

  void clear() => _events.clear();
}

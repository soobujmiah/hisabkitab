enum ProgramKind { trade, course, program }

class TradeProgram {
  const TradeProgram({
    required this.id,
    required this.name,
    required this.kind,
    this.code,
    this.active = true,
  });

  final String id;
  final String name;
  final ProgramKind kind;
  final String? code;
  final bool active;
}

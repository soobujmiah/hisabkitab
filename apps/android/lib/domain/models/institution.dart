class TrainingProgram {
  const TrainingProgram({
    required this.id,
    required this.name,
    this.code,
    this.description,
  });

  final String id;
  final String name;
  final String? code;
  final String? description;
}

class TrainingBatch {
  const TrainingBatch({
    required this.id,
    required this.programId,
    required this.name,
    this.startDate,
    this.endDate,
  });

  final String id;
  final String programId;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
}

class Learner {
  const Learner({
    required this.id,
    required this.name,
    this.programId,
    this.batchId,
    this.phone,
    this.guardianName,
  });

  final String id;
  final String name;
  final String? programId;
  final String? batchId;
  final String? phone;
  final String? guardianName;
}

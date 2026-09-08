enum TrainingStatus { pending, approved, rejected }

class TrainingOpportunity {
  final String id;
  final String title;
  final String description;
  final String companyId;
  final String typeId;
  final List<String> specializationIds;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final int durationHours;
  final int capacity;
  final TrainingStatus status;
  final DateTime createdAt;
  final bool isActive;

  TrainingOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.companyId,
    required this.typeId,
    required this.specializationIds,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.durationHours,
    required this.capacity,
    this.status = TrainingStatus.pending,
    required this.createdAt,
    this.isActive = true,
  });

  factory TrainingOpportunity.fromMap(Map<String, dynamic> map) {
    return TrainingOpportunity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      companyId: map['companyId'] ?? '',
      typeId: map['typeId'] ?? '',
      specializationIds: List<String>.from(map['specializationIds'] ?? []),
      location: map['location'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      durationHours: map['durationHours'] ?? 0,
      capacity: map['capacity'] ?? 0,
      status: TrainingStatus.values[map['status'] ?? 0],
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'companyId': companyId,
      'typeId': typeId,
      'specializationIds': specializationIds,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'durationHours': durationHours,
      'capacity': capacity,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
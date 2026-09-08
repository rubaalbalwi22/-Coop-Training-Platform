// student/models/training_opportunity_model.dart
class TrainingOpportunity {
  final int id;
  final String title;
  final String description;
  final String type;
  final String mode; // حضوري/عن بُعد
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String companyName;
  final int specializationId;
  final String specialization;
  final int durationHours;
  final int capacity;
  final bool isActive;

  TrainingOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.mode,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.companyName,
    required this.specializationId,
    required this.specialization,
    required this.durationHours,
    required this.capacity,
    required this.isActive,
  });
}
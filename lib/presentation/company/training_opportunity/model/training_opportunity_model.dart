// company/models/training_opportunity_model.dart
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';

class TrainingOpportunity {
  String? id;
  String? companyId;
  String? companyName;

  String? title;
  String? description;
  String? type; // نوع التدريب
  String? mode; // حضوري/عن بُعد
  int? durationHours; // عدد الساعات
  int? capacity; // عدد المقاعد
  String? location;
  DateTime? startDate;
  DateTime? endDate;
  String? status; // pending, approved, rejected
  String? rejectionReason;
  DateTime? createdAt;
  bool? isActive; // true if opportunity is available for students to apply
  List<String>? criteria;
  List<AppUser>? participants ;

  TrainingOpportunity({
      this.id,
      this.companyId,
    required this.title,
    required this.description,
    required this.type,
    required this.mode,
    required this.durationHours,
    required this.capacity,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.status = 'pending',
    this.rejectionReason,
    required this.createdAt,
    this.isActive = true,
    this.criteria = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'type': type,
      'mode': mode,
      'durationHours': durationHours,
      'capacity': capacity,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt?.toIso8601String(),
      'isActive': isActive,
      'criteria': criteria
    };
  }

  factory TrainingOpportunity.fromJson(Map<String, dynamic> json) {
    return TrainingOpportunity(
      id: json['id'],
      companyId: json['companyId'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      mode: json['mode'],
      durationHours: json['durationHours'],
      capacity: json['capacity'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      rejectionReason: json['rejectionReason'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
      criteria: List<String>.from(json['criteria']),
    );
  }
}
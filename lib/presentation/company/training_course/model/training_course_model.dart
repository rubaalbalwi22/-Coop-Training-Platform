// company/models/training_course_model.dart
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';

class TrainingCourse {
    String? id;
    String? companyId;
    String? companyName;
    String title;
    String description;
    String category;
    String level; // مبتدئ، متوسط، متقدم
    String mode; // حضوري، عن بُعد، هجين
    int duration; // عدد الأسابيع
    int hoursPerWeek;
    String location;
    DateTime startDate;
    DateTime endDate;
    int maxParticipants;
    String imageUrl;
    bool isActive;
    DateTime createdAt;
    DateTime? updatedAt;
    CourseStatus status;
    List<String>? criteria;
    List<AppUser>? participants;

  TrainingCourse({
    this.id,
    this.companyId,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.mode,
    required this.duration,
    required this.hoursPerWeek,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    this.criteria
  });

  // دالة لتحويل النموذج إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'mode': mode,
      'duration': duration,
      'hours_per_week': hoursPerWeek,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'max_participants': maxParticipants,
      'image_url': imageUrl,
      'is_active': isActive,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'criteria': criteria
    };
  }

  // دالة لإنشاء نموذج من Map
  factory TrainingCourse.fromMap(Map<String, dynamic> map) {
    return TrainingCourse(
      id: map['id'],
      companyId: map['company_id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      level: map['level'],
      mode: map['mode'],
      duration: map['duration'],
      hoursPerWeek: map['hours_per_week'],
      location: map['location'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      maxParticipants: map['max_participants'],
      imageUrl: map['image_url'],
      isActive: map['is_active'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      status: CourseStatus.values[map['status']],
      criteria: map['criteria'] != null ? List<String>.from(map['criteria']) : null
    );
  }


}

enum CourseStatus {
  approved,
  rejected,
  pending,
}

/* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
/* <<<<<<<<<<  5639c35c-820b-4c50-90e8-f43579a86332  >>>>>>>>>>> */
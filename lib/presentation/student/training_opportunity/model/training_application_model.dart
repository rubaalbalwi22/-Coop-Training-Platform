// student/models/training_application_model.dart
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';

enum TrainingApplicationType { train, course }

class TrainingApplication {
    String? id;
    String? studentId;
    String? trainingId;
    String? companyId;
    String? requestMsg;
    String? status; // 'pending', 'accepted', 'rejected'
    String? responseMessage;
    DateTime? appliedAt;
    DateTime? processedAt;
    int? duration;
    DateTime? endDate;
    TrainingApplicationType? type;
    AppUser? student;
    String? title;


  TrainingApplication({
     this.id,
     this.studentId,
     this.trainingId,
    this.companyId,
     this.requestMsg,
     this.status,
     this.responseMessage,
     this.appliedAt,
    this.processedAt,
      this.type,
      this.title,
      this.duration,
      this.endDate,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['studentId'] = studentId;
    data['trainingId'] = trainingId;
    data['companyId'] = companyId;
    data['requestMsg'] = requestMsg;
    data['status'] = status;
    data['responseMessage'] = responseMessage;
    data['appliedAt'] = appliedAt?.toIso8601String();
    if (processedAt != null) {
      data['processedAt'] = processedAt!.toIso8601String();
    }
    data['type'] = type?.name;
    data['title'] = title;
    data['duration'] = duration;
    data['endDate'] = endDate?.toIso8601String();
    return data;
  }

  factory TrainingApplication.fromMap(Map<String, dynamic> map) {
    return TrainingApplication(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      trainingId: map['trainingId'] as String,
      companyId: map['companyId'] as String,
      requestMsg: map['requestMsg'] as String,
      status: map['status'] as String,
      responseMessage: map['responseMessage'] as String?,
      appliedAt: DateTime.parse(map['appliedAt'] as String),
      processedAt: map['processedAt'] != null
          ? DateTime.parse(map['processedAt'] as String)
          : null,
      type: TrainingApplicationType.values
          .firstWhere((t) => t.name == map['type'] as String?),
      title: map['title'] as String?,
      duration: map['duration'] as int?,
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
    );
  }
}
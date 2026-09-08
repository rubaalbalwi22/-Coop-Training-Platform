// student/models/training_report_model.dart
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';
import 'package:train_link/presentation/student/training_opportunity/model/training_application_model.dart';

import '../../training_feedback/model/training_feedback_model.dart';

class TrainingReport {
  String? id;
  String? studentId;
  String? trainingId;
  String? trainingTitle;
  String? filePath;
  String? notes;
  DateTime? submittedAt;
  String? status; // 'pending', 'approved', 'rejected'
  String? feedback;
  TrainingApplicationType? type; // 'دورة' or 'تدريب'
  AppUser? student;
  TrainingApplication? trainingApplication;
  TrainingFeedback? trainingFeedback;

  TrainingReport({
      this.id,
      this.studentId,
      this.trainingTitle,
      this.trainingId,
      this.filePath,
    this.notes,
      this.submittedAt,
      this.status = 'pending',
    this.feedback,
      this.type,
  });

  factory TrainingReport.fromJson(Map<String, dynamic> json) {
    return TrainingReport(
      id: json['id'],
      studentId: json['studentId'],
      trainingId: json['trainingId'],
      trainingTitle: json['trainingTitle'],
      filePath: json['filePath'],
      notes: json['notes'],
      submittedAt: DateTime.parse(json['submittedAt']),
      status: json['status'],
      feedback: json['feedback'],
      type: TrainingApplicationType.values.firstWhere(
        (element) => element.name == json['type'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'trainingId': trainingId,
      'trainingTitle': trainingTitle,
      'filePath': filePath,
      'notes': notes,
      'submittedAt': submittedAt?.toIso8601String(),
      'status': status,
      'feedback': feedback,
      'type': type?.name,
    };
  }
}

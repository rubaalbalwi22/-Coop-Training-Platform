// student/models/training_feedback_model.dart
import '../../../admin/user_management/model/user_model.dart';

class TrainingFeedback {
    String? id;
    String? studentId;
    AppUser? student;
    String trainingId;
    int rating; // من 1 إلى 5
    String comment;
    DateTime submittedAt;
    bool isAnonymous;


  TrainingFeedback({
      this.id,
      this.studentId,
    required this.trainingId,
    required this.rating,
    required this.comment,
    required this.submittedAt,
    this.isAnonymous = false,
  });

  factory TrainingFeedback.fromJson(Map<String, dynamic> json) =>
      TrainingFeedback(
        id: json['id'],
        studentId: json['studentId'],
        trainingId: json['trainingId'],
        rating: json['rating'],
        comment: json['comment'],
        submittedAt: DateTime.parse(json['submittedAt']),
        isAnonymous: json['isAnonymous'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'trainingId': trainingId,
        'rating': rating,
        'comment': comment,
        'submittedAt': submittedAt.toIso8601String(),
        'isAnonymous': isAnonymous,
      };
}
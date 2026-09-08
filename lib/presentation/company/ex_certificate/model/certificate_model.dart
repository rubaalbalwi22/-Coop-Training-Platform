
// models/certificate_model.dart
class Certificate {
  final String id;
  final String companyId;
  final String studentId;
  final String studentName;
  final String trainingId;
  final String trainingTitle;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String certificateNumber;
  final String templateId;
  final String downloadUrl;
  final String status; // issued, revoked
  final String? revocationReason;

  Certificate({
    required this.id,
    required this.companyId,
    required this.studentId,
    required this.studentName,
    required this.trainingId,
    required this.trainingTitle,
    required this.issueDate,
    this.expiryDate,
    required this.certificateNumber,
    required this.templateId,
    required this.downloadUrl,
    this.status = 'issued',
    this.revocationReason,
  });

  String get formattedIssueDate {
    return '${issueDate.day}/${issueDate.month}/${issueDate.year}';
  }

  String? get formattedExpiryDate {
    return expiryDate != null
        ? '${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}'
        : null;
  }
}



// training_model.dart
class Training {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final List<Participant> participants;

  Training({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.participants,
  });
}

// course_model.dart
class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String duration;
  final String endDate;
  final List<Participant> participants;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.duration,
    required this.participants,
    required this.endDate,
  });
}

// participant_model.dart
class Participant {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });
}
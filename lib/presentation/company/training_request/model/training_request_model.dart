// company/models/training_request_model.dart
class TrainingRequest {
  final int id;
  final int studentId;
  final String studentName;
  final String studentEmail;
  final String? studentPhone;
  final String? studentUniversity;
  final String? studentMajor;
  final String? studentCvUrl;
  final int trainingId;
  final String trainingTitle;
  final RequestType requestType;
  final String requestMessage;
  final String status; // pending, approved, rejected
  final String? responseMessage;
  final DateTime appliedAt;
  final DateTime? processedAt;

  TrainingRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    this.studentPhone,
    this.studentUniversity,
    this.studentMajor,
    this.studentCvUrl,
    required this.trainingId,
    required this.trainingTitle,
    required this.requestType,
    required this.requestMessage,
    required this.status,
    this.responseMessage,
    required this.appliedAt,
    this.processedAt,
  });

  // دالة لتحويل الطلب إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'student_email': studentEmail,
      'student_phone': studentPhone,
      'student_university': studentUniversity,
      'student_major': studentMajor,
      'student_cv_url': studentCvUrl,
      'training_id': trainingId,
      'training_title': trainingTitle,
      'request_type': requestType.toString(),
      'request_message': requestMessage,
      'status': status,
      'response_message': responseMessage,
      'applied_at': appliedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }

  // دالة لإنشاء نموذج من خريطة
  factory TrainingRequest.fromMap(Map<String, dynamic> map) {
    return TrainingRequest(
      id: map['id'],
      studentId: map['student_id'],
      studentName: map['student_name'],
      studentEmail: map['student_email'],
      studentPhone: map['student_phone'],
      studentUniversity: map['student_university'],
      studentMajor: map['student_major'],
      studentCvUrl: map['student_cv_url'],
      trainingId: map['training_id'],
      trainingTitle: map['training_title'],
      requestType: RequestType.values.byName(map['request_type']),
      requestMessage: map['request_message'],
      status: map['status'],
      responseMessage: map['response_message'],
      appliedAt: DateTime.parse(map['applied_at']),
      processedAt: map['processed_at'] != null ? DateTime.parse(map['processed_at']) : null,
    );
  }
}

enum RequestType { train, course }
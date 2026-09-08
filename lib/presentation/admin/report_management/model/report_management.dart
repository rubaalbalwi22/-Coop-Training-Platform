class TrainingReport {
  final String id;
  final String studentName;
  final DateTime startDate;
  final DateTime endDate;
  final String pdfUrl; // رابط ملف PDF للتقرير

  TrainingReport({
    required this.id,
    required this.studentName,
    required this.startDate,
    required this.endDate,
    required this.pdfUrl,
  });

  factory TrainingReport.fromMap(Map<String, dynamic> map) {
    return TrainingReport(
      id: map['id'] ?? '',
      studentName: map['studentName'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      pdfUrl: map['pdfUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'pdfUrl': pdfUrl,
    };
  }
}

class Certificate {
  final String id;
  final String certificateNumber;
  final String reportId;
  final String studentId;
  final String trainingId;
  final String fileUrl;
  final DateTime issuedAt;
  final String issuedBy;

  Certificate({
    required this.id,
    required this.certificateNumber,
    required this.reportId,
    required this.studentId,
    required this.trainingId,
    required this.fileUrl,
    required this.issuedAt,
    required this.issuedBy,
  });

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'] ?? '',
      certificateNumber: map['certificateNumber'] ?? '',
      reportId: map['reportId'] ?? '',
      studentId: map['studentId'] ?? '',
      trainingId: map['trainingId'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      issuedAt: DateTime.parse(map['issuedAt']),
      issuedBy: map['issuedBy'] ?? '',
    );
  }


}
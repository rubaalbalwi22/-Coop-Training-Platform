enum CourseStatus { pending, approved, rejected }

class Course {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final String category;
  final int duration; // بالمدة بالساعات
  final DateTime startDate;
  final DateTime endDate;
  final int maxStudents;
  final CourseStatus status;
  final DateTime createdAt;
  final String? rejectionReason;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.category,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.maxStudents,
    this.status = CourseStatus.pending,
    required this.createdAt,
    this.rejectionReason,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      instructorId: map['instructorId'] ?? '',
      instructorName: map['instructorName'] ?? '',
      category: map['category'] ?? '',
      duration: map['duration'] ?? 0,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      maxStudents: map['maxStudents'] ?? 0,
      status: CourseStatus.values[map['status'] ?? 0],
      createdAt: DateTime.parse(map['createdAt']),
      rejectionReason: map['rejectionReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'category': category,
      'duration': duration,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxStudents': maxStudents,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }
}
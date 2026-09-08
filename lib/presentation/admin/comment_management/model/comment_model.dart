class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userType; // 'student' أو 'company'
  final String content;
  final String trainingId;
  final String? replyTo; // ID للتعليق الأصلي في حالة الرد
  final DateTime createdAt;
  final double rating;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.content,
    required this.trainingId,
    this.replyTo,
    required this.createdAt,
    required this.rating,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userType: map['userType'] ?? 'student',
      content: map['content'] ?? '',
      trainingId: map['trainingId'] ?? '',
      replyTo: map['replyTo'],
      createdAt: DateTime.parse(map['createdAt']),
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userType': userType,
      'content': content,
      'trainingId': trainingId,
      'replyTo': replyTo,
      'createdAt': createdAt.toIso8601String(),
      'rating': rating,
    };
  }
}
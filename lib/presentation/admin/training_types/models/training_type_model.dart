class TrainingType {
   String id;
  final String name;
   final DateTime createdAt;

  TrainingType({
    required this.id,
    required this.name,
      required this.createdAt,
   });

  factory TrainingType.fromMap(Map<String, dynamic> map) {
    return TrainingType(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
       createdAt: DateTime.parse(map['createdAt']),
     );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
       'createdAt': createdAt.toIso8601String(),
     };
  }
}
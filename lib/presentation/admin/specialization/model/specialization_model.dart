class Specialization {
    String id;
  final String name;
   final DateTime createdAt;

  Specialization({
    required this.id,
    required this.name,
     required this.createdAt,
   });

  factory Specialization.fromMap(Map<String, dynamic> map) {
    return Specialization(
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
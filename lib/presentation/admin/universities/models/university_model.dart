class University {
    String id;
  final String name;
  final String location;
  final String contactEmail;
  final DateTime createdAt;

  University({
    required this.id,
    required this.name,
    required this.location,
    required this.contactEmail,
    required this.createdAt,
  });

  factory University.fromMap(Map<String, dynamic> map) {
    return University(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contactEmail': contactEmail,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
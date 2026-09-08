class CompanyProfile {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final String? website;
  final String? phone;
  final String? email;
  final List<CompanyRating> ratings;
  late final double averageRating;
  final int opportunitiesCount;
  final int trainingsCount;

  CompanyProfile({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    this.website,
    this.phone,
    this.email,
    required this.ratings,
    required this.averageRating,
    required this.opportunitiesCount,
    required this.trainingsCount,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      website: json['website'],
      phone: json['phone'],
      email: json['email'],
      ratings: (json['ratings'] as List)
          .map((rating) => CompanyRating.fromJson(rating))
          .toList(),
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      opportunitiesCount: json['opportunitiesCount'] ?? 0,
      trainingsCount: json['trainingsCount'] ?? 0,
    );
  }
}

class CompanyRating {
  final String id;
  final String studentName;
  final String studentId;
  final String? studentImage;
  final double rating;
  final String comment;
  final DateTime date;

  CompanyRating({
    required this.id,
    required this.studentName,
    required this.studentId,
    this.studentImage,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory CompanyRating.fromJson(Map<String, dynamic> json) {
    return CompanyRating(
      id: json['id'],
      studentName: json['studentName'],
      studentId: json['studentId'],
      studentImage: json['studentImage'],
      rating: json['rating']?.toDouble() ?? 0.0,
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }
}
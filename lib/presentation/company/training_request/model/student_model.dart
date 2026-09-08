class StudentModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;
  final String universityId;
  final String universityName;
  final String specializationId;
  final String specializationName;
  final String? cvUrl;
  final String? cvFileName;
  final DateTime? cvUploadDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.universityId,
    required this.universityName,
    required this.specializationId,
    required this.specializationName,
    this.cvUrl,
    this.cvFileName,
    this.cvUploadDate,
    required this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
      universityId: json['universityId'] ?? '',
      universityName: json['universityName'] ?? '',
      specializationId: json['specializationId'] ?? '',
      specializationName: json['specializationName'] ?? '',
      cvUrl: json['cvUrl'],
      cvFileName: json['cvFileName'],
      cvUploadDate: json['cvUploadDate'] != null
          ? DateTime.parse(json['cvUploadDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'universityId': universityId,
      'universityName': universityName,
      'specializationId': specializationId,
      'specializationName': specializationName,
      'cvUrl': cvUrl,
      'cvFileName': cvFileName,
      'cvUploadDate': cvUploadDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  StudentModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? profileImage,
    String? universityId,
    String? universityName,
    String? specializationId,
    String? specializationName,
    String? cvUrl,
    String? cvFileName,
    DateTime? cvUploadDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      universityId: universityId ?? this.universityId,
      universityName: universityName ?? this.universityName,
      specializationId: specializationId ?? this.specializationId,
      specializationName: specializationName ?? this.specializationName,
      cvUrl: cvUrl ?? this.cvUrl,
      cvFileName: cvFileName ?? this.cvFileName,
      cvUploadDate: cvUploadDate ?? this.cvUploadDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
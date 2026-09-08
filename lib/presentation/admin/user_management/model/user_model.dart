enum UserType { student, company, admin }
enum UserStatus { pending, approved, rejected }
extension UserTypeExtension on String {
   UserType toUserType() => this == 'student'
      ? UserType.student
      : this == 'company'
          ? UserType.company
          : UserType.admin;
}

extension UserTypeExtension2 on UserType {
  String toShortString() => this == UserType.student
      ? 'student'
      : this == UserType.company
          ? 'company'
          : 'admin';
}
class AppUser {
  String? id;
  UserType type;
  String name;
  String email;
  String? phone;
  String? universityId;
  String? university;
  String? specializationId;
  String? specialization;
  String? companyName;
  String? companyAddress;
  String? companyDescription;
  String? companyWebsite;
  String? companyRegisterNumber;
  String? cvUrl;
  String? companyLogo;
  String? password;
  UserStatus status;
  DateTime createdAt;
  bool isActive;

  AppUser({
      this.id,
    required this.type,
    required this.name,
    required this.email,
      this.password,
    this.phone,
    this.universityId,
    this.university,
    this.specializationId,
    this.specialization,
    this.companyName,
    this.companyAddress,
    this.companyDescription,
    this.companyWebsite,
    this.companyRegisterNumber,
    this.cvUrl,
    this.companyLogo,
    this.status = UserStatus.pending,
    required this.createdAt,
    this.isActive = true,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['uid'] ?? '',
      type: UserType.values[map['type'] ?? 0],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'],
      universityId: map['universityId'],
      university: map['universityName'],
      specializationId: map['specializationId'],
      specialization: map['specializationName'],
      companyName: map['companyName'],
      companyAddress: map['companyAddress'],
      companyDescription: map['companyDescription'],
      companyWebsite: map['companyWebsite'],
      companyRegisterNumber: map['companyRegisterNumber'],
      cvUrl: map['cvUrl'],
      companyLogo: map['companyLogo'],
      status: UserStatus.values[map['status'] ?? 0],
      createdAt: map['createdAt'] == null ? DateTime.now() : DateTime.parse(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'type': type.index,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'universityId': universityId,
      'universityName': university,
      'specializationId': specializationId,
      'specializationName': specialization,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyDescription': companyDescription,
      'companyWebsite': companyWebsite,
      'companyRegisterNumber': companyRegisterNumber,
      'cvUrl': cvUrl,
      'companyLogo': companyLogo,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }


  AppUser copyWith({
    String? id,
    UserType? type,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? universityId,
    String? university,
    String? specializationId,
    String? specialization,
    String? companyName,
    String? companyAddress,
    String? companyDescription,
    String? companyWebsite,
    String? companyRegisterNumber,
    String? cvUrl,
    String? companyLogo,
    UserStatus? status,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return AppUser(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      universityId: universityId ?? this.universityId,
      university: university ?? this.university,
      specializationId: specializationId ?? this.specializationId,
      specialization: specialization ?? this.specialization,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyDescription: companyDescription ?? this.companyDescription,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyRegisterNumber: companyRegisterNumber ?? this.companyRegisterNumber,
      cvUrl: cvUrl ?? this.cvUrl,
      companyLogo: companyLogo ?? this.companyLogo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
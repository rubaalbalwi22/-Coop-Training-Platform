class Company {
  final int id;
  final String name;
  final String description;
  final String location;
  final String email;
  final String phone;
  final String? website;
  final String registerNumber;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.email,
    required this.phone,
    this.website,
    required this.registerNumber,
  });
}
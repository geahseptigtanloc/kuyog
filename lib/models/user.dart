class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String role; // tourist, guide, merchant, admin, superAdmin
  final bool isVerified;
  final String location;
  final DateTime joinedDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    required this.avatarUrl,
    required this.role,
    this.isVerified = false,
    this.location = 'Davao City',
    required this.joinedDate,
  });
}

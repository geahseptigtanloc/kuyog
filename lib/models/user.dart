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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      role: json['role'] ?? 'tourist',
      isVerified: json['isVerified'] ?? false,
      location: json['location'] ?? 'Davao City',
      joinedDate: json['joinedDate'] != null 
          ? DateTime.parse(json['joinedDate']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'role': role,
      'isVerified': isVerified,
      'location': location,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}

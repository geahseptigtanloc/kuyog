class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String role; // tourist, guide, merchant, admin, superAdmin
  final bool isVerified;
  final String verificationStatus; // pending, submitted, under_review, approved, rejected
  final String location;
  final DateTime joinedDate;
  final String bio;
  final bool isOnboarded;
  final List<String> languages;
  final List<String> interests;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    required this.avatarUrl,
    required this.role,
    this.isVerified = false,
    this.verificationStatus = 'pending',
    this.location = 'Davao City',
    required this.joinedDate,
    this.bio = '',
    this.isOnboarded = false,
    this.languages = const [],
    this.interests = const [],
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
      verificationStatus: json['verificationStatus'] ?? 'pending',
      location: json['location'] ?? 'Davao City',
      joinedDate: json['joinedDate'] != null 
          ? DateTime.parse(json['joinedDate']) 
          : DateTime.now(),
      bio: json['bio'] ?? '',
      isOnboarded: json['is_onboarded'] ?? false,
      languages: json['languages'] != null ? List<String>.from(json['languages']) : [],
      interests: json['tourist_preferences'] != null && json['tourist_preferences'] is Map 
          ? List<String>.from(json['tourist_preferences']['interests'] ?? []) 
          : (json['tourist_preferences'] != null && json['tourist_preferences'] is List && (json['tourist_preferences'] as List).isNotEmpty
              ? List<String>.from(json['tourist_preferences'][0]['interests'] ?? [])
              : []),
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
      'verificationStatus': verificationStatus,
      'location': location,
      'joinedDate': joinedDate.toIso8601String(),
      'bio': bio,
      'is_onboarded': isOnboarded,
      'languages': languages,
      'interests': interests,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? role,
    bool? isVerified,
    String? verificationStatus,
    String? location,
    DateTime? joinedDate,
    String? bio,
    bool? isOnboarded,
    List<String>? languages,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      location: location ?? this.location,
      joinedDate: joinedDate ?? this.joinedDate,
      bio: bio ?? this.bio,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      languages: languages ?? this.languages,
      interests: interests ?? this.interests,
    );
  }
}

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
  // V4 — Full spec fields
  final String travelerType; // solo, group
  final String visitorType; // local, international
  final String budgetRange; // economy, standard, premium
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final int groupSize;
  final int madayawPoints;
  final String emergencyContact;
  final String emergencyPhone;
  final String preferredLanguage;
  final String country;

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
    this.travelerType = 'solo',
    this.visitorType = 'international',
    this.budgetRange = 'standard',
    this.arrivalDate,
    this.departureDate,
    this.groupSize = 1,
    this.madayawPoints = 0,
    this.emergencyContact = '',
    this.emergencyPhone = '',
    this.preferredLanguage = 'English',
    this.country = '',
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
              : (json['interests'] != null ? List<String>.from(json['interests']) : [])),
      travelerType: json['travelerType'] ?? 'solo',
      visitorType: json['visitorType'] ?? 'international',
      budgetRange: json['budgetRange'] ?? 'standard',
      arrivalDate: json['arrivalDate'] != null ? DateTime.parse(json['arrivalDate']) : null,
      departureDate: json['departureDate'] != null ? DateTime.parse(json['departureDate']) : null,
      groupSize: json['groupSize'] ?? 1,
      madayawPoints: json['madayawPoints'] ?? 0,
      emergencyContact: json['emergencyContact'] ?? '',
      emergencyPhone: json['emergencyPhone'] ?? '',
      preferredLanguage: json['preferredLanguage'] ?? 'English',
      country: json['country'] ?? '',
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
      'travelerType': travelerType,
      'visitorType': visitorType,
      'budgetRange': budgetRange,
      'arrivalDate': arrivalDate?.toIso8601String(),
      'departureDate': departureDate?.toIso8601String(),
      'groupSize': groupSize,
      'madayawPoints': madayawPoints,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'preferredLanguage': preferredLanguage,
      'country': country,
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
    List<String>? interests,
    String? travelerType,
    String? visitorType,
    String? budgetRange,
    DateTime? arrivalDate,
    DateTime? departureDate,
    int? groupSize,
    int? madayawPoints,
    String? emergencyContact,
    String? emergencyPhone,
    String? preferredLanguage,
    String? country,
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
      travelerType: travelerType ?? this.travelerType,
      visitorType: visitorType ?? this.visitorType,
      budgetRange: budgetRange ?? this.budgetRange,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      departureDate: departureDate ?? this.departureDate,
      groupSize: groupSize ?? this.groupSize,
      madayawPoints: madayawPoints ?? this.madayawPoints,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      country: country ?? this.country,
    );
  }
}

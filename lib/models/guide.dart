class Guide {
  final String id;
  final String name;
  final String city;
  final List<String> specialties;
  final double rating;
  final int tripCount;
  final int reviewCount;
  final String bio;
  final List<String> certifications;
  final String photoUrl;
  final String bannerUrl;
  final bool isVerified;
  final List<String> itineraryPhotos;
  final int yearsExperience;
  final List<String> languages;
  final String priceRange;
  final String specialty;

  const Guide({
    required this.id,
    required this.name,
    required this.city,
    required this.specialties,
    required this.rating,
    required this.tripCount,
    this.reviewCount = 0,
    required this.bio,
    required this.certifications,
    required this.photoUrl,
    required this.bannerUrl,
    this.isVerified = true,
    this.itineraryPhotos = const [],
    this.yearsExperience = 3,
    this.languages = const ['Filipino', 'English'],
    this.priceRange = '₱₱',
    this.specialty = 'Cultural Immersion',
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      tripCount: json['tripCount'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      bio: json['bio'] ?? '',
      certifications: List<String>.from(json['certifications'] ?? []),
      photoUrl: json['photoUrl'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      isVerified: json['isVerified'] ?? true,
      itineraryPhotos: List<String>.from(json['itineraryPhotos'] ?? []),
      yearsExperience: json['yearsExperience'] ?? 3,
      languages: List<String>.from(json['languages'] ?? ['Filipino', 'English']),
      priceRange: json['priceRange'] ?? '₱₱',
      specialty: json['specialty'] ?? 'Cultural Immersion',
    );
  }
}

class TourOperator {
  final String id;
  final String companyName;
  final String logoUrl;
  final String location;
  final bool dotAccredited;
  final bool businessPermitVerified;
  final List<String> specialties;
  final int guideCount;
  final double rating;
  final int reviewCount;
  final List<TourPackage> packages;

  const TourOperator({
    required this.id,
    required this.companyName,
    required this.logoUrl,
    this.location = '',
    this.dotAccredited = true,
    this.businessPermitVerified = true,
    this.specialties = const [],
    this.guideCount = 0,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.packages = const [],
  });

  factory TourOperator.fromJson(Map<String, dynamic> json) {
    return TourOperator(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      location: json['location'] ?? '',
      dotAccredited: json['dotAccredited'] ?? true,
      businessPermitVerified: json['businessPermitVerified'] ?? true,
      specialties: List<String>.from(json['specialties'] ?? []),
      guideCount: json['guideCount'] ?? 0,
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      packages: (json['packages'] as List<dynamic>?)
              ?.map((p) => TourPackage.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class TourPackage {
  final String id;
  final String name;
  final String photoUrl;
  final int durationDays;
  final double price;
  final List<String> inclusions;
  final String description;

  const TourPackage({
    required this.id,
    required this.name,
    this.photoUrl = '',
    this.durationDays = 1,
    this.price = 0,
    this.inclusions = const [],
    this.description = '',
  });

  factory TourPackage.fromJson(Map<String, dynamic> json) {
    return TourPackage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      durationDays: json['durationDays'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      inclusions: List<String>.from(json['inclusions'] ?? []),
      description: json['description'] ?? '',
    );
  }
}

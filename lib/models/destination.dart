class Destination {
  final String id;
  final String name;
  final String province;
  final String description;
  final String imageUrl;
  final double rating;
  final String category;
  final double pricePerDay;
  final List<String> tags;
  final double distanceKm;
  final List<String> photos;
  // V3 additions
  final bool lguEndorsed;
  final String region;
  final String dataSource;
  // V4 — Full spec fields
  final String operatingHours;
  final String entranceFee;
  final String entranceFeeNotes;
  final bool isFreeEntry;
  final String contact;
  final String address;
  final String whyVisit;
  final List<String> highlights;
  final List<String> whatToBring;
  final List<Map<String, String>> faqs;
  final double latitude;
  final double longitude;
  final int estimatedVisitMinutes;
  final String contactPhone;
  final String contactEmail;

  const Destination({
    required this.id,
    required this.name,
    required this.province,
    required this.description,
    required this.imageUrl,
    required this.rating,
    this.category = 'Nature',
    this.pricePerDay = 1500,
    this.tags = const [],
    this.distanceKm = 0,
    this.photos = const [],
    this.lguEndorsed = true,
    this.region = 'Davao Region',
    this.dataSource = 'DOT-XI',
    this.operatingHours = '',
    this.entranceFee = '',
    this.entranceFeeNotes = '',
    this.isFreeEntry = false,
    this.contact = '',
    this.address = '',
    this.whyVisit = '',
    this.highlights = const [],
    this.whatToBring = const [],
    this.faqs = const [],
    this.latitude = 7.0707,
    this.longitude = 125.6087,
    this.estimatedVisitMinutes = 120,
    this.contactPhone = '',
    this.contactEmail = '',
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      province: json['province'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      category: json['category'] ?? 'Nature',
      pricePerDay: (json['pricePerDay'] ?? 1500).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      photos: List<String>.from(json['photos'] ?? []),
      lguEndorsed: json['lguEndorsed'] ?? true,
      region: json['region'] ?? 'Davao Region',
      dataSource: json['dataSource'] ?? 'DOT-XI',
      operatingHours: json['operatingHours'] ?? '',
      entranceFee: json['entranceFee'] ?? '',
      entranceFeeNotes: json['entranceFeeNotes'] ?? '',
      isFreeEntry: json['isFreeEntry'] ?? false,
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      whyVisit: json['whyVisit'] ?? '',
      highlights: List<String>.from(json['highlights'] ?? []),
      whatToBring: List<String>.from(json['whatToBring'] ?? []),
      faqs: (json['faqs'] as List<dynamic>?)
              ?.map((f) => Map<String, String>.from(f))
              .toList() ??
          [],
      latitude: (json['latitude'] ?? 7.0707).toDouble(),
      longitude: (json['longitude'] ?? 125.6087).toDouble(),
      estimatedVisitMinutes: json['estimatedVisitMinutes'] ?? 120,
      contactPhone: json['contactPhone'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
    );
  }
}

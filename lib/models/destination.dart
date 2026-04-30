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
  final String region; // 'Davao Region', 'SOCCSKSARGEN', 'Caraga', 'Northern Mindanao', 'BARMM'
  final String dataSource;

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
    );
  }
}

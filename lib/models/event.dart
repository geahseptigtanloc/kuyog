class CrawlEvent {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String dateRange;
  final int totalSpots;
  final int slotsRemaining;
  final List<CrawlSpot> spots;
  final bool isActive;
  final String category;

  const CrawlEvent({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
    this.location = '',
    this.dateRange = '',
    this.totalSpots = 30,
    this.slotsRemaining = 12,
    this.spots = const [],
    this.isActive = true,
    this.category = 'Festival',
  });

  factory CrawlEvent.fromJson(Map<String, dynamic> json) {
    return CrawlEvent(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      dateRange: json['dateRange'] ?? '',
      totalSpots: json['totalSpots'] ?? 30,
      slotsRemaining: json['slotsRemaining'] ?? 12,
      spots: (json['spots'] as List<dynamic>?)
              ?.map((s) => CrawlSpot.fromJson(s))
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      category: json['category'] ?? 'Festival',
    );
  }
}

class CrawlSpot {
  final String id;
  final String name;
  final String category;
  final String address;
  final String description;
  final String imageUrl;
  final bool isCollected;

  const CrawlSpot({
    required this.id,
    required this.name,
    this.category = 'Restaurant',
    this.address = '',
    this.description = '',
    this.imageUrl = '',
    this.isCollected = false,
  });

  factory CrawlSpot.fromJson(Map<String, dynamic> json) {
    return CrawlSpot(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Restaurant',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isCollected: json['isCollected'] ?? false,
    );
  }
}

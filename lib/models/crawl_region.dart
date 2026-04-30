class CrawlRegion {
  final String id;
  final String name;
  final String emoji;
  final String photoUrl;
  final int spotCount;
  final bool isActive;
  final List<CrawlStamp> stamps;

  const CrawlRegion({
    required this.id,
    required this.name,
    this.emoji = '',
    this.photoUrl = '',
    this.spotCount = 0,
    this.isActive = true,
    this.stamps = const [],
  });

  factory CrawlRegion.fromJson(Map<String, dynamic> json) {
    return CrawlRegion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      spotCount: json['spotCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      stamps: (json['stamps'] as List<dynamic>?)
              ?.map((s) => CrawlStamp.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class CrawlStamp {
  final String id;
  final String spotName;
  final String spotAddress;
  final bool isCollected;

  const CrawlStamp({
    required this.id,
    required this.spotName,
    this.spotAddress = '',
    this.isCollected = false,
  });

  factory CrawlStamp.fromJson(Map<String, dynamic> json) {
    return CrawlStamp(
      id: json['id'] ?? '',
      spotName: json['spotName'] ?? '',
      spotAddress: json['spotAddress'] ?? '',
      isCollected: json['isCollected'] ?? false,
    );
  }
}

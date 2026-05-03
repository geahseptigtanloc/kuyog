class CrawlRoute {
  final String id;
  final String name;
  final String region;
  final String guideId;
  final int durationHours;
  final int maxPax;
  final int stopsCount;
  final int milesEarned;
  final double pricePerPerson;
  final String type;
  final List<String> inclusions;
  final String photoUrl;
  final List<String> stops;

  const CrawlRoute({
    required this.id,
    required this.name,
    required this.region,
    required this.guideId,
    required this.durationHours,
    required this.maxPax,
    required this.stopsCount,
    required this.milesEarned,
    required this.pricePerPerson,
    required this.type,
    required this.inclusions,
    required this.photoUrl,
    required this.stops,
  });

  factory CrawlRoute.fromJson(Map<String, dynamic> json) {
    return CrawlRoute(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      guideId: json['guide_id'] ?? '',
      durationHours: json['duration_hours'] ?? 0,
      maxPax: json['max_pax'] ?? 0,
      stopsCount: json['stops_count'] ?? 0,
      milesEarned: json['miles_earned'] ?? 0,
      pricePerPerson: (json['price_per_person'] ?? 0).toDouble(),
      type: json['type'] ?? 'guide_led',
      inclusions: List<String>.from(json['inclusions'] ?? []),
      photoUrl: json['photo_url'] ?? '',
      stops: List<String>.from(json['stops'] ?? []),
    );
  }
}

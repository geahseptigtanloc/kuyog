class Itinerary {
  final String id;
  final String title;
  final String destination;
  final String imageUrl;
  final int stopsCount;
  final int daysRemaining;
  final String status; // Active, Upcoming, Completed, Draft
  final List<ItineraryDay> days;
  final double totalCost;
  final String guideId;

  const Itinerary({
    required this.id,
    required this.title,
    required this.destination,
    required this.imageUrl,
    this.stopsCount = 0,
    this.daysRemaining = 0,
    this.status = 'Upcoming',
    this.days = const [],
    this.totalCost = 0,
    this.guideId = '',
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      destination: json['destination'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      stopsCount: json['stopsCount'] ?? 0,
      daysRemaining: json['daysRemaining'] ?? 0,
      status: json['status'] ?? 'Upcoming',
      days: (json['days'] as List<dynamic>?)
              ?.map((d) => ItineraryDay.fromJson(d))
              .toList() ??
          [],
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      guideId: json['guideId'] ?? '',
    );
  }
}

class ItineraryDay {
  final int day;
  final List<ItineraryActivity> activities;

  const ItineraryDay({required this.day, this.activities = const []});

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      day: json['day'] ?? 1,
      activities: (json['activities'] as List<dynamic>?)
              ?.map((a) => ItineraryActivity.fromJson(a))
              .toList() ??
          [],
    );
  }
}

class ItineraryActivity {
  final String name;
  final String location;
  final String category;
  final double rating;
  final String timeEstimate;
  final String distance;
  final IconCategory iconCategory;

  const ItineraryActivity({
    required this.name,
    required this.location,
    this.category = 'Sightseeing',
    this.rating = 4.5,
    this.timeEstimate = '1-2 hrs',
    this.distance = '2.5 km',
    this.iconCategory = IconCategory.sightseeing,
  });

  factory ItineraryActivity.fromJson(Map<String, dynamic> json) {
    return ItineraryActivity(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? 'Sightseeing',
      rating: (json['rating'] ?? 4.5).toDouble(),
      timeEstimate: json['timeEstimate'] ?? '1-2 hrs',
      distance: json['distance'] ?? '2.5 km',
      iconCategory: IconCategory.values.firstWhere(
        (e) => e.name == (json['iconCategory'] ?? 'sightseeing'),
        orElse: () => IconCategory.sightseeing,
      ),
    );
  }
}

enum IconCategory { sightseeing, food, adventure, culture, nature, shopping, transport }

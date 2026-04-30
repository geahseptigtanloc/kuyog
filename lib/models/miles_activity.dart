class MilesActivity {
  final String id;
  final String description;
  final int miles;
  final String date;
  final String type; // 'earned' or 'redeemed'
  final String category; // 'booking', 'review', 'post', 'crawl', 'quiz', 'referral', 'challenge', 'redeem'

  const MilesActivity({
    required this.id,
    required this.description,
    required this.miles,
    this.date = '',
    this.type = 'earned',
    this.category = 'booking',
  });

  factory MilesActivity.fromJson(Map<String, dynamic> json) {
    return MilesActivity(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      miles: json['miles'] ?? 0,
      date: json['date'] ?? '',
      type: json['type'] ?? 'earned',
      category: json['category'] ?? 'booking',
    );
  }
}

class MilesReward {
  final String id;
  final String name;
  final String photoUrl;
  final int milesCost;
  final bool isAvailable;

  const MilesReward({
    required this.id,
    required this.name,
    this.photoUrl = '',
    required this.milesCost,
    this.isAvailable = true,
  });
}

class MilesTier {
  final String name;
  final String icon;
  final int minMiles;
  final int maxMiles;
  final List<String> perks;

  const MilesTier({
    required this.name,
    required this.icon,
    required this.minMiles,
    required this.maxMiles,
    this.perks = const [],
  });
}

class Tourist {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String location;
  final int tripsCount;
  final int reviewsCount;
  final int milesBalance;
  final int stampsCollected;
  final List<String> preferences;
  final List<String> savedGuideIds;
  final List<String> wishlistProductIds;

  const Tourist({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.location = 'Davao City',
    this.tripsCount = 3,
    this.reviewsCount = 5,
    this.milesBalance = 1240,
    this.stampsCollected = 6,
    this.preferences = const [],
    this.savedGuideIds = const [],
    this.wishlistProductIds = const [],
  });
}

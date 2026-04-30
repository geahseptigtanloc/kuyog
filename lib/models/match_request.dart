class MatchRequest {
  final String id;
  final String touristName;
  final String touristAvatar;
  final String touristLocation;
  final List<String> travelPreferences;
  final List<String> destinationsOfInterest;
  final String travelDates;
  final int matchScore;
  final String status; // 'pending', 'accepted', 'declined'
  final String? declineReason;
  final String timeAgo;

  const MatchRequest({
    required this.id,
    required this.touristName,
    required this.touristAvatar,
    this.touristLocation = 'Davao City',
    this.travelPreferences = const [],
    this.destinationsOfInterest = const [],
    this.travelDates = '',
    this.matchScore = 0,
    this.status = 'pending',
    this.declineReason,
    this.timeAgo = '1h ago',
  });

  factory MatchRequest.fromJson(Map<String, dynamic> json) {
    return MatchRequest(
      id: json['id'] ?? '',
      touristName: json['touristName'] ?? '',
      touristAvatar: json['touristAvatar'] ?? '',
      touristLocation: json['touristLocation'] ?? 'Davao City',
      travelPreferences: List<String>.from(json['travelPreferences'] ?? []),
      destinationsOfInterest: List<String>.from(json['destinationsOfInterest'] ?? []),
      travelDates: json['travelDates'] ?? '',
      matchScore: json['matchScore'] ?? 0,
      status: json['status'] ?? 'pending',
      declineReason: json['declineReason'],
      timeAgo: json['timeAgo'] ?? '1h ago',
    );
  }
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String timeAgo;
  final String targetId;
  final String targetType; // guide, product, destination

  const Review({
    required this.id,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.comment,
    this.timeAgo = '1 week ago',
    this.targetId = '',
    this.targetType = 'guide',
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      comment: json['comment'] ?? '',
      timeAgo: json['timeAgo'] ?? '1 week ago',
      targetId: json['targetId'] ?? '',
      targetType: json['targetType'] ?? 'guide',
    );
  }
}

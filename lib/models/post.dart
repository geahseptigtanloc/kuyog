class Post {
  final String id;
  final String userName;
  final String userAvatar;
  final String userRole; // Tourist, Guide, Merchant
  final String location;
  final String content;
  final List<String> images;
  final List<String> hashtags;
  final int upvotes;
  final int comments;
  final String timeAgo;
  final bool isBookmarked;

  const Post({
    required this.id,
    required this.userName,
    required this.userAvatar,
    this.userRole = 'Tourist',
    required this.location,
    required this.content,
    this.images = const [],
    this.hashtags = const [],
    this.upvotes = 0,
    this.comments = 0,
    this.timeAgo = '2h ago',
    this.isBookmarked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      userRole: json['userRole'] ?? 'Tourist',
      location: json['location'] ?? '',
      content: json['content'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      hashtags: List<String>.from(json['hashtags'] ?? []),
      upvotes: json['upvotes'] ?? 0,
      comments: json['comments'] ?? 0,
      timeAgo: json['timeAgo'] ?? '2h ago',
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}

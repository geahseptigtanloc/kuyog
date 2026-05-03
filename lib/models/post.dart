class Post {
  final String id;
  final String authorId;
  final String userName;
  final String userAvatar;
  final String userRole; // Tourist, Guide, Merchant
  final String location;
  final String content;
  final List<String> images;
  final List<String> hashtags;
  final int upvotes;
  final int comments;
  final DateTime createdAt;
  final bool isBookmarked;
  final bool isUpvoted; // Added to track if current user upvoted

  const Post({
    required this.id,
    required this.authorId,
    required this.userName,
    required this.userAvatar,
    this.userRole = 'Tourist',
    required this.location,
    required this.content,
    this.images = const [],
    this.hashtags = const [],
    this.upvotes = 0,
    this.comments = 0,
    required this.createdAt,
    this.isBookmarked = false,
    this.isUpvoted = false,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    // Handle Supabase join result where profile info is nested
    final profile = json['profiles'] as Map<String, dynamic>?;
    
    return Post(
      id: json['id']?.toString() ?? '',
      authorId: json['author_id']?.toString() ?? '',
      userName: profile?['name'] ?? json['userName'] ?? 'Unknown User',
      userAvatar: profile?['avatarUrl'] ?? json['userAvatar'] ?? 'https://picsum.photos/seed/user/100/100',
      userRole: profile?['role'] ?? json['userRole'] ?? 'Tourist',
      location: json['location_label'] ?? json['location'] ?? 'Unknown Location',
      content: json['content'] ?? '',
      images: List<String>.from(json['photos'] ?? json['images'] ?? []),
      hashtags: List<String>.from(json['hashtags'] ?? []),
      upvotes: json['upvotes'] ?? 0,
      comments: json['comments_count'] ?? json['comments'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isBookmarked: json['isBookmarked'] ?? false,
      isUpvoted: json['isUpvoted'] ?? false,
    );
  }

  Post copyWith({
    int? upvotes,
    int? comments,
    bool? isBookmarked,
    bool? isUpvoted,
  }) {
    return Post(
      id: id,
      authorId: authorId,
      userName: userName,
      userAvatar: userAvatar,
      userRole: userRole,
      location: location,
      content: content,
      images: images,
      hashtags: hashtags,
      upvotes: upvotes ?? this.upvotes,
      comments: comments ?? this.comments,
      createdAt: createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isUpvoted: isUpvoted ?? this.isUpvoted,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // booking, promo, system
  final String timeAgo;
  final bool isRead;
  final String iconType; // booking, promo, system, crawl, miles

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'system',
    this.timeAgo = '1h ago',
    this.isRead = false,
    this.iconType = 'system',
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      timeAgo: json['timeAgo'] ?? '1h ago',
      isRead: json['isRead'] ?? false,
      iconType: json['iconType'] ?? 'system',
    );
  }
}

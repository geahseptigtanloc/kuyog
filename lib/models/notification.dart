class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String type; // 'booking', 'message', 'system', 'promotion'
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.type = 'system',
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['isRead'] ?? false,
    );
  }
}

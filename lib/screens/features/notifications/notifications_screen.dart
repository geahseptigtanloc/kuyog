import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final notifs = await MockData.getNotifications();
    if (mounted) setState(() { _notifications = notifs; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Notifications', style: AppTheme.headline(size: 20)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Mark all read', style: AppTheme.label(size: 13, color: AppColors.primary)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textLight.withAlpha(128)),
                      const SizedBox(height: 16),
                      Text('No new notifications', style: AppTheme.headline(size: 18)),
                      const SizedBox(height: 8),
                      Text('You are all caught up!', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final n = _notifications[index];
                    return _notificationTile(n);
                  },
                ),
    );
  }

  Widget _notificationTile(NotificationItem n) {
    IconData icon;
    Color color;

    switch (n.type) {
      case 'booking':
        icon = Icons.event_available;
        color = AppColors.primary;
        break;
      case 'message':
        icon = Icons.chat_bubble;
        color = AppColors.touristBlue;
        break;
      case 'system':
        icon = Icons.info;
        color = AppColors.textSecondary;
        break;
      case 'promotion':
        icon = Icons.local_offer;
        color = AppColors.merchantAmber;
        break;
      default:
        icon = Icons.notifications;
        color = AppColors.primaryDark;
    }

    return Container(
      color: n.isRead ? Colors.transparent : AppColors.primary.withAlpha(13),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withAlpha(26), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(n.title, style: AppTheme.label(size: 14))),
                    Text(n.timeAgo, style: AppTheme.body(size: 11, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(n.message, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (!n.isRead) ...[
            const SizedBox(width: 16),
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          ],
        ],
      ),
    );
  }
}


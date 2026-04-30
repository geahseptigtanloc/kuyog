import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';

class NotificationsListScreen extends StatelessWidget {
  const NotificationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('Notifications', style: AppTheme.headline(size: 20)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text('Mark all read', style: AppTheme.label(size: 13, color: AppColors.primary)),
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _dateHeader('Today'),
                _notificationTile(Icons.check_circle, 'Booking Confirmed', 'Your booking with Guide Rico M. is confirmed for tomorrow.', '2h ago', true),
                _notificationTile(Icons.shopping_bag, 'Order Shipped', 'Your T\'nalak Woven Bag is on the way.', '4h ago', true),
                const SizedBox(height: 16),
                _dateHeader('Yesterday'),
                _notificationTile(Icons.chat_bubble, 'New Message', 'Amina L. sent you a message about the Mt. Apo hike.', '1d ago', false),
                _notificationTile(Icons.local_activity, 'Stamp Earned!', 'You earned a stamp for visiting People\'s Park.', '1d ago', false),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _dateHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title, style: AppTheme.headline(size: 14)),
    );
  }

  Widget _notificationTile(IconData icon, String title, String body, String time, bool isUnread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isUnread ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
        boxShadow: isUnread ? null : AppShadows.card,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(title, style: AppTheme.label(size: 14))),
              Text(time, style: AppTheme.body(size: 11, color: AppColors.textLight)),
            ]),
            const SizedBox(height: 4),
            Text(body, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
          ]),
        ),
      ]),
    );
  }
}

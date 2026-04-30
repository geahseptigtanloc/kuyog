import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/chat_provider.dart';
import '../screens/shared/chat/chat_list_screen.dart';
import '../screens/features/notifications/notifications_screen.dart';
import 'kuyog_logo.dart';

class KuyogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? extraAction;
  
  const KuyogAppBar({super.key, required this.title, this.extraAction});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleSpacing: 0,
      leadingWidth: 100,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: KuyogLogo(fontSize: 24),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(title, style: AppTheme.headline(size: 20)),
      ),
      actions: [
        if (extraAction != null) extraAction!,
        // Chat Icon with Unread Badge
        Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            final unreadCount = chatProvider.totalUnreadCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatListScreen()));
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        // Notification Bell
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
          },
        ),
        // Avatar
        const Padding(
          padding: EdgeInsets.only(right: 16, left: 8),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://picsum.photos/seed/user/100/100'),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_theme.dart';
import '../providers/chat_provider.dart';
import '../screens/shared/chat/chat_list_screen.dart';
import '../screens/features/notifications/notifications_screen.dart';
import 'kuyog_back_button.dart';

class KuyogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? extraAction;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  
  const KuyogAppBar({
    super.key, 
    required this.title, 
    this.leading, 
    this.extraAction, 
    this.actions,
    this.bottom
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      leading: leading ?? (Navigator.canPop(context) ? const Center(child: KuyogBackButton()) : null),
      centerTitle: false,
      titleSpacing: 0,
      bottom: bottom,
      title: Padding(
        padding: EdgeInsets.only(left: (leading == null && !Navigator.canPop(context)) ? 16 : 0),
        child: Text(title, style: AppTheme.headline(size: 20, color: AppColors.textPrimary)),
      ),
      actions: actions ?? [
        ?extraAction,
        // Chat Icon with Unread Badge
        Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            final unreadCount = chatProvider.totalUnreadCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textPrimary, size: 21),
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
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        // Notification Bell with badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
              },
            ),
            // Notification dot (always show for mock)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        // Avatar with green ring
        Padding(
          padding: const EdgeInsets.only(right: 14, left: 4),
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/user/100/100',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.background),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primary.withAlpha(25),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

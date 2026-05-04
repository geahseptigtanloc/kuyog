import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_theme.dart';
import '../providers/chat_provider.dart';
import '../screens/shared/chat/chat_list_screen.dart';
import '../screens/features/notifications/notifications_screen.dart';
import '../providers/role_provider.dart';
import 'kuyog_logo.dart';
import 'kuyog_back_button.dart';
import '../screens/tourist/tourist_profile_tab.dart';
import '../screens/guide/guide_profile_tab.dart';
import '../screens/merchant/merchant_profile_tab.dart';
import '../screens/admin/admin_settings_tab.dart';

class KuyogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? extraAction;
  final PreferredSizeWidget? bottom;
  
  const KuyogAppBar({super.key, required this.title, this.leading, this.extraAction, this.bottom});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: leading ?? (Navigator.canPop(context) ? const Center(child: KuyogBackButton()) : null),
      centerTitle: false,
      titleSpacing: 0,
      bottom: bottom,
      title: Padding(
        padding: EdgeInsets.only(left: (leading == null && !Navigator.canPop(context)) ? 16 : 0),
        child: Text(title, style: AppTheme.headline(size: 20, color: AppColors.primary)),
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
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/seed/user/100/100',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.background),
              errorWidget: (context, url, error) => const Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/chat_provider.dart';
import '../screens/shared/chat/chat_list_screen.dart';
import '../screens/features/notifications/notifications_screen.dart';
import '../providers/role_provider.dart';
import 'kuyog_logo.dart';
import '../screens/tourist/tourist_profile_tab.dart';
import '../screens/guide/guide_profile_tab.dart';
import '../screens/merchant/merchant_profile_tab.dart';
import '../screens/admin/admin_settings_tab.dart';

class KuyogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? extraAction;
  
  const KuyogAppBar({super.key, required this.title, this.extraAction});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleSpacing: 0,
      leadingWidth: canPop ? null : 100,
      leading: canPop 
        ? const BackButton(color: AppColors.primary)
        : const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: KuyogLogo(fontSize: 24),
              ),
            ),
          ),
      title: Padding(
        padding: EdgeInsets.only(left: canPop ? 0 : 12),
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
        Consumer<RoleProvider>(
          builder: (context, roleProvider, child) {
            final user = roleProvider.currentUser;
            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: GestureDetector(
                onTap: () {
                  // Only navigate if we're not already on a profile/settings screen
                  final currentRoute = ModalRoute.of(context)?.settings.name;
                  if (currentRoute == 'profile' || currentRoute == 'settings') return;

                  Widget profileScreen;
                  String routeName = 'profile';
                  
                  switch (roleProvider.currentRole) {
                    case UserRole.tourist:
                      profileScreen = const TouristProfileTab();
                    case UserRole.guide:
                      profileScreen = const GuideProfileTab();
                    case UserRole.merchant:
                      profileScreen = const MerchantProfileTab();
                    case UserRole.admin:
                    case UserRole.superAdmin:
                      profileScreen = const AdminSettingsTab();
                      routeName = 'settings';
                  }

                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      settings: RouteSettings(name: routeName),
                      builder: (_) => profileScreen
                    )
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: user?.avatarUrl.isNotEmpty == true ? NetworkImage(user!.avatarUrl) : null,
                  child: (user?.avatarUrl.isEmpty == true || user?.avatarUrl == null) 
                      ? const Icon(Icons.person, size: 16, color: AppColors.primary) 
                      : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

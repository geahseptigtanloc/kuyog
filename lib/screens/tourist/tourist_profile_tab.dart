import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';
import '../../providers/role_provider.dart';
import '../../providers/miles_provider.dart';
import '../../providers/crawl_provider.dart';
import '../features/miles/miles_dashboard_screen.dart';
import '../features/crawl/crawl_home_screen.dart';
import '../shared/settings_screen.dart';
import '../shared/help_support_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../features/notifications/notifications_list_screen.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_section_header.dart';
import '../../widgets/core/kuyog_button.dart';
import '../../data/services/auth_service.dart';
import 'tourist_preferences_screen.dart';

class TouristProfileTab extends StatelessWidget {
  const TouristProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final roleProvider = context.watch<RoleProvider>();
    final user = roleProvider.currentUser;
    final miles = context.watch<MilesProvider>();
    final crawl = context.watch<CrawlProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(children: [
            // Profile Info Header
            Column(children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary.withAlpha(31),
                backgroundImage: user?.avatarUrl.isNotEmpty == true
                    ? NetworkImage(user!.avatarUrl)
                    : null,
                child: (user?.avatarUrl.isEmpty == true ||
                        user?.avatarUrl == null)
                    ? const Icon(Icons.person, size: 48, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(user?.name ?? roleProvider.userName,
                  style: AppTheme.headline(size: 24)),
              if (user?.email.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(user!.email,
                    style: AppTheme.body(
                        size: 14, color: AppColors.textSecondary)),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                KuyogBadge(
                  label: roleProvider.roleDisplayName,
                  color: AppColors.touristBlue,
                ),
                if (user?.email.isNotEmpty == true ||
                    user?.phone.isNotEmpty == true) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const KuyogBadge(
                    label: 'Verified',
                    color: AppColors.verified,
                    icon: Icons.verified,
                  ),
                ],
              ]),
              const SizedBox(height: AppSpacing.lg),
              KuyogButton(
                label: 'Edit Profile',
                variant: KuyogButtonVariant.outline,
                icon: Icons.edit,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              ),
            ]),
            const SizedBox(height: AppSpacing.xxl),

            // Stats Row
            Row(children: [
              _statCard('Trips', '3', Icons.flight_takeoff),
              const SizedBox(width: AppSpacing.md),
              _statCard('Reviews', '5', Icons.star),
              const SizedBox(width: AppSpacing.md),
              _statCard('Miles', '${miles.balance}', Icons.stars),
              const SizedBox(width: AppSpacing.md),
              _statCard('Stamps', '${crawl.stampCount}', Icons.emoji_events),
            ]),
            const SizedBox(height: AppSpacing.xxl),

            // Menu Section
            _menuItem(Icons.map, 'My Itineraries', '3 trips'),
            _menuItem(Icons.auto_awesome, 'Match Preferences', 'Adjust',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TouristPreferencesScreen()))),
            _menuItem(Icons.bookmark, 'Saved Guides', '5 saved'),
            _menuItem(Icons.favorite, 'Wishlist', '8 items'),
            _menuItem(Icons.stars, 'Madayaw Points', '${miles.balance} pts',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MilesDashboardScreen()))),
            _menuItem(Icons.shopping_bag, 'My Orders', '2 orders'),
            _menuItem(Icons.emoji_events, 'Crawl Progress',
                '${crawl.stampCount}/8',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CrawlHomeScreen()))),

            const SizedBox(height: AppSpacing.xl),
            const KuyogSectionHeader(title: 'Settings', padding: EdgeInsets.zero),
            const SizedBox(height: AppSpacing.md),

            _settingsItem(Icons.notifications, 'Notifications',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsListScreen()))),
            _settingsItem(Icons.language, 'Language'),
            _settingsItem(Icons.lock, 'Privacy'),
            _settingsItem(Icons.help, 'Help & Support',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen()))),
            _settingsItem(Icons.settings, 'General Settings',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()))),
            const SizedBox(height: AppSpacing.md),
            _settingsItem(Icons.logout, 'Logout',
                isDestructive: true, onTap: () => _showLogoutDialog(context)),

            const SizedBox(height: AppSpacing.xxl),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
        child: KuyogCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.label(size: 16, color: AppColors.primary)),
        Text(label,
            style: AppTheme.body(size: 10, color: AppColors.textSecondary)),
      ]),
    ));
  }

  Widget _menuItem(IconData icon, String title, String trailing,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: KuyogCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(title, style: AppTheme.label(size: 14))),
          Text(trailing,
              style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
        ]),
      ),
    );
  }

  Widget _settingsItem(IconData icon, String title,
      {bool isDestructive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: KuyogCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Row(children: [
          Icon(icon,
              size: 20,
              color: isDestructive ? AppColors.error : AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Text(title,
              style: AppTheme.body(
                  size: 14,
                  color: isDestructive
                      ? AppColors.error
                      : AppColors.textPrimary)),
          const Spacer(),
          Icon(Icons.chevron_right,
              size: 18,
              color: isDestructive ? AppColors.error : AppColors.textLight),
        ]),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Log out of Kuyog?', style: AppTheme.headline(size: 20)),
        content: Text('You will need to sign in again to access your account.',
            style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTheme.label(size: 14, color: AppColors.textLight)),
          ),
          KuyogButton(
            label: 'Log Out',
            variant: KuyogButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService().signOut();
              if (context.mounted) context.go('/onboarding');
            },
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          ),
        ],
      ),
    );
  }

}



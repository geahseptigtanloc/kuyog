import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';
import '../../providers/role_provider.dart';
import '../../providers/miles_provider.dart';
import '../../providers/crawl_provider.dart';
import '../features/miles/miles_dashboard_screen.dart';
import '../features/crawl/crawl_home_screen.dart';

class TouristProfileTab extends StatelessWidget {
  const TouristProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final miles = context.watch<MilesProvider>();
    final crawl = context.watch<CrawlProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 8),
            CircleAvatar(radius: 44, backgroundColor: AppColors.primary.withOpacity(0.15), child: const Icon(Icons.person, size: 44, color: AppColors.primary)),
            const SizedBox(height: 12),
            Text('Maria Santos', style: AppTheme.headline(size: 22)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppColors.touristBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('Tourist', style: AppTheme.label(size: 12, color: AppColors.touristBlue)),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.check_circle, size: 14, color: AppColors.verified),
              const SizedBox(width: 4),
              Text('Verified Email', style: AppTheme.body(size: 12, color: AppColors.verified)),
              const SizedBox(width: 12),
              const Icon(Icons.check_circle, size: 14, color: AppColors.verified),
              const SizedBox(width: 4),
              Text('Verified Phone', style: AppTheme.body(size: 12, color: AppColors.verified)),
            ]),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: const Text('Edit Profile')),
            const SizedBox(height: 24),
            _statsRow(miles, crawl),
            const SizedBox(height: 24),
            _menuItem(Icons.map, 'My Itineraries', '3 trips'),
            _menuItem(Icons.bookmark, 'Saved Guides', '5 saved'),
            _menuItem(Icons.favorite, 'Wishlist', '8 items'),
            _menuItem(Icons.stars, 'Kuyog Miles', '${miles.balance} miles', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MilesDashboardScreen()))),
            _menuItem(Icons.shopping_bag, 'My Orders', '2 orders'),
            _menuItem(Icons.emoji_events, 'Crawl Progress', '${crawl.stampCount}/8', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CrawlHomeScreen()))),
            const SizedBox(height: 16),
            _sectionTitle('Settings'),
            _settingsItem(Icons.notifications, 'Notifications'),
            _settingsItem(Icons.language, 'Language'),
            _settingsItem(Icons.lock, 'Privacy'),
            _settingsItem(Icons.help, 'Help & Support'),
            _settingsItem(Icons.info, 'About Kuyog'),
            const SizedBox(height: 8),
            _settingsItem(Icons.logout, 'Logout', isDestructive: true, onTap: () => _showLogoutDialog(context)),
            const SizedBox(height: 16),
            // Role Switcher Dev Mode
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(children: [
                Text('Switch Role — Dev Mode', style: AppTheme.label(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: UserRole.values.map((r) => _roleChip(context, r)).toList()),
              ]),
            ),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statsRow(MilesProvider miles, CrawlProvider crawl) {
    return Row(children: [
      _statCard('Trips', '3', Icons.flight_takeoff),
      const SizedBox(width: 8),
      _statCard('Reviews', '5', Icons.star),
      const SizedBox(width: 8),
      _statCard('Miles', '${miles.balance}', Icons.stars),
      const SizedBox(width: 8),
      _statCard('Stamps', '${crawl.stampCount}', Icons.emoji_events),
    ]);
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Column(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.label(size: 16, color: AppColors.primary)),
        Text(label, style: AppTheme.body(size: 10, color: AppColors.textSecondary)),
      ]),
    ));
  }

  Widget _menuItem(IconData icon, String title, String trailing, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTheme.label(size: 14))),
          Text(trailing, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(alignment: Alignment.centerLeft, child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTheme.headline(size: 16)),
    ));
  }

  Widget _settingsItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(children: [
          Icon(icon, size: 20, color: isDestructive ? AppColors.error : AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(title, style: AppTheme.body(size: 14, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
          const Spacer(),
          Icon(Icons.chevron_right, size: 18, color: isDestructive ? AppColors.error : AppColors.textLight),
        ]),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Log out of Kuyog?', style: AppTheme.headline(size: 20)),
        content: Text('You will need to sign in again to access your account.', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/onboarding');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(BuildContext context, UserRole role) {
    final current = context.read<RoleProvider>().currentRole;
    final isActive = current == role;
    final labels = {UserRole.tourist: 'Tourist', UserRole.guide: 'Guide', UserRole.merchant: 'Merchant', UserRole.admin: 'Admin', UserRole.superAdmin: 'Super Admin'};
    return GestureDetector(
      onTap: () => context.read<RoleProvider>().switchRole(role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: isActive ? AppColors.primary : AppColors.divider),
        ),
        child: Text('${labels[role]}', style: AppTheme.label(size: 12, color: isActive ? Colors.white : AppColors.textPrimary)),
      ),
    );
  }
}

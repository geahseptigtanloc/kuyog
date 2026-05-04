import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_app_bar.dart';

class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Settings', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 24),
            _settingsSection('Platform', [
              _settingsItem(Icons.campaign, 'Platform Announcements'),
              _settingsItem(Icons.toggle_on, 'Feature Flags'),
              _settingsItem(Icons.download, 'Export Data'),
            ]),
            const SizedBox(height: 16),
            _settingsSection('Account', [
              _settingsItem(Icons.person, 'Admin Profile'),
              _settingsItem(Icons.security, 'Security'),
              _settingsItem(Icons.help, 'Help & Support'),
              _settingsItem(Icons.logout, 'Logout', isDestructive: true, onTap: () => _showLogoutDialog(context)),
            ]),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _settingsSection(String title, List<Widget> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTheme.headline(size: 16)),
      const SizedBox(height: 8),
      ...items,
    ]);
  }

  Widget _settingsItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
}

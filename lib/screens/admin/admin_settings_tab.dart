import 'package:flutter/material.dart';
import '../../app_theme.dart';

class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              _settingsItem(Icons.logout, 'Logout'),
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

  Widget _settingsItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(title, style: AppTheme.body(size: 14)),
        const Spacer(),
        const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
      ]),
    );
  }
}

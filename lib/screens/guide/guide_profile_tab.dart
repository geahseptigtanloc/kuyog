import 'package:flutter/material.dart';
import '../../app_theme.dart';

class GuideProfileTab extends StatelessWidget {
  const GuideProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 8),
            Stack(children: [
              CircleAvatar(radius: 44, backgroundColor: AppColors.primary.withValues(alpha: 0.15), child: const Icon(Icons.person, size: 44, color: AppColors.primary)),
              Positioned(right: 0, bottom: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.verified, size: 20, color: AppColors.verified))),
            ]),
            const SizedBox(height: 12),
            Text('Juan dela Cruz', style: AppTheme.headline(size: 22)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.verified.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('Verified Kuyog Guide', style: AppTheme.label(size: 12, color: AppColors.verified))),
            const SizedBox(height: 16),
            Row(children: [
              _statCard('150+', 'Trips'),
              const SizedBox(width: 8),
              _statCard('4.9', 'Rating'),
              const SizedBox(width: 8),
              _statCard('3', 'Languages'),
              const SizedBox(width: 8),
              _statCard('5 Yrs', 'Experience'),
            ]),
            const SizedBox(height: 24),
            _menuItem(Icons.edit, 'Edit Profile'),
            _menuItem(Icons.calendar_month, 'Availability Calendar'),
            _menuItem(Icons.backpack, 'Tour Packages'),
            _menuItem(Icons.attach_money, 'Pricing'),
            _menuItem(Icons.badge, 'Certifications'),
            _menuItem(Icons.account_balance, 'Payout Settings'),
            _menuItem(Icons.bar_chart, 'Earnings & Insights'),
            const SizedBox(height: 16),
            _menuItem(Icons.settings, 'Settings'),
            _menuItem(Icons.help, 'Help & Support'),
            _menuItem(Icons.logout, 'Logout', isDestructive: true),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Column(children: [
        Text(value, style: AppTheme.label(size: 15, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTheme.body(size: 10, color: AppColors.textSecondary)),
      ]),
    ));
  }

  Widget _menuItem(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        Icon(icon, size: 20, color: isDestructive ? AppColors.error : AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(title, style: AppTheme.body(size: 14, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
        const Spacer(),
        Icon(Icons.chevron_right, size: 18, color: isDestructive ? AppColors.error : AppColors.textLight),
      ]),
    );
  }
}

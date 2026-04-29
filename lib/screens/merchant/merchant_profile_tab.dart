import 'package:flutter/material.dart';
import '../../app_theme.dart';

class MerchantProfileTab extends StatelessWidget {
  const MerchantProfileTab({super.key});

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
            CircleAvatar(radius: 44, backgroundColor: AppColors.merchantAmber.withValues(alpha: 0.15), child: const Icon(Icons.store, size: 44, color: AppColors.merchantAmber)),
            const SizedBox(height: 12),
            Text('T\'boli Weaves Co.', style: AppTheme.headline(size: 22)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.merchantAmber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('Verified Merchant', style: AppTheme.label(size: 12, color: AppColors.merchantAmber))),
            const SizedBox(height: 24),
            _menuItem(Icons.edit, 'Edit Store Profile'),
            _menuItem(Icons.access_time, 'Operating Hours'),
            _menuItem(Icons.local_shipping, 'Delivery Settings'),
            _menuItem(Icons.account_balance, 'Payout Settings'),
            _menuItem(Icons.bar_chart, 'Sales Analytics'),
            _menuItem(Icons.reviews, 'Customer Reviews'),
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

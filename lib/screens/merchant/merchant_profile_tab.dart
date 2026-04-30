import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';
import '../shared/settings_screen.dart';
import '../shared/help_support_screen.dart';
import '../shared/edit_profile_screen.dart';
import 'merchant_operating_hours_screen.dart';
import 'merchant_delivery_settings_screen.dart';
import 'merchant_reviews_screen.dart';

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
            CircleAvatar(radius: 44, backgroundColor: AppColors.merchantAmber.withOpacity(0.15), child: const Icon(Icons.store, size: 44, color: AppColors.merchantAmber)),
            const SizedBox(height: 12),
            Text('T\'boli Weaves Co.', style: AppTheme.headline(size: 22)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.merchantAmber.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('Verified Merchant', style: AppTheme.label(size: 12, color: AppColors.merchantAmber))),
            const SizedBox(height: 24),
            _menuItem(Icons.edit, 'Edit Store Profile', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            _menuItem(Icons.access_time, 'Operating Hours', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantOperatingHoursScreen()))),
            _menuItem(Icons.local_shipping, 'Delivery Settings', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantDeliverySettingsScreen()))),
            _menuItem(Icons.account_balance, 'Payout Settings'),
            _menuItem(Icons.bar_chart, 'Sales Analytics'),
            _menuItem(Icons.reviews, 'Customer Reviews', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MerchantReviewsScreen()))),
            const SizedBox(height: 16),
            _menuItem(Icons.settings, 'Settings', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            _menuItem(Icons.help, 'Help & Support', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()))),
            _menuItem(Icons.logout, 'Logout', isDestructive: true, onTap: () => _showLogoutDialog(context)),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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

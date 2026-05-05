import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_button.dart';
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
      appBar: const KuyogAppBar(title: 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(children: [
            const SizedBox(height: AppSpacing.md),
            CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.merchantAmber.withAlpha(38),
                child: const Icon(Icons.store,
                    size: 48, color: AppColors.merchantAmber)),
            const SizedBox(height: AppSpacing.md),
            Text('T\'boli Weaves Co.', style: AppTheme.headline(size: 24)),
            const SizedBox(height: AppSpacing.sm),
            const KuyogBadge(
              label: 'Verified Merchant',
              color: AppColors.merchantAmber,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _menuItem(Icons.edit, 'Edit Store Profile',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()))),
            _menuItem(Icons.access_time, 'Operating Hours',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const MerchantOperatingHoursScreen()))),
            _menuItem(Icons.local_shipping, 'Delivery Settings',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const MerchantDeliverySettingsScreen()))),
            _menuItem(Icons.account_balance, 'Payout Settings'),
            _menuItem(Icons.bar_chart, 'Sales Analytics'),
            _menuItem(Icons.reviews, 'Customer Reviews',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MerchantReviewsScreen()))),
            const SizedBox(height: AppSpacing.md),
            _menuItem(Icons.settings, 'Settings',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()))),
            _menuItem(Icons.help, 'Help & Support',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen()))),
            const SizedBox(height: AppSpacing.md),
            _menuItem(Icons.logout, 'Logout',
                isDestructive: true, onTap: () => _showLogoutDialog(context)),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title,
      {bool isDestructive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: KuyogCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
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
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/onboarding');
            },
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          ),
        ],
      ),
    );
  }
}



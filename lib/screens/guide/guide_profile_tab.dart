import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../providers/role_provider.dart';
import '../shared/settings_screen.dart';
import '../shared/help_support_screen.dart';
import 'guide_edit_profile_screen.dart';
import 'guide_availability_screen.dart';
import 'guide_pricing_screen.dart';
import 'guide_certifications_screen.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_button.dart';

class GuideProfileTab extends StatefulWidget {
  const GuideProfileTab({super.key});

  @override
  State<GuideProfileTab> createState() => _GuideProfileTabState();
}

class _GuideProfileTabState extends State<GuideProfileTab> {
  Map<String, dynamic>? _guideProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGuideProfile();
  }

  Future<void> _loadGuideProfile() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final res = await Supabase.instance.client
          .from('guide_profiles')
          .select()
          .eq('profile_id', user.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _guideProfile = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching guide profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<RoleProvider>().currentUser;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: KuyogAppBar(title: 'Profile'),
        body:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final name = user?.name ?? 'Unnamed Guide';
    final isVerified = user?.isVerified ?? false;
    final avatarUrl = user?.avatarUrl;

    // Extract dynamic stats with fallbacks
    final tripCount = _guideProfile?['tripCount'] ?? 0;
    final rating = _guideProfile?['rating'] ?? 0.0;
    final yearsExp = _guideProfile?['yearsExperience'] ?? 0;

    // Languages is in the main profiles table, not guide_profiles
    final languagesList = user?.languages ?? [];
    final languagesCount = languagesList.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(children: [
            const SizedBox(height: AppSpacing.md),
            Stack(children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary.withAlpha(31),
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 48, color: AppColors.primary)
                    : null,
              ),
              if (isVerified)
                const Positioned(
                    right: 0,
                    bottom: 0,
                    child: KuyogBadge(
                      label: '',
                      color: AppColors.verified,
                      icon: Icons.verified,
                      padding: EdgeInsets.all(4),
                    )),
            ]),
            const SizedBox(height: AppSpacing.md),
            Text(name, style: AppTheme.headline(size: 24)),
            const SizedBox(height: AppSpacing.sm),
            KuyogBadge(
              label: isVerified ? 'Verified Kuyog Guide' : 'Unverified Guide',
              color: isVerified ? AppColors.verified : AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(children: [
              _statCard('$tripCount', 'Trips'),
              const SizedBox(width: AppSpacing.md),
              _statCard('$rating', 'Rating'),
              const SizedBox(width: AppSpacing.md),
              _statCard('$languagesCount', 'Languages'),
              const SizedBox(width: AppSpacing.md),
              _statCard('$yearsExp Yrs', 'Exp'),
            ]),
            const SizedBox(height: AppSpacing.xxl),
            _menuItem(Icons.edit, 'Edit Profile', onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const GuideEditProfileScreen()))
                  .then((_) {
                setState(() {});
              });
            }),
            _menuItem(Icons.calendar_month, 'Availability Calendar',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const GuideAvailabilityScreen()))),
            _menuItem(Icons.backpack, 'Tour Packages'),
            _menuItem(Icons.attach_money, 'Pricing',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const GuidePricingScreen()))),
            _menuItem(Icons.badge, 'Certifications',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const GuideCertificationsScreen()))),
            _menuItem(Icons.account_balance, 'Payout Settings'),
            _menuItem(Icons.bar_chart, 'Earnings & Insights'),
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

  Widget _statCard(String value, String label) {
    return Expanded(
        child: KuyogCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(children: [
        Text(value, style: AppTheme.label(size: 16, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label,
            style: AppTheme.body(size: 10, color: AppColors.textSecondary)),
      ]),
    ));
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



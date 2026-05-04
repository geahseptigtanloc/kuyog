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
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
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
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 8),
            Stack(children: [
              CircleAvatar(
                radius: 44, 
                backgroundColor: AppColors.primary.withValues(alpha: 0.12), 
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null || avatarUrl.isEmpty ? const Icon(Icons.person, size: 44, color: AppColors.primary) : null,
              ),
              if (isVerified)
                Positioned(right: 0, bottom: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.verified, size: 20, color: AppColors.verified))),
            ]),
            const SizedBox(height: 12),
            Text(name, style: AppTheme.headline(size: 22)),
            const SizedBox(height: 4),
            if (isVerified)
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.verified.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text('Verified Kuyog Guide', style: AppTheme.label(size: 13, weight: FontWeight.w800, color: AppColors.verified))),
            if (!isVerified)
               Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text('Unverified Guide', style: AppTheme.label(size: 13, weight: FontWeight.w800, color: AppColors.warning))),
            const SizedBox(height: 16),
            Row(children: [
              _statCard('$tripCount', 'Trips'),
              const SizedBox(width: 8),
              _statCard('$rating', 'Rating'),
              const SizedBox(width: 8),
              _statCard('$languagesCount', 'Languages'),
              const SizedBox(width: 8),
              _statCard('$yearsExp Yrs', 'Experience'),
            ]),
            const SizedBox(height: 24),
            _menuItem(Icons.edit, 'Edit Profile', onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const GuideEditProfileScreen())).then((_) {
                 setState(() {});
               });
            }),
            _menuItem(Icons.calendar_month, 'Availability Calendar', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuideAvailabilityScreen()))),
            _menuItem(Icons.backpack, 'Tour Packages'),
            _menuItem(Icons.attach_money, 'Pricing', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuidePricingScreen()))),
            _menuItem(Icons.badge, 'Certifications', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuideCertificationsScreen()))),
            _menuItem(Icons.account_balance, 'Payout Settings'),
            _menuItem(Icons.bar_chart, 'Earnings & Insights'),
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

  Widget _menuItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
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

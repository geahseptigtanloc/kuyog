import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/role_provider.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_section_header.dart';
import '../../widgets/core/kuyog_button.dart';
import '../shared/verification_gate_screen.dart';

class GuideHomeTab extends StatelessWidget {
  const GuideHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(title: role.greeting),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (role.currentUser?.isVerified == true)
              const KuyogBadge(
                label: 'Verified Kuyog Guide',
                color: AppColors.verified,
                icon: Icons.verified,
              )
            else
              const KuyogBadge(
                label: 'Unverified Guide',
                color: AppColors.textSecondary,
                icon: Icons.pending_actions,
              ),
            const SizedBox(height: AppSpacing.xl),
            // Stats Dashboard
            Row(children: [
              _statCard(Icons.calendar_month, 'Bookings', '12', AppColors.touristBlue),
              const SizedBox(width: AppSpacing.md),
              _statCard(Icons.star, 'Rating', '4.9', AppColors.warning),
            ]),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              _statCard(Icons.attach_money, 'Earnings', '₱24.5K', AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              _statCard(Icons.people, 'Tourists', '47', AppColors.accent),
            ]),
            const SizedBox(height: AppSpacing.xl),
            _verifyBanner(context),
            const SizedBox(height: AppSpacing.xxl),
            const KuyogSectionHeader(title: 'Quick Actions', padding: EdgeInsets.zero),
            const SizedBox(height: AppSpacing.lg),
            _quickActionsGrid(),
            const SizedBox(height: AppSpacing.xxl),
            const KuyogSectionHeader(title: 'Upcoming Bookings', padding: EdgeInsets.zero),
            const SizedBox(height: AppSpacing.lg),
            _bookingCard('Anna Reyes', 'Davao City Explorer', 'May 5-7, 2026', 'Confirmed', AppColors.primary),
            _bookingCard('Mike Torres', 'CDO Adventure Tour', 'May 10-12, 2026', 'Pending', AppColors.warning),
            _bookingCard('Sarah Kim', 'Lake Sebu Cultural', 'May 15-16, 2026', 'Confirmed', AppColors.primary),
            const SizedBox(height: AppSpacing.xxl),
            // Create Itinerary CTA
            KuyogCard(
              color: AppColors.primary,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Create Itinerary', style: AppTheme.headline(size: 20, color: Colors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Build custom tours for your clients', style: AppTheme.body(size: 13, color: Colors.white70)),
                  const SizedBox(height: AppSpacing.lg),
                  KuyogButton(
                    label: 'Start Creating',
                    variant: KuyogButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ])),
                const Icon(Icons.map_rounded, size: 56, color: Colors.white24),
              ]),
            ),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Expanded(child: KuyogCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: AppSpacing.md),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: AppTheme.headline(size: 18, color: color)),
          Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
        ]),
      ]),
    ));
  }

  Widget _quickActionsGrid() {
    final items = [
      ('Bookings', Icons.calendar_today, AppColors.touristBlue),
      ('Messages', Icons.chat_bubble, AppColors.primary),
      ('Reviews', Icons.star, AppColors.warning),
      ('Earnings', Icons.account_balance_wallet, AppColors.accent),
      ('Insights', Icons.insights, AppColors.adminPurple),
      ('Transport', Icons.directions_car, const Color(0xFF0891B2)),
      ('Marketplace', Icons.store, AppColors.merchantAmber),
      ('More', Icons.grid_view, AppColors.textSecondary),
    ];
    return GridView.count(
      crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md, crossAxisSpacing: AppSpacing.sm, childAspectRatio: 0.8,
      children: items.map((a) => Column(children: [
        KuyogCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: a.$3.withAlpha(26),
          radius: AppRadius.lg,
          shadow: const [],
          onTap: () {},
          child: Icon(a.$2, color: a.$3, size: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(a.$1, style: AppTheme.label(size: 10), textAlign: TextAlign.center, maxLines: 1),
      ])).toList(),
    );
  }

  Widget _bookingCard(String name, String tour, String date, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: KuyogCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(children: [
          CircleAvatar(radius: 22, backgroundColor: AppColors.primary.withAlpha(31), child: const Icon(Icons.person, color: AppColors.primary)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.label(size: 14)),
            Text('$tour · $date', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
          ])),
          KuyogBadge(label: status, color: statusColor),
        ]),
      ),
    );
  }

  Widget _verifyBanner(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final isVerified = roleProvider.currentUser?.isVerified ?? false;
    
    if (isVerified) return const SizedBox.shrink(); 
    
    const status = 'pending'; 

    Color iconColor;
    IconData icon;
    String title;
    String subtitle;

    switch (status) {
      case 'submitted':
        iconColor = AppColors.touristBlue;
        icon = Icons.hourglass_top;
        title = 'Verification in Progress';
        subtitle = 'Your documents are being reviewed.';
        break;
      case 'draft':
        iconColor = AppColors.accent;
        icon = Icons.upload_file;
        title = 'Resume Verification';
        subtitle = 'Finish uploading your documents.';
        break;
      case 'rejected':
        iconColor = AppColors.error;
        icon = Icons.error_outline;
        title = 'Action Required';
        subtitle = 'Verification was rejected. Please update.';
        break;
      case 'pending':
      default:
        iconColor = AppColors.warning;
        icon = Icons.verified_user;
        title = 'Complete Verification';
        subtitle = 'Unlock all features for guides.';
        break;
    }

    return KuyogCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationGateScreen())),
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: iconColor.withAlpha(20),
      borderSide: BorderSide(color: iconColor.withAlpha(76)),
      child: Row(children: [
        Icon(icon, size: 28, color: iconColor),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.label(size: 14, color: iconColor)),
          Text(subtitle, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
        ])),
        Icon(Icons.chevron_right, color: iconColor),
      ]),
    );
  }
}



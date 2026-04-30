import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/role_provider.dart';
import 'verification_gate_screen.dart';


class GuideHomeTab extends StatelessWidget {
  const GuideHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(role.greeting, style: AppTheme.headline(size: 22)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.verified, size: 14, color: AppColors.verified),
                  const SizedBox(width: 4),
                  Text('Verified Kuyog Guide', style: AppTheme.label(size: 12, color: AppColors.verified)),
                ]),
              ])),
              Stack(clipBehavior: Clip.none, children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.card),
                  child: const Icon(Icons.notifications_outlined, size: 22)),
                Positioned(right: -2, top: -2, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  child: const Text('5', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)))),
              ]),
            ]),
            const SizedBox(height: 24),
            // Stats Dashboard
            Row(children: [
              _statCard(Icons.calendar_month, 'Bookings', '12', AppColors.touristBlue),
              const SizedBox(width: 8),
              _statCard(Icons.star, 'Rating', '4.9', AppColors.warning),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              _statCard(Icons.attach_money, 'Earnings', '₱24.5K', AppColors.primary),
              const SizedBox(width: 8),
              _statCard(Icons.people, 'Tourists', '47', AppColors.accent),
            ]),
            const SizedBox(height: 16),
            _verifyBanner(context),
            const SizedBox(height: 24),
            Text('Quick Actions', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 12),
            _quickActionsGrid(),
            const SizedBox(height: 24),
            Text('Upcoming Bookings', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 12),
            _bookingCard('Anna Reyes', 'Davao City Explorer', 'May 5-7, 2026', 'Confirmed', AppColors.primary),
            _bookingCard('Mike Torres', 'CDO Adventure Tour', 'May 10-12, 2026', 'Pending', AppColors.warning),
            _bookingCard('Sarah Kim', 'Lake Sebu Cultural', 'May 15-16, 2026', 'Confirmed', AppColors.primary),
            const SizedBox(height: 24),
            // Create Itinerary CTA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.primary]), borderRadius: BorderRadius.circular(AppRadius.xxl)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Create Itinerary', style: AppTheme.headline(size: 18, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Build custom tours for your clients', style: AppTheme.body(size: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                    child: Text('Start Creating', style: AppTheme.label(size: 13, color: AppColors.primary))),
                ])),
                const Icon(Icons.map_rounded, size: 48, color: Colors.white30),
              ]),
            ),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: AppTheme.headline(size: 18, color: color)),
          Text(label, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
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
      mainAxisSpacing: 12, crossAxisSpacing: 8, childAspectRatio: 0.85,
      children: items.map((a) => Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: a.$3.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Icon(a.$2, color: a.$3, size: 22)),
        const SizedBox(height: 6),
        Text(a.$1, style: AppTheme.label(size: 10), textAlign: TextAlign.center, maxLines: 1),
      ])).toList(),
    );
  }

  Widget _bookingCard(String name, String tour, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        CircleAvatar(radius: 22, backgroundColor: AppColors.primary.withOpacity(0.15), child: const Icon(Icons.person, color: AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 14)),
          Text('$tour · $date', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
          child: Text(status, style: AppTheme.label(size: 11, color: statusColor))),
      ]),
    );
  }

  Widget _verifyBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationGateScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.verified_user, size: 28, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Complete Verification', style: AppTheme.label(size: 14, color: AppColors.warning)),
            Text('Upload documents to unlock all features', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.warning),
        ]),
      ),
    );
  }
}

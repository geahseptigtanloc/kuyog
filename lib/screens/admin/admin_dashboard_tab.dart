import 'package:flutter/material.dart';
import '../../app_theme.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Admin Dashboard', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 4),
            Text('Platform overview', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Row(children: [
              _statCard('1,247', 'Total Users', Icons.people, AppColors.touristBlue),
              const SizedBox(width: 8),
              _statCard('8', 'Pending', Icons.pending_actions, AppColors.warning),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              _statCard('43', 'Active Guides', Icons.verified_user, AppColors.primary),
              const SizedBox(width: 8),
              _statCard('3', 'Open Reports', Icons.report, AppColors.error),
            ]),
            const SizedBox(height: 24),
            Text('Recent Activity', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 12),
            _activityItem(Icons.person_add, 'New guide application', 'Rico Magbanua submitted verification', '2h ago', AppColors.primary),
            _activityItem(Icons.report, 'Content reported', 'Post flagged as inappropriate', '5h ago', AppColors.error),
            _activityItem(Icons.verified, 'Guide approved', 'Alyssa Flores verified', '1d ago', AppColors.verified),
            _activityItem(Icons.store, 'Merchant joined', 'Highland Bee Farm registered', '2d ago', AppColors.merchantAmber),
            _activityItem(Icons.person_add, 'New guide application', 'Datu Kamlon submitted verification', '3d ago', AppColors.primary),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 12),
        Text(value, style: AppTheme.headline(size: 24, color: color)),
        Text(label, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
      ]),
    ));
  }

  Widget _activityItem(IconData icon, String title, String subtitle, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withAlpha(26), shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.label(size: 13)),
          Text(subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        Text(time, style: AppTheme.body(size: 11, color: AppColors.textLight)),
      ]),
    );
  }
}


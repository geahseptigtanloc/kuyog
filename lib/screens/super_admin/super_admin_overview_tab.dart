import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app_theme.dart';

class SuperAdminOverviewTab extends StatelessWidget {
  const SuperAdminOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Platform Overview', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 4),
            Text('Kuyog Admin Console', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Row(children: [
              _statCard('1,247', 'Users', Icons.people, AppColors.touristBlue),
              const SizedBox(width: 8),
              _statCard('843', 'MAU', Icons.trending_up, AppColors.primary),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              _statCard('₱1.2M', 'Revenue', Icons.payments, AppColors.accent),
              const SizedBox(width: 8),
              _statCard('43', 'Guides', Icons.verified_user, AppColors.verified),
            ]),
            const SizedBox(height: 24),
            Text('User Distribution', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
              child: PieChart(PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(value: 78, title: '78%', color: AppColors.touristBlue, radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 12, title: '12%', color: AppColors.primary, radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 8, title: '8%', color: AppColors.merchantAmber, radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 2, title: '2%', color: AppColors.adminPurple, radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              )),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _legend(AppColors.touristBlue, 'Tourists'),
              const SizedBox(width: 16),
              _legend(AppColors.primary, 'Guides'),
              const SizedBox(width: 16),
              _legend(AppColors.merchantAmber, 'Merchants'),
              const SizedBox(width: 16),
              _legend(AppColors.adminPurple, 'Admins'),
            ]),
            const SizedBox(height: 24),
            Text('Top Destinations', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 12),
            _rankItem(1, 'Siargao Island', '2,340 visits', AppColors.accent),
            _rankItem(2, 'Mount Apo', '1,890 visits', AppColors.primary),
            _rankItem(3, 'Enchanted River', '1,456 visits', AppColors.touristBlue),
            _rankItem(4, 'Camiguin Island', '1,230 visits', AppColors.primaryLight),
            _rankItem(5, 'Lake Sebu', '987 visits', AppColors.textSecondary),
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
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 10),
        Text(value, style: AppTheme.headline(size: 22, color: color)),
        Text(label, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
      ]),
    ));
  }

  Widget _legend(Color color, String label) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
    ]);
  }

  Widget _rankItem(int rank, String name, String visits, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(color: color.withAlpha(26), shape: BoxShape.circle),
          child: Center(child: Text('$rank', style: AppTheme.label(size: 13, color: color)))),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: AppTheme.label(size: 14))),
        Text(visits, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
      ]),
    );
  }
}


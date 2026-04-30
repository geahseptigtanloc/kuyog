import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app_theme.dart';

class SuperAdminAnalyticsTab extends StatelessWidget {
  const SuperAdminAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Analytics', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 4),
            Text('DOT / LGU Dashboard', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Text('Monthly Bookings', style: AppTheme.headline(size: 16)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
              child: BarChart(BarChartData(
                barGroups: [
                  _bar(0, 45), _bar(1, 67), _bar(2, 89), _bar(3, 72), _bar(4, 105), _bar(5, 134),
                ],
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
                    const months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
                    return Text(months[v.toInt()], style: AppTheme.body(size: 10, color: AppColors.textLight));
                  })),
                ),
              )),
            ),
            const SizedBox(height: 24),
            Text('Top Performing Guides', style: AppTheme.headline(size: 16)),
            const SizedBox(height: 12),
            _guidePerf('Maria Santos', '156 trips', '4.9'),
            _guidePerf('Alyssa Flores', '278 trips', '4.85'),
            _guidePerf('Juan dela Cruz', '203 trips', '4.8'),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf, size: 16), label: const Text('Export PDF'))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.table_chart, size: 16), label: const Text('Export CSV'))),
            ]),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(x: x, barRods: [BarChartRodData(toY: y, color: AppColors.primary, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]);
  }

  Widget _guidePerf(String name, String trips, String rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withOpacity(0.15), child: const Icon(Icons.person, color: AppColors.primary, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 14)),
          Text(trips, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        Text(rating, style: AppTheme.label(size: 13)),
      ]),
    );
  }
}

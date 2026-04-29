import 'package:flutter/material.dart';
import '../../app_theme.dart';

class MerchantDashboardTab extends StatelessWidget {
  const MerchantDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Maayong adlaw, Fatima!', style: AppTheme.headline(size: 22)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.verified, size: 14, color: AppColors.verified),
              const SizedBox(width: 4),
              Text('T\'boli Weaves Co.', style: AppTheme.label(size: 13, color: AppColors.verified)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              _statCard('₱3,200', 'Sales Today', Icons.payments, AppColors.primary),
              const SizedBox(width: 8),
              _statCard('8', 'Orders', Icons.receipt_long, AppColors.accent),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              _statCard('24', 'Products', Icons.inventory_2, AppColors.touristBlue),
              const SizedBox(width: 8),
              _statCard('4.7', 'Rating', Icons.star, AppColors.warning),
            ]),
            const SizedBox(height: 24),
            Text('Recent Orders', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 12),
            _orderCard('Anna Reyes', 'T\'nalak Woven Bag × 1', '₱1,950', 'New', AppColors.accent),
            _orderCard('Mike Torres', 'Coffee Sampler × 2, Honey × 1', '₱2,510', 'Processing', AppColors.touristBlue),
            _orderCard('Carlos Garcia', 'Tribal Print Shirt × 3', '₱2,050', 'Ready', AppColors.primary),
            _orderCard('Sarah Kim', 'Brass Tray × 1', '₱3,600', 'Completed', AppColors.textLight),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentLight]), borderRadius: BorderRadius.circular(AppRadius.xxl)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sales Analytics', style: AppTheme.headline(size: 18, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Track your revenue and top products', style: AppTheme.body(size: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                    child: Text('View Analytics', style: AppTheme.label(size: 12, color: AppColors.accent))),
                ])),
                const Icon(Icons.analytics, size: 48, color: Colors.white30),
              ]),
            ),
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
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
          child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: AppTheme.label(size: 16, color: color)),
          Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
        ]),
      ]),
    ));
  }

  Widget _orderCard(String name, String items, String total, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: statusColor.withValues(alpha: 0.15), child: Icon(Icons.person, color: statusColor, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 13)),
          Text(items, style: AppTheme.body(size: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(total, style: AppTheme.label(size: 13, color: AppColors.primary)),
          const SizedBox(height: 2),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text(status, style: AppTheme.label(size: 10, color: statusColor))),
        ]),
      ]),
    );
  }
}

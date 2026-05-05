import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_section_header.dart';
import '../../widgets/core/kuyog_button.dart';

class MerchantDashboardTab extends StatelessWidget {
  const MerchantDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxxl),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Maayong adlaw, Fatima!', style: AppTheme.headline(size: 24)),
            const SizedBox(height: AppSpacing.xs),
            const KuyogBadge(
              label: 'T\'boli Weaves Co.',
              color: AppColors.verified,
              icon: Icons.verified,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(children: [
              _statCard('₱3,200', 'Sales Today', Icons.payments, AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              _statCard('8', 'Orders', Icons.receipt_long, AppColors.accent),
            ]),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              _statCard('24', 'Products', Icons.inventory_2, AppColors.touristBlue),
              const SizedBox(width: AppSpacing.md),
              _statCard('4.7', 'Rating', Icons.star, AppColors.warning),
            ]),
            const SizedBox(height: AppSpacing.xxl),
            const KuyogSectionHeader(title: 'Recent Orders', padding: EdgeInsets.zero),
            const SizedBox(height: AppSpacing.md),
            _orderCard('Anna Reyes', 'T\'nalak Woven Bag × 1', '₱1,950', 'New', AppColors.accent),
            _orderCard('Mike Torres', 'Coffee Sampler × 2, Honey × 1', '₱2,510', 'Processing', AppColors.touristBlue),
            _orderCard('Carlos Garcia', 'Tribal Print Shirt × 3', '₱2,050', 'Ready', AppColors.primary),
            _orderCard('Sarah Kim', 'Brass Tray × 1', '₱3,600', 'Completed', AppColors.textLight),
            const SizedBox(height: AppSpacing.xxl),
            KuyogCard(
              color: AppColors.accent,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sales Analytics', style: AppTheme.headline(size: 20, color: Colors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Track your revenue and top products', style: AppTheme.body(size: 13, color: Colors.white70)),
                  const SizedBox(height: AppSpacing.lg),
                  KuyogButton(
                    label: 'View Analytics',
                    variant: KuyogButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ])),
                const Icon(Icons.analytics, size: 56, color: Colors.white24),
              ]),
            ),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(child: KuyogCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: AppSpacing.md),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: AppTheme.headline(size: 18, color: color)),
          Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
        ]),
      ]),
    ));
  }

  Widget _orderCard(String name, String items, String total, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: KuyogCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(children: [
          CircleAvatar(radius: 20, backgroundColor: statusColor.withAlpha(31), child: Icon(Icons.person, color: statusColor, size: 20)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.label(size: 14)),
            Text(items, style: AppTheme.body(size: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(total, style: AppTheme.label(size: 14, color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xs),
            KuyogBadge(label: status, color: statusColor),
          ]),
        ]),
      ),
    );
  }
}



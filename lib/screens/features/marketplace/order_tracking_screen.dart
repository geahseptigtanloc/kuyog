import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../../../../widgets/kuyog_back_button.dart';
import '../../../../models/order.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('Order Details', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Order #${order.id.substring(4)}', style: AppTheme.headline(size: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(order.status, style: AppTheme.label(size: 12, color: _statusColor(order.status))),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Text(DateFormat('MMM dd, yyyy').format(order.orderDate), style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
                  ]),
                ),
                const SizedBox(height: 24),
                Text('Items', style: AppTheme.headline(size: 16)),
                const SizedBox(height: 12),
                ...order.items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Row(children: [
                    Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)), child: const Icon(Icons.inventory_2, color: AppColors.primary)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.productName, style: AppTheme.label(size: 14)),
                      Text('Qty: ${item.quantity}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                    ])),
                    Text('₱${item.price.toStringAsFixed(0)}', style: AppTheme.label(size: 14)),
                  ]),
                )),
                const SizedBox(height: 24),
                Text('Order Tracking', style: AppTheme.headline(size: 16)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                  child: Column(children: [
                    _timelineStep('Order Placed', 'We have received your order', true, true),
                    _timelineStep('Processing', 'Merchant is preparing your items', order.status != 'Pending', true),
                    _timelineStep('Shipped', 'Your order is on the way', order.status == 'Shipped' || order.status == 'Delivered', true),
                    _timelineStep('Delivered', 'Order has arrived', order.status == 'Delivered', false),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending': return AppColors.warning;
      case 'Processing': return AppColors.primary;
      case 'Shipped': return AppColors.touristBlue;
      case 'Delivered': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  Widget _timelineStep(String title, String subtitle, bool isCompleted, bool showLine) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.success : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: isCompleted ? AppColors.success : AppColors.divider, width: 2),
          ),
          child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
        ),
        if (showLine) Container(width: 2, height: 40, color: isCompleted ? AppColors.success : AppColors.divider),
      ]),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTheme.label(size: 15, color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTheme.body(size: 13, color: AppColors.textLight)),
        const SizedBox(height: 20),
      ])),
    ]);
  }
}

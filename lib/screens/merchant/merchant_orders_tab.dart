import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/order.dart';
import '../features/marketplace/order_tracking_screen.dart';

class MerchantOrdersTab extends StatefulWidget {
  const MerchantOrdersTab({super.key});
  @override
  State<MerchantOrdersTab> createState() => _MerchantOrdersTabState();
}

class _MerchantOrdersTabState extends State<MerchantOrdersTab> with SingleTickerProviderStateMixin {
  late TabController _tc;
  @override
  void initState() { super.initState(); _tc = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Text('Orders', style: AppTheme.headline(size: 24))),
          const SizedBox(height: 16),
          TabBar(controller: _tc, labelColor: AppColors.primary, unselectedLabelColor: AppColors.textLight, indicatorColor: AppColors.primary, indicatorSize: TabBarIndicatorSize.label,
            tabs: const [Tab(text: 'New'), Tab(text: 'Processing'), Tab(text: 'Completed'), Tab(text: 'Cancelled')]),
          Expanded(child: TabBarView(controller: _tc, children: [
            _orderList('New', AppColors.accent),
            _orderList('Processing', AppColors.touristBlue),
            _orderList('Completed', AppColors.textLight),
            _emptyState(),
          ])),
        ]),
      ),
    );
  }

  Widget _orderList(String status, Color color) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _orderCard('ORD-001', 'Anna Reyes', 'T\'nalak Bag × 1', '₱1,950', status, color),
        _orderCard('ORD-002', 'Mike Torres', 'Coffee × 2, Honey × 1', '₱2,510', status, color),
      ],
    );
  }

  Widget _orderCard(String id, String name, String items, String total, String status, Color color) {
    return GestureDetector(
      onTap: () {
        final mockOrder = Order(
          id: id,
          customerName: name,
          orderDate: DateTime.now().subtract(const Duration(days: 1)),
          status: status,
          items: [],
          total: 1100,
        );
        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: mockOrder)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(id, style: AppTheme.label(size: 13, color: AppColors.textSecondary)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text(status, style: AppTheme.label(size: 11, color: color))),
          ]),
          const Divider(height: 20),
          Row(children: [
            CircleAvatar(radius: 18, backgroundColor: color.withAlpha(38), child: const Icon(Icons.person, size: 18)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: AppTheme.label(size: 14)),
              Text(items, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            ])),
            Text(total, style: AppTheme.label(size: 14, color: AppColors.primary)),
          ]),
        ]),
      ),
    );
  }

  Widget _emptyState() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.inbox, size: 64, color: AppColors.textLight.withAlpha(76)),
      const SizedBox(height: 16),
      Text('No cancelled orders', style: AppTheme.body(size: 16, color: AppColors.textSecondary)),
    ]));
  }
}


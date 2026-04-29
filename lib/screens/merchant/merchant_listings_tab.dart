import 'package:flutter/material.dart';
import '../../app_theme.dart';

class MerchantListingsTab extends StatelessWidget {
  const MerchantListingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), child: Row(children: [
            Text('My Products', style: AppTheme.headline(size: 24)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('24 active', style: AppTheme.label(size: 12, color: AppColors.primary))),
          ])),
          Expanded(child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _productTile('T\'nalak Woven Bag', '₱1,850', 15, true),
              _productTile('Durian Candy Pack', '₱250', 200, true),
              _productTile('Maranao Brass Tray', '₱3,500', 8, true),
              _productTile('Bukidnon Honey 500ml', '₱450', 45, true),
              _productTile('Coffee Sampler Set', '₱980', 30, true),
              _productTile('Tribal Print Shirt', '₱650', 75, false),
            ],
          )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product', onPressed: () {}, backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _productTile(String name, String price, int stock, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
          child: const Icon(Icons.inventory_2, color: AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 14)),
          Text('$price · Stock: $stock', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        Switch(value: isActive, onChanged: (_) {}, activeThumbColor: AppColors.primary),
      ]),
    );
  }
}

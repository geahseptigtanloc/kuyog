import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../providers/product_provider.dart';
import '../features/marketplace/add_product_screen.dart';

class MerchantListingsTab extends StatelessWidget {
  const MerchantListingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products.where((p) => p.merchantId == 'm_current').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), child: Row(children: [
            Text('My Products', style: AppTheme.headline(size: 24)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('${products.length} active', style: AppTheme.label(size: 12, color: AppColors.primary))),
          ])),
          Expanded(child: productProvider.isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                itemBuilder: (ctx, i) {
                  final p = products[i];
                  return _productTile(p.name, '₱${p.price.toStringAsFixed(0)}', p.stock, true, p.imageUrl);
                },
              )
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen())), backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _productTile(String name, String price, int stock, bool isActive, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.inventory_2, color: AppColors.primary)),
            errorWidget: (context, url, error) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.inventory_2, color: AppColors.primary)),
          ),
        ),
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

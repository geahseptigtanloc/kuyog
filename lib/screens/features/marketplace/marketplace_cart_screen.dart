import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/cart_provider.dart';
import 'checkout_screen.dart';

class MarketplaceCartScreen extends StatelessWidget {
  const MarketplaceCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('My Cart', style: AppTheme.headline(size: 18)),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => cart.clearCart(),
              child: Text('Clear', style: AppTheme.label(size: 14, color: AppColors.error)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textLight.withAlpha(128)),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: AppTheme.headline(size: 20)),
                  const SizedBox(height: 8),
                  Text('Start shopping for local Mindanao products!', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.merchantAmber),
                    child: const Text('Go Shopping'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: CachedNetworkImage(
                          imageUrl: item.product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name, style: AppTheme.label(size: 14)),
                            if (item.selectedVariant != null) ...[
                              const SizedBox(height: 4),
                              Text('Variant: ${item.selectedVariant}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                            ],
                            const SizedBox(height: 8),
                            Text('₱${item.product.price.toStringAsFixed(0)}', style: AppTheme.label(size: 16, color: AppColors.merchantAmber)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.divider), borderRadius: BorderRadius.circular(AppRadius.pill)),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => cart.updateQuantity(index, item.quantity - 1),
                                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Icon(Icons.remove, size: 16)),
                                      ),
                                      Text('${item.quantity}', style: AppTheme.label(size: 14)),
                                      InkWell(
                                        onTap: () => cart.updateQuantity(index, item.quantity + 1),
                                        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Icon(Icons.add, size: 16)),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                  onPressed: () => cart.removeFromCart(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty ? null : Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: AppTheme.body(size: 14)),
                  Text('₱${cart.subtotal.toStringAsFixed(0)}', style: AppTheme.label(size: 16)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceCheckoutScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.merchantAmber, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Proceed to Checkout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


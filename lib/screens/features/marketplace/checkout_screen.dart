import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/miles_provider.dart';

class MarketplaceCheckoutScreen extends StatefulWidget {
  const MarketplaceCheckoutScreen({super.key});

  @override
  State<MarketplaceCheckoutScreen> createState() => _MarketplaceCheckoutScreenState();
}

class _MarketplaceCheckoutScreenState extends State<MarketplaceCheckoutScreen> {
  String _paymentMethod = 'GCash';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final miles = context.watch<MilesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Checkout', style: AppTheme.headline(size: 18)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address
            Text('Delivery Address', style: AppTheme.headline(size: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.merchantAmber.withAlpha(26), shape: BoxShape.circle),
                    child: const Icon(Icons.location_on, color: AppColors.merchantAmber)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Maria Santos', style: AppTheme.label(size: 14)),
                        Text('123 Roxas Ave, Davao City\n8000 Davao del Sur', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textLight),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Summary
            Text('Order Summary', style: AppTheme.headline(size: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
              child: Column(
                children: cart.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text('${item.quantity}x', style: AppTheme.label(size: 13, color: AppColors.merchantAmber)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name, style: AppTheme.label(size: 13)),
                            if (item.selectedVariant != null)
                              Text(item.selectedVariant!, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Text('₱${item.subtotal.toStringAsFixed(0)}', style: AppTheme.label(size: 13)),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method
            Text('Payment Method', style: AppTheme.headline(size: 16)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
              child: Column(
                children: [
                  _paymentOption('GCash', Icons.account_balance_wallet, Colors.blue),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _paymentOption('Maya', Icons.account_balance_wallet, Colors.green),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _paymentOption('Credit/Debit Card', Icons.credit_card, Colors.orange),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _paymentOption('Cash on Delivery', Icons.money, Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Madayaw Points
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.primary.withAlpha(76))),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Use Madayaw Points', style: AppTheme.label(size: 14, color: AppColors.primary)),
                        Text('Balance: ${miles.balance} miles', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Switch(value: cart.useKuyogMiles, onChanged: (_) => cart.toggleKuyogMiles(), activeThumbColor: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
              child: Column(
                children: [
                  _priceRow('Subtotal', '₱${cart.subtotal.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _priceRow('Delivery Fee', '₱${cart.deliveryFee.toStringAsFixed(0)}'),
                  if (cart.discount > 0) ...[
                    const SizedBox(height: 8),
                    _priceRow('Madayaw Points Discount', '-₱${cart.discount.toStringAsFixed(0)}', color: AppColors.primary),
                  ],
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                  _priceRow('Total', '₱${cart.total.toStringAsFixed(0)}', isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                cart.clearCart();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully!'), backgroundColor: AppColors.success));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.merchantAmber, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Place Order'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentOption(String title, IconData icon, Color color) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(title, style: AppTheme.label(size: 14)),
        ],
      ),
      value: title,
      groupValue: _paymentMethod,
      activeColor: AppColors.merchantAmber,
      onChanged: (v) => setState(() => _paymentMethod = v!),
    );
  }

  Widget _priceRow(String label, String amount, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTheme.label(size: 16) : AppTheme.body(size: 14, color: color ?? AppColors.textSecondary)),
        Text(amount, style: isTotal ? AppTheme.headline(size: 20, color: AppColors.merchantAmber) : AppTheme.label(size: 14, color: color ?? AppColors.textPrimary)),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/cart_provider.dart';
import '../../../data/mock_data.dart';
import '../../../models/product.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await MockData.getProducts();
    if (mounted) setState(() { _products = p; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Kuyog Market', style: AppTheme.headline(size: 20)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.merchantAmber))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.merchantAmber, const Color(0xFFF59E0B)]),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mindanao Made', style: AppTheme.body(size: 14, color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('Support Local Artisans', style: AppTheme.headline(size: 24, color: Colors.white)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                                child: Text('Shop Now', style: AppTheme.label(size: 12, color: AppColors.merchantAmber)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.handshake, size: 60, color: Colors.white54),
                      ],
                    ),
                  ),
                  
                  // Categories
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _categoryItem('Crafts', Icons.brush),
                        _categoryItem('Food', Icons.restaurant),
                        _categoryItem('Stays', Icons.home_work),
                        _categoryItem('Tours', Icons.tour),
                        _categoryItem('Apparel', Icons.checkroom),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Products Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trending Now', style: AppTheme.headline(size: 18)),
                        Text('View All', style: AppTheme.label(size: 13, color: AppColors.merchantAmber)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final p = _products[index];
                      return _ProductCard(product: p);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _categoryItem(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.card),
            child: Icon(icon, color: AppColors.merchantAmber, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTheme.label(size: 12)),
        ],
      ),
    );
  }
}

// Inline product card since we deleted the standalone one
class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (product.isFlashDeal)
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: const Text('SALE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTheme.label(size: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(product.merchantName, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('₱${product.price.toStringAsFixed(0)}', style: AppTheme.label(size: 14, color: AppColors.merchantAmber)),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: 4),
                      Text('₱${product.originalPrice!.toStringAsFixed(0)}', style: TextStyle(fontSize: 10, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: AppColors.warning),
                    Text(' ${product.rating}', style: AppTheme.body(size: 11)),
                    Text(' · ${product.soldCount} sold', style: AppTheme.body(size: 11, color: AppColors.textLight)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

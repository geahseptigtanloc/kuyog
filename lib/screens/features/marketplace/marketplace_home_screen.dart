import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/cart_provider.dart';
import '../../../data/mock_data.dart';
import '../../../models/product.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../../../widgets/core/kuyog_card.dart';
import '../../../widgets/core/kuyog_badge.dart';
import '../../../widgets/core/kuyog_section_header.dart';
import '../../../widgets/core/kuyog_button.dart';

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
    if (mounted) {
      setState(() {
        _products = p;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(
        title: 'Kuyog Market',
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary),
              onPressed: () {}),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: AppColors.primary),
                  onPressed: () {}),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: AppColors.error, shape: BoxShape.circle),
                    child: Text('${cart.itemCount}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.merchantAmber))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: KuyogCard(
                      color: AppColors.accent,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mindanao Made',
                                    style: AppTheme.body(
                                        size: 14, color: Colors.white70)),
                                const SizedBox(height: AppSpacing.xs),
                                Text('Support Local Artisans',
                                    style: AppTheme.headline(
                                        size: 24, color: Colors.white)),
                                const SizedBox(height: AppSpacing.lg),
                                KuyogButton(
                                  label: 'Shop Now',
                                  variant: KuyogButtonVariant.secondary,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.handshake,
                              size: 64, color: Colors.white24),
                        ],
                      ),
                    ),
                  ),

                  // Categories
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      children: [
                        _categoryItem('Crafts', Icons.brush),
                        _categoryItem('Food', Icons.restaurant),
                        _categoryItem('Stays', Icons.home_work),
                        _categoryItem('Tours', Icons.tour),
                        _categoryItem('Apparel', Icons.checkroom),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Products Grid
                  KuyogSectionHeader(
                    title: 'Trending Now',
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    trailing: GestureDetector(
                      onTap: () {},
                      child: Text('View All',
                          style: AppTheme.label(size: 13, color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
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
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: Column(
        children: [
          KuyogCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            shape: BoxShape.circle,
            child: Icon(icon, color: AppColors.merchantAmber, size: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTheme.label(size: 12)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return KuyogCard(
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppColors.divider),
                ),
              ),
              if (product.isFlashDeal)
                const Positioned(
                  top: 8,
                  left: 8,
                  child: KuyogBadge(
                    label: 'SALE',
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: AppTheme.label(size: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(product.merchantName,
                    style: AppTheme.body(size: 11, color: AppColors.textLight)),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text('₱${product.price.toStringAsFixed(0)}',
                        style: AppTheme.label(
                            size: 14, color: AppColors.merchantAmber)),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text('₱${product.originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textLight,
                              decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: AppColors.warning),
                    Text(' ${product.rating}', style: AppTheme.body(size: 11)),
                    const Spacer(),
                    Text('${product.soldCount} sold',
                        style: AppTheme.body(
                            size: 10, color: AppColors.textLight)),
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

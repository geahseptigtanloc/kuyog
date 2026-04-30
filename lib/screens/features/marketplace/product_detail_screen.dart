import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/product.dart';
import '../../../providers/cart_provider.dart';
import 'marketplace_cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  String? _selectedVariant;

  @override
  void initState() {
    super.initState();
    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.merchantAmber,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: widget.product.images.isNotEmpty ? widget.product.images.length : 1,
                    itemBuilder: (c, i) => CachedNetworkImage(
                      imageUrl: widget.product.images.isNotEmpty ? widget.product.images[i] : widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text('1/${widget.product.images.isEmpty ? 1 : widget.product.images.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceCartScreen())),
                  ),
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
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.name, style: AppTheme.headline(size: 22)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('₱${widget.product.price.toStringAsFixed(0)}', style: AppTheme.headline(size: 24, color: AppColors.merchantAmber)),
                                if (widget.product.originalPrice != null) ...[
                                  const SizedBox(width: 8),
                                  Text('₱${widget.product.originalPrice!.toStringAsFixed(0)}', style: TextStyle(color: AppColors.textLight, fontSize: 14, decoration: TextDecoration.lineThrough)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                    child: Text('-${(((widget.product.originalPrice! - widget.product.price) / widget.product.originalPrice!) * 100).toInt()}%', style: AppTheme.label(size: 11, color: AppColors.error)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.favorite_border, color: AppColors.textSecondary), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text('${widget.product.rating}', style: AppTheme.label(size: 14)),
                      const SizedBox(width: 16),
                      Text('${widget.product.soldCount} Sold', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Merchant info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 24, backgroundColor: AppColors.merchantAmber.withOpacity(0.1), child: const Icon(Icons.store, color: AppColors.merchantAmber)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(widget.product.merchantName, style: AppTheme.label(size: 14)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 14, color: AppColors.verified),
                                ],
                              ),
                              Text('Official Kuyog Merchant', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.merchantAmber, side: const BorderSide(color: AppColors.merchantAmber)),
                          child: const Text('View Store'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Variants
                  if (widget.product.variants.isNotEmpty) ...[
                    Text('Select Variant', style: AppTheme.headline(size: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: widget.product.variants.map((v) => GestureDetector(
                        onTap: () => setState(() => _selectedVariant = v),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedVariant == v ? AppColors.merchantAmber.withOpacity(0.1) : Colors.white,
                            border: Border.all(color: _selectedVariant == v ? AppColors.merchantAmber : AppColors.divider),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(v, style: AppTheme.label(size: 14, color: _selectedVariant == v ? AppColors.merchantAmber : AppColors.textPrimary)),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text('Description', style: AppTheme.headline(size: 16)),
                  const SizedBox(height: 12),
                  Text(widget.product.description, style: AppTheme.body(size: 14)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: AppColors.divider), borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.remove), onPressed: () { if (_quantity > 1) setState(() => _quantity--); }),
                    Text('$_quantity', style: AppTheme.label(size: 16)),
                    IconButton(icon: const Icon(Icons.add), onPressed: () { if (_quantity < widget.product.stock) setState(() => _quantity++); }),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    cart.addToCart(widget.product, variant: _selectedVariant);
                    for (int i = 1; i < _quantity; i++) {
                      cart.addToCart(widget.product, variant: _selectedVariant);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart'), backgroundColor: AppColors.success));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.merchantAmber, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

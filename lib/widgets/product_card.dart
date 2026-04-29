import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_theme.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({super.key, required this.product, this.onTap, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(height: 140, color: AppColors.divider),
                    errorWidget: (c, u, e) => Container(
                      height: 140,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.image, color: AppColors.primary),
                    ),
                  ),
                ),
                if (product.isFlashDeal)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text('SALE', style: AppTheme.label(size: 10, color: Colors.white)),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTheme.label(size: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.merchantName,
                    style: AppTheme.body(size: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₱${product.price.toStringAsFixed(0)}',
                        style: AppTheme.label(size: 15, color: AppColors.primary, weight: FontWeight.w800),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          '₱${product.originalPrice!.toStringAsFixed(0)}',
                          style: AppTheme.body(size: 11, color: AppColors.textLight).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text('${product.rating}', style: AppTheme.body(size: 11)),
                      const SizedBox(width: 4),
                      Text('${product.soldCount} sold', style: AppTheme.body(size: 11, color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

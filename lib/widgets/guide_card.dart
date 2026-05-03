import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_theme.dart';
import '../models/guide.dart';
import 'verified_badge.dart';

class GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback? onTap;

  const GuideCard({super.key, required this.guide, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: CachedNetworkImage(
                imageUrl: guide.bannerUrl,
                height: 210,
                width: 160,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(height: 210, width: 160, color: AppColors.divider),
                errorWidget: (c, u, e) => Container(
                  height: 210,
                  width: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(Icons.person, color: Colors.white54, size: 40),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
            if (guide.isVerified)
              const Positioned(
                top: 8,
                right: 8,
                child: VerifiedBadge(size: 18),
              ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.name,
                    style: AppTheme.label(size: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    guide.city,
                    style: AppTheme.body(size: 11, color: Colors.white70),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: guide.specialties.take(1).map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(s, style: AppTheme.body(size: 9, color: Colors.white)),
                    )).toList(),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text('${guide.rating}', style: AppTheme.label(size: 11, color: Colors.white)),
                      const SizedBox(width: 4),
                      Expanded(child: Text('${guide.tripCount} trips', style: AppTheme.body(size: 10, color: Colors.white60), maxLines: 1, overflow: TextOverflow.ellipsis)),
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

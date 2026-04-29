import 'package:flutter/material.dart';
import '../app_theme.dart';

class VerifiedBadge extends StatelessWidget {
  final double size;
  final bool showText;

  const VerifiedBadge({super.key, this.size = 16, this.showText = false});

  @override
  Widget build(BuildContext context) {
    if (showText) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.verified.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, color: AppColors.verified, size: size),
            const SizedBox(width: 4),
            Text(
              'Verified Kuyog Guide',
              style: AppTheme.label(size: 12, color: AppColors.verified),
            ),
          ],
        ),
      );
    }
    return Icon(Icons.verified, color: AppColors.verified, size: size);
  }
}

import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'kuyog_logo.dart';

/// Reusable Durie loading widget — now centered green logo
class DurieLoading extends StatelessWidget {
  final String message;
  final double mascotSize;
  const DurieLoading({super.key, this.message = 'Loading...', this.mascotSize = 60});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: KuyogLogo(
        fontSize: 50,
        type: KuyogLogoType.green,
      ),
    );
  }
}

/// Durie empty state widget
class DurieEmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  const DurieEmptyState({super.key, required this.message, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const KuyogLogo(
              fontSize: 60,
              type: KuyogLogoType.green,
            ),
            const SizedBox(height: 16),
            Text(message, style: AppTheme.headline(size: 18), textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: AppTheme.body(size: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

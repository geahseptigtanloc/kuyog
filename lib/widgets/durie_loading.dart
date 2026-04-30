import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'durie_mascot.dart';

/// Reusable Durie loading widget — small mascot + spinner + text
class DurieLoading extends StatelessWidget {
  final String message;
  final double mascotSize;
  const DurieLoading({super.key, this.message = 'Loading...', this.mascotSize = 60});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DurieMascot(size: mascotSize),
          const SizedBox(height: 16),
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTheme.body(size: 14, color: AppColors.textSecondary),
          ),
        ],
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
            const DurieMascot(size: 80),
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

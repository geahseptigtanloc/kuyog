import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../app_theme.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class CardSkeletonLoader extends StatelessWidget {
  const CardSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(height: 160, borderRadius: 12),
          SizedBox(height: 12),
          SkeletonLoader(height: 20, width: 200),
          SizedBox(height: 8),
          SkeletonLoader(height: 14, width: 140),
          SizedBox(height: 8),
          SkeletonLoader(height: 14, width: 100),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import '../app_theme.dart';

/// Consistent frosted-glass back button used across all detail screens
class KuyogBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const KuyogBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          size: 22,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Consistent frosted-glass back button used across all detail screens
class KuyogBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final double iconSize;

  const KuyogBackButton({
    super.key, 
    this.onTap,
    this.size = 44,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.maybePop(context),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.chevron_left_rounded,
            size: iconSize,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

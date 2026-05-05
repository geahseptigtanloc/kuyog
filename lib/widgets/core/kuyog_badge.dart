import 'package:flutter/material.dart';
import '../../app_theme.dart';

class KuyogBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final bool isOutline;
  final Color? iconColor;
  final Color? labelColor;
  final EdgeInsetsGeometry? padding;

  const KuyogBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.isOutline = false,
    this.iconColor,
    this.labelColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : effectiveColor.withAlpha(31),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: isOutline ? Border.all(color: effectiveColor, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: iconColor ?? effectiveColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTheme.label(
              size: 11,
              color: labelColor ?? effectiveColor,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Reusable badge widget for status indicators and labels.
class KuyogBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  const KuyogBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: backgroundColor.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTheme.label(size: fontSize, color: textColor, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Status badge variants.
class KuyogStatusBadge extends StatelessWidget {
  final String status;

  const KuyogStatusBadge({super.key, required this.status});

  Map<String, (Color, Color, IconData?)> _getStatusStyle() {
    return {
      'pending': (AppColors.warning, AppColors.warning, Icons.schedule),
      'confirmed': (AppColors.touristBlue, AppColors.touristBlue, Icons.check_circle),
      'active': (AppColors.success, AppColors.success, Icons.play_circle),
      'completed': (AppColors.primary, AppColors.primary, Icons.done),
      'cancelled': (AppColors.error, AppColors.error, Icons.cancel),
    };
  }

  @override
  Widget build(BuildContext context) {
    final styles = _getStatusStyle();
    final (bgColor, textColor, icon) = styles[status.toLowerCase()] ??
        (AppColors.textLight, AppColors.textLight, null);

    return KuyogBadge(
      label: status.toUpperCase(),
      backgroundColor: bgColor,
      textColor: textColor,
      icon: icon,
      fontSize: 11,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}

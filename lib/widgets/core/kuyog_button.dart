import 'package:flutter/material.dart';
import '../../app_theme.dart';

enum KuyogButtonVariant { primary, secondary, destructive, outline }

class KuyogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final KuyogButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  const KuyogButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = KuyogButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.padding,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case KuyogButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = Colors.white;
        break;
      case KuyogButtonVariant.secondary:
        bgColor = AppColors.accent;
        fgColor = Colors.white;
        break;
      case KuyogButtonVariant.destructive:
        bgColor = AppColors.error;
        fgColor = Colors.white;
        break;
      case KuyogButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.primary;
        border = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
    }

    final bool isDisabled = onPressed == null && !isLoading;

    final content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTheme.label(
                  color: fgColor,
                  weight: FontWeight.w700,
                  size: 15,
                ),
              ),
            ],
          );

    final effectivePadding = padding ??
        const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 14);

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: 48,
      child: variant == KuyogButtonVariant.outline
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: fgColor,
                side: isDisabled
                    ? BorderSide(color: AppColors.divider, width: border.width)
                    : border,
                padding: effectivePadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: content,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? bgColor.withAlpha(100) : bgColor,
                foregroundColor: fgColor,
                disabledBackgroundColor: bgColor.withAlpha(100),
                disabledForegroundColor: fgColor.withAlpha(150),
                elevation: 0,
                padding: effectivePadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: content,
            ),
    );
  }
}

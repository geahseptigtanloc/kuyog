import 'package:flutter/material.dart';
import '../../app_theme.dart';

class KuyogCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final List<BoxShadow>? shadow;
  final Color? color;
  final Border? border;
  final BorderSide? borderSide;
  final BoxShape? shape;
  final VoidCallback? onTap;

  const KuyogCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.shadow,
    this.color,
    this.border,
    this.borderSide,
    this.shape,
    this.onTap,
  });

  @override
  State<KuyogCard> createState() => _KuyogCardState();
}

class _KuyogCardState extends State<KuyogCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = widget.border ?? (widget.borderSide != null ? Border.fromBorderSide(widget.borderSide!) : null);
    final effectiveShape = widget.shape ?? BoxShape.rectangle;

    final card = ClipRRect(
      borderRadius: effectiveShape == BoxShape.circle
          ? BorderRadius.zero
          : BorderRadius.circular(widget.radius ?? AppRadius.lg),
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.surface,
          borderRadius: effectiveShape == BoxShape.circle ? null : BorderRadius.circular(widget.radius ?? AppRadius.lg),
          boxShadow: widget.shadow ?? [
            BoxShadow(
              color: Colors.black.withAlpha(14),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
          border: effectiveBorder,
          shape: effectiveShape,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) => _scaleController.reverse(),
          onTapCancel: () => _scaleController.reverse(),
          onTap: widget.onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}

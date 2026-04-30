import 'dart:math';
import 'package:flutter/material.dart';
import '../app_theme.dart';

class MindanaoMap extends StatelessWidget {
  final List<MapPin> pins;
  final double height;

  const MindanaoMap({
    super.key,
    this.pins = const [],
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: CustomPaint(
          painter: _MindanaoMapPainter(pins: pins),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class MapPin {
  final String label;
  final double x; // 0-1 relative position
  final double y; // 0-1 relative position
  final Color color;

  const MapPin({
    required this.label,
    required this.x,
    required this.y,
    this.color = AppColors.accent,
  });
}

class _MindanaoMapPainter extends CustomPainter {
  final List<MapPin> pins;

  _MindanaoMapPainter({this.pins = const []});

  @override
  void paint(Canvas canvas, Size size) {
    // Water background
    final waterPaint = Paint()..color = const Color(0xFFBBDEFB).withOpacity(0.3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), waterPaint);

    // Simplified Mindanao island outline
    final landPaint = Paint()
      ..color = const Color(0xFF81C784).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final landOutlinePaint = Paint()
      ..color = const Color(0xFF4A7C3F).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final sx = size.width * 0.4;
    final sy = size.height * 0.35;

    final path = Path();
    // Simplified Mindanao shape
    path.moveTo(cx - sx * 0.3, cy - sy * 0.8);
    path.cubicTo(cx - sx * 0.1, cy - sy, cx + sx * 0.2, cy - sy * 0.9, cx + sx * 0.5, cy - sy * 0.6);
    path.cubicTo(cx + sx * 0.8, cy - sy * 0.3, cx + sx * 0.9, cy - sy * 0.1, cx + sx * 0.7, cy + sy * 0.1);
    path.cubicTo(cx + sx * 0.9, cy + sy * 0.3, cx + sx * 0.6, cy + sy * 0.5, cx + sx * 0.4, cy + sy * 0.7);
    path.cubicTo(cx + sx * 0.3, cy + sy * 0.9, cx + sx * 0.1, cy + sy, cx - sx * 0.1, cy + sy * 0.8);
    path.cubicTo(cx - sx * 0.4, cy + sy * 0.9, cx - sx * 0.6, cy + sy * 0.6, cx - sx * 0.7, cy + sy * 0.3);
    path.cubicTo(cx - sx * 0.9, cy + sy * 0.1, cx - sx * 0.8, cy - sy * 0.2, cx - sx * 0.6, cy - sy * 0.4);
    path.cubicTo(cx - sx * 0.5, cy - sy * 0.6, cx - sx * 0.4, cy - sy * 0.7, cx - sx * 0.3, cy - sy * 0.8);
    path.close();

    canvas.drawPath(path, landPaint);
    canvas.drawPath(path, landOutlinePaint);

    // Draw dotted route between pins
    if (pins.length > 1) {
      final routePaint = Paint()
        ..color = AppColors.primary.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      for (int i = 0; i < pins.length - 1; i++) {
        final from = Offset(pins[i].x * size.width, pins[i].y * size.height);
        final to = Offset(pins[i + 1].x * size.width, pins[i + 1].y * size.height);
        _drawDottedLine(canvas, from, to, routePaint);
      }
    }

    // Draw pins
    for (final pin in pins) {
      final px = pin.x * size.width;
      final py = pin.y * size.height;

      // Pin shadow
      canvas.drawCircle(
        Offset(px, py + 2),
        8,
        Paint()..color = Colors.black.withOpacity(0.15),
      );

      // Pin circle
      canvas.drawCircle(
        Offset(px, py),
        7,
        Paint()..color = pin.color,
      );
      canvas.drawCircle(
        Offset(px, py),
        4,
        Paint()..color = Colors.white,
      );

      // Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: pin.label,
          style: const TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: 100);

      // Label background
      final labelRect = Rect.fromLTWH(
        px - textPainter.width / 2 - 4,
        py - 20,
        textPainter.width + 8,
        14,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(3)),
        Paint()..color = Colors.white.withOpacity(0.9),
      );

      textPainter.paint(canvas, Offset(px - textPainter.width / 2, py - 19));
    }
  }

  void _drawDottedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final dashLength = 6.0;
    final gapLength = 4.0;
    final steps = (distance / (dashLength + gapLength)).floor();

    for (int i = 0; i < steps; i++) {
      final startFraction = i * (dashLength + gapLength) / distance;
      final endFraction = (i * (dashLength + gapLength) + dashLength) / distance;
      canvas.drawLine(
        Offset(from.dx + dx * startFraction, from.dy + dy * startFraction),
        Offset(from.dx + dx * endFraction, from.dy + dy * endFraction),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

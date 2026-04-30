import 'package:flutter/material.dart';
import '../app_theme.dart';

class MindanaoMap extends StatelessWidget {
  const MindanaoMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5E8),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: CustomPaint(
        painter: _MindanaoMapPainter(),
        child: Stack(children: [
          _pin(left: 0.3, top: 0.3, label: 'CDO', color: AppColors.accent),
          _pin(left: 0.5, top: 0.2, label: 'Davao', color: AppColors.primary),
          _pin(left: 0.7, top: 0.35, label: 'Siargao', color: const Color(0xFF0891B2)),
          _pin(left: 0.25, top: 0.55, label: 'Cotabato', color: AppColors.warning),
          _pin(left: 0.45, top: 0.65, label: 'GenSan', color: AppColors.error),
          _pin(left: 0.15, top: 0.4, label: 'Lake Sebu', color: AppColors.primaryDark),
          Positioned(top: 8, left: 12, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Text('Mindanao Travel Map', style: AppTheme.label(size: 11, color: AppColors.primary)),
          )),
        ]),
      ),
    );
  }

  Widget _pin({required double left, required double top, required String label, required Color color}) {
    return Positioned(
      left: left * 300,
      top: top * 200,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(AppRadius.sm)),
          child: Text(label, style: AppTheme.label(size: 9, color: color)),
        ),
        Icon(Icons.location_on, size: 20, color: color),
      ]),
    );
  }
}

class _MindanaoMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.15, size.width * 0.3, size.height * 0.12)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.08, size.width * 0.6, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width * 0.85, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width * 0.75, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.6, size.width * 0.6, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.85, size.width * 0.4, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.75, size.width * 0.2, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.5, size.width * 0.15, size.height * 0.3)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class DurieMascot extends StatelessWidget {
  final double size;

  const DurieMascot({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _DuriePainter()),
    );
  }
}

class _DuriePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    // Spikes
    final spikePaint = Paint()..color = const Color(0xFF3D6B34);
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * 3.14159 / 180;
      final spikeLength = radius * 0.35;
      final spikeBase = radius * 0.85;
      final baseX = center.dx + spikeBase * _cos(angle);
      final baseY = center.dy + spikeBase * _sin(angle);
      final tipX = center.dx + (spikeBase + spikeLength) * _cos(angle);
      final tipY = center.dy + (spikeBase + spikeLength) * _sin(angle);
      final perpAngle = angle + 3.14159 / 2;
      final halfWidth = radius * 0.15;
      final path = Path()
        ..moveTo(
          baseX + halfWidth * _cos(perpAngle),
          baseY + halfWidth * _sin(perpAngle),
        )
        ..lineTo(tipX, tipY)
        ..lineTo(
          baseX - halfWidth * _cos(perpAngle),
          baseY - halfWidth * _sin(perpAngle),
        )
        ..close();
      canvas.drawPath(path, spikePaint);
    }

    // Body
    final bodyPaint = Paint()..color = const Color(0xFF5A9E4B);
    canvas.drawCircle(center, radius, bodyPaint);

    // Belly
    final bellyPaint = Paint()..color = const Color(0xFFFFD93D);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.15),
        width: radius * 1.0,
        height: radius * 0.9,
      ),
      bellyPaint,
    );

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF2D2D2D);
    final eyeWhitePaint = Paint()..color = Colors.white;
    final leftEye = Offset(center.dx - radius * 0.25, center.dy - radius * 0.15);
    final rightEye = Offset(center.dx + radius * 0.25, center.dy - radius * 0.15);
    canvas.drawCircle(leftEye, radius * 0.13, eyeWhitePaint);
    canvas.drawCircle(rightEye, radius * 0.13, eyeWhitePaint);
    canvas.drawCircle(leftEye, radius * 0.08, eyePaint);
    canvas.drawCircle(rightEye, radius * 0.08, eyePaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(leftEye.dx + radius * 0.03, leftEye.dy - radius * 0.03),
      radius * 0.03,
      shinePaint,
    );
    canvas.drawCircle(
      Offset(rightEye.dx + radius * 0.03, rightEye.dy - radius * 0.03),
      radius * 0.03,
      shinePaint,
    );

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF2D2D2D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(center.dx - radius * 0.2, center.dy + radius * 0.15)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.4,
        center.dx + radius * 0.2,
        center.dy + radius * 0.15,
      );
    canvas.drawPath(smilePath, smilePaint);

    // Cheeks (blush)
    final blushPaint = Paint()
      ..color = const Color(0xFFFF9A9A).withOpacity(0.4);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, center.dy + radius * 0.1),
      radius * 0.1,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy + radius * 0.1),
      radius * 0.1,
      blushPaint,
    );
  }

  double _cos(double angle) => _cosSin(angle, true);
  double _sin(double angle) => _cosSin(angle, false);

  double _cosSin(double angle, bool isCos) {
    // Using dart:math indirectly via manual calculation
    // Simple approach: just import math
    if (isCos) {
      return _cosApprox(angle);
    }
    return _cosApprox(angle - 3.14159 / 2) * -1;
  }

  double _cosApprox(double x) {
    // Normalize to [-pi, pi]
    while (x > 3.14159) { x -= 2 * 3.14159; }
    while (x < -3.14159) { x += 2 * 3.14159; }
    // Taylor series approximation
    double x2 = x * x;
    return 1 - x2 / 2 + x2 * x2 / 24 - x2 * x2 * x2 / 720;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

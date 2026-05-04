import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app_theme.dart';

class DuriePassport extends StatelessWidget {
  final String touristName;
  final String passportNumber;
  final int stampsCount;
  final int totalStamps;

  const DuriePassport({
    super.key,
    required this.touristName,
    required this.passportNumber,
    required this.stampsCount,
    required this.totalStamps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF2A5C32),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          // Weaving Pattern Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: WeavingPatternPainter(),
            ),
          ),
          
          // Passport Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('KUYOG TRAVEL PASSPORT', 
                      style: AppTheme.label(size: 11, color: Colors.white.withOpacity(0.9), weight: FontWeight.w600).copyWith(letterSpacing: 1.2)),
                    const Icon(Icons.travel_explore, color: Colors.white, size: 24),
                  ],
                ),
                const Spacer(),
                Text(touristName.toUpperCase(), style: AppTheme.headline(size: 20, color: Colors.white)),
                Text('Mindanao Explorer', style: AppTheme.body(size: 13, color: Colors.white.withOpacity(0.7))),
                const SizedBox(height: 12),
                Text('KYG-$passportNumber', style: AppTheme.body(size: 11, color: Colors.white.withOpacity(0.6))),
                const SizedBox(height: 20),
                
                // Stamp slots
                Row(
                  children: List.generate(8, (index) {
                    final isCollected = index < stampsCount;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCollected ? Colors.white : Colors.white.withOpacity(0.2),
                        border: isCollected ? null : Border.all(color: Colors.white.withOpacity(0.3), style: BorderStyle.solid),
                      ),
                      child: isCollected 
                        ? const Icon(Icons.stars, color: Color(0xFF2A5C32), size: 20)
                        : const Icon(Icons.help_outline, color: Colors.white24, size: 16),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeavingPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double spacing = 20.0;
    
    // Diagonal lines
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
    
    // Opposite diagonal
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

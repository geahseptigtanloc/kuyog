import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class FindingDurieCelebration extends StatelessWidget {
  const FindingDurieCelebration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: ConfettiPainter(),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Durie Mascot Animation Placeholder
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: const Icon(Icons.face, size: 120, color: Colors.white),
                ),
                const SizedBox(height: 40),
                Text('You Found Durie!', style: AppTheme.headline(size: 28, color: Colors.white)),
                const SizedBox(height: 12),
                Text('You earned 300 Bonus Miles + a Season Exclusive Durie Pin!', 
                  textAlign: TextAlign.center,
                  style: AppTheme.body(size: 16, color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Continue Crawling', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Share This Moment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // I'll use a deterministic random-like approach for the painter.
    final colors = [Colors.red, Colors.blue, Colors.yellow, Colors.green, Colors.pink, Colors.orange];
    
    for (int i = 0; i < 100; i++) {
      final paint = Paint()..color = colors[i % colors.length].withOpacity(0.6);
      final x = (i * 137.5) % size.width;
      final y = (i * 221.7) % size.height;
      final radius = (i % 5) + 2.0;
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      // Draw some squares too
      if (i % 3 == 0) {
        canvas.drawRect(Rect.fromLTWH(x + 10, y + 10, radius * 2, radius * 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

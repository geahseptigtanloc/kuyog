import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class DuriePassport extends StatefulWidget {
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
  State<DuriePassport> createState() => _DuriePassportState();
}

class _DuriePassportState extends State<DuriePassport> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withBlue(60), // Subtle shift
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WeavingPatternPainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('KUYOG TRAVEL PASSPORT',
                        style: AppTheme.label(
                                size: 10,
                                color: Colors.white.withAlpha(153),
                                weight: FontWeight.w800)
                            .copyWith(letterSpacing: 1.5)),
                    const Icon(Icons.travel_explore,
                        color: Colors.white, size: 22),
                  ],
                ),
                const SizedBox(height: 24),
                Text(widget.touristName,
                    style: AppTheme.headline(size: 26, color: Colors.white, height: 1.1)),
                const SizedBox(height: 6),
                Text('Mindanao Explorer',
                    style: AppTheme.body(
                        size: 14, color: Colors.white.withAlpha(230))),
                const SizedBox(height: 4),
                Text('KYG-${widget.passportNumber}',
                    style: AppTheme.body(
                        size: 11, color: Colors.white.withAlpha(128))),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: false,
                    thickness: 0,
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.totalStamps,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final isCollected = index < widget.stampsCount;
                        return _PassportStampSlot(isCollected: isCollected);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: widget.stampsCount / widget.totalStamps,
                          backgroundColor: Colors.white.withAlpha(38),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${widget.stampsCount}/${widget.totalStamps} Stamps',
                      style: AppTheme.label(
                          size: 11,
                          weight: FontWeight.w700,
                          color: Colors.white.withAlpha(230)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PassportStampSlot extends StatelessWidget {
  final bool isCollected;

  const _PassportStampSlot({required this.isCollected});

  @override
  Widget build(BuildContext context) {
    if (isCollected) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withAlpha(89),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.place, color: AppColors.primary, size: 18),
      );
    }

    return CustomPaint(
      painter: _DashedCirclePainter(color: Colors.white.withAlpha(102)),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Center(
          child: Icon(Icons.help_outline,
              size: 16, color: Colors.white.withAlpha(76)),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    final radius = (size.width - paint.strokeWidth) / 2;
    final circumference = 2 * 3.141592653589793 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final dashAngle = 2 * 3.141592653589793 / dashCount;

    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        dashAngle * (dashWidth / (dashWidth + dashSpace)),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WeavingPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(13)
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


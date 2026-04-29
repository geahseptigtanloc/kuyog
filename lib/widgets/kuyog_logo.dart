import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

class KuyogLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final bool showTagline;

  const KuyogLogo({
    super.key,
    this.fontSize = 36,
    this.color,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'KUYOG',
          style: GoogleFonts.baloo2(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: color ?? AppColors.primary,
            letterSpacing: 2,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'Kuyog ta!',
            style: GoogleFonts.nunito(
              fontSize: fontSize * 0.35,
              fontWeight: FontWeight.w600,
              color: (color ?? AppColors.primary).withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

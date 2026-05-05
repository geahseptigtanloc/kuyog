import 'package:flutter/material.dart';

enum KuyogLogoType { white, green }

class KuyogLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final bool showTagline;
  final KuyogLogoType type;

  const KuyogLogo({
    super.key,
    this.fontSize = 36,
    this.color,
    this.showTagline = false,
    this.type = KuyogLogoType.white,
  });

  @override
  Widget build(BuildContext context) {
    final asset = type == KuyogLogoType.green 
        ? 'assets/images/kuyog_logo_green.png' 
        : 'assets/images/kuyog_logo_white.png';

    return Image.asset(
      asset,
      height: fontSize * 1.8,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
    );
  }
}

import 'package:flutter/material.dart';

/// Durie mascot widget using the actual mascot asset image
class DurieMascot extends StatelessWidget {
  final double size;

  const DurieMascot({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/durie_mascot.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a simple icon if asset not found
          return Icon(
            Icons.eco,
            size: size * 0.6,
            color: const Color(0xFF5A9E4B),
          );
        },
      ),
    );
  }
}

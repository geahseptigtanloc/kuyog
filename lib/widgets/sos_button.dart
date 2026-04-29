import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../screens/features/help/sos_helpdesk_screen.dart';

class SosButton extends StatelessWidget {
  const SosButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'sos_button',
      backgroundColor: AppColors.error,
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SosHelpdeskScreen())),
      child: const Icon(Icons.sos, size: 20, color: Colors.white),
    );
  }
}


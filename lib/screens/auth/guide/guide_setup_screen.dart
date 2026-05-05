import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';

class GuideSetupScreen extends StatelessWidget {
  final VoidCallback onNext;

  const GuideSetupScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(Icons.person_pin_rounded, size: 80, color: AppColors.primary.withAlpha(178)),
              const SizedBox(height: 24),
              Text(
                'Set up your account!',
                style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'Complete your profile to start connecting with tourists and sharing your expertise about Mindanao.',
                style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Confirm'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onNext,
                child: Text('Maybe later', style: GoogleFonts.nunito(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


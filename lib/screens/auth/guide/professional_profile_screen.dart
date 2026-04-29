import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';

class ProfessionalProfileScreen extends StatelessWidget {
  final VoidCallback onNext;

  const ProfessionalProfileScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Professional Profile', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Summary', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Tell tourists about yourself...',
                hintStyle: GoogleFonts.nunito(color: AppColors.textLight),
                counterStyle: GoogleFonts.nunito(fontSize: 11, color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 16),
            Text('Work Experience', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'e.g., 5 years in tourism')),
            const SizedBox(height: 16),
            Text('Location', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Your city or region',
                suffixIcon: Icon(Icons.gps_fixed, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

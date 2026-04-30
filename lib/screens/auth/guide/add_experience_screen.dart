import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';

class AddExperienceScreen extends StatelessWidget {
  final VoidCallback onNext;

  const AddExperienceScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final languages = ['English', 'Español', '日本語', 'Persian', 'Suahil', 'Français', 'Deutsch', '正體語', 'Cebuano/Bisaya'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Add Experience', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline, color: AppColors.primary), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field('Job Position', 'e.g., Tour Guide'),
            _field('Company Name', 'e.g., Mindanao Tours Inc.'),
            _field('Company Address', 'e.g., Davao City'),
            Row(
              children: [
                Expanded(child: _field('Start Date', 'MM/YYYY')),
                const SizedBox(width: 12),
                Expanded(child: _field('End Date', 'MM/YYYY')),
              ],
            ),
            const SizedBox(height: 24),
            Text('Add Language', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'Search language', prefixIcon: Icon(Icons.search, color: AppColors.textLight))),
            const SizedBox(height: 12),
            Text('Popular', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: languages.map((lang) => GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: lang == 'English' ? AppColors.primary.withOpacity(0.12) : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: lang == 'English' ? AppColors.primary : AppColors.divider),
                  ),
                  child: Text(
                    lang,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: lang == 'English' ? FontWeight.w700 : FontWeight.w500,
                      color: lang == 'English' ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {},
              child: Text('More →', style: GoogleFonts.nunito(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.maybePop(context), child: const Text('Back'))),
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

  Widget _field(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          TextField(decoration: InputDecoration(hintText: hint)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';

class CvUploadScreen extends StatefulWidget {
  final VoidCallback onNext;

  const CvUploadScreen({super.key, required this.onNext});

  @override
  State<CvUploadScreen> createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends State<CvUploadScreen> {
  bool _agreed = false;
  final List<TextEditingController> _portfolioControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Upload CV', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your CV to get analyzed and receive job offers.',
              style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            // CV Upload area
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, style: BorderStyle.solid, width: 1.5),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: AppColors.primary.withValues(alpha: 0.04),
                ),
                child: Column(
                  children: [
                    Icon(Icons.upload_file, size: 48, color: AppColors.primary.withValues(alpha: 0.6)),
                    const SizedBox(height: 8),
                    Text('Tap to upload PDF', style: GoogleFonts.nunito(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    Text('Max 5MB', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textLight)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Portfolio URLs (optional)', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._portfolioControllers.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  hintText: 'https://your-portfolio.com',
                  prefixIcon: const Icon(Icons.link, color: AppColors.textLight, size: 20),
                ),
              ),
            )),
            TextButton.icon(
              onPressed: () => setState(() => _portfolioControllers.add(TextEditingController())),
              icon: const Icon(Icons.add, size: 18),
              label: Text('Add more', style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'I agree to the terms and conditions for submitting my CV and portfolio.',
                      style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
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

  VoidCallback get onNext => widget.onNext;
}

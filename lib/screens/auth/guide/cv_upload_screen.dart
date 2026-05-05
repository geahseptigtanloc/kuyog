import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../data/services/onboarding_service.dart';
import '../../../providers/role_provider.dart';

class CvUploadScreen extends StatefulWidget {
  final VoidCallback onNext;

  const CvUploadScreen({super.key, required this.onNext});

  @override
  State<CvUploadScreen> createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends State<CvUploadScreen> {
  bool _agreed = false;
  bool _isLoading = false;
  PlatformFile? _pickedFile;
  final List<TextEditingController> _portfolioControllers = [TextEditingController()];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      withData: true,
    );

    if (result != null) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  Future<void> _handleNext() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms')),
      );
      return;
    }

    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your CV')),
      );
      return;
    }

    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final onboarding = OnboardingService();
      
      // Upload CV
      final cvUrl = await onboarding.uploadVerificationFile(
        userId: user.id,
        fileName: 'cv_${_pickedFile!.name}',
        fileBytes: _pickedFile!.bytes ?? [], // For web
      );

      // Save to verification table
      await onboarding.submitGuideVerification(
        userId: user.id,
        cvUrl: cvUrl,
        portfolioUrls: _portfolioControllers
            .map((controller) => controller.text.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
      );
      
      widget.onNext();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading CV: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              onTap: _isLoading ? null : _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _pickedFile != null ? AppColors.verified : AppColors.primary, 
                    style: BorderStyle.solid, 
                    width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: (_pickedFile != null ? AppColors.verified : AppColors.primary).withAlpha(10),
                ),
                child: Column(
                  children: [
                    Icon(
                      _pickedFile != null ? Icons.check_circle : Icons.upload_file, 
                      size: 48, 
                      color: (_pickedFile != null ? AppColors.verified : AppColors.primary).withAlpha(153)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pickedFile != null ? _pickedFile!.name : 'Tap to upload PDF/PNG', 
                      style: GoogleFonts.nunito(
                        color: _pickedFile != null ? AppColors.verified : AppColors.primary, 
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                onPressed: _isLoading ? null : _handleNext,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback get onNext => widget.onNext;
}


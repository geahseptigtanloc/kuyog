import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../data/services/onboarding_service.dart';
import '../../../providers/role_provider.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  final VoidCallback onNext;

  const ProfessionalProfileScreen({super.key, required this.onNext});

  @override
  State<ProfessionalProfileScreen> createState() => _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen> {
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleNext() async {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    if (_bioController.text.isEmpty || _experienceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in your bio and experience')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final onboarding = OnboardingService();
      await onboarding.saveGuideProfile(
        userId: user.id,
        bio: _bioController.text,
        yearsExperience: int.tryParse(_experienceController.text),
        location: _locationController.text,
      );
      
      widget.onNext();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
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
              controller: _bioController,
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
            TextField(
              controller: _experienceController,
              decoration: const InputDecoration(hintText: 'e.g., 5 years in tourism'),
            ),
            const SizedBox(height: 16),
            Text('Location', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
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
                onPressed: _isLoading ? null : () => Navigator.maybePop(context),
                child: const Text('Back'),
              ),
            ),
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
}

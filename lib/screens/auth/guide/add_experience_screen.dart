import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../data/services/onboarding_service.dart';
import '../../../providers/role_provider.dart';

class AddExperienceScreen extends StatefulWidget {
  final VoidCallback onNext;

  const AddExperienceScreen({super.key, required this.onNext});

  @override
  State<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final Set<String> _selectedLanguages = {'English'};
  bool _isLoading = false;

  final List<String> _languages = [
    'English', 'Español', '日本語', 'Persian', 'Suahil', 'Français', 'Deutsch', '正體語', 'Cebuano/Bisaya'
  ];

  Future<void> _handleNext() async {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final onboarding = OnboardingService();
      await onboarding.saveGuideProfile(
        userId: user.id,
        languages: _selectedLanguages.toList(),
      );
      
      widget.onNext();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving languages: $e')),
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
        title: Text('Add Experience', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
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
              children: _languages.map((lang) {
                final isSelected = _selectedLanguages.contains(lang);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        if (_selectedLanguages.length > 1) _selectedLanguages.remove(lang);
                      } else {
                        _selectedLanguages.add(lang);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withAlpha(31) : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
                    ),
                    child: Text(
                      lang,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: _isLoading ? null : () => Navigator.maybePop(context), child: const Text('Back'))),
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


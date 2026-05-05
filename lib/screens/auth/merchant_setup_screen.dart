import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../data/services/onboarding_service.dart';
import '../../providers/role_provider.dart';
import '../../widgets/terms_agreement_sheet.dart';

class MerchantSetupScreen extends StatefulWidget {
  final VoidCallback onNext;

  const MerchantSetupScreen({super.key, required this.onNext});

  @override
  State<MerchantSetupScreen> createState() => _MerchantSetupScreenState();
}

class _MerchantSetupScreenState extends State<MerchantSetupScreen> {
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  String? _businessType;
  bool _isLoading = false;

  final List<String> _businessTypes = [
    'Restaurant',
    'Hotel/Accommodation',
    'Tour Operator',
    'Transport Service',
    'Souvenir Shop',
    'Other',
  ];

  Future<void> _handleNext() async {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    if (_businessNameController.text.isEmpty || _businessType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in business name and type')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final onboarding = OnboardingService();
      await onboarding.saveMerchantProfile(
        userId: user.id,
        businessName: _businessNameController.text,
        businessType: _businessType!,
        address: _addressController.text,
      );

      // Mark as onboarded
      await onboarding.markOnboarded(user.id);
      
      // Update local state
      await roleProvider.initialize();

      widget.onNext();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving business details: $e')),
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
        title: Text('Business Setup', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Information', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                hintText: 'Enter your business name',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _businessType,
              decoration: const InputDecoration(
                labelText: 'Business Type',
              ),
              items: _businessTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) => setState(() => _businessType = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Business Address',
                hintText: 'Enter your business address',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () {
              TermsAgreementSheet.checkAndShow(context, UserRole.merchant, _handleNext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Complete Setup'),
          ),
        ),
      ),
    );
  }
}

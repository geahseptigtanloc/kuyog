import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_mascot.dart';
import '../../../providers/role_provider.dart';
import '../../../data/services/onboarding_service.dart';

class VerificationGateScreen extends StatefulWidget {
  const VerificationGateScreen({super.key});

  @override
  State<VerificationGateScreen> createState() => _VerificationGateScreenState();
}

class _VerificationGateScreenState extends State<VerificationGateScreen> {
  final _onboardingService = OnboardingService();
  bool _isSubmitting = false;
  bool _submitted = false;

  // Maps requirement keys to their uploaded URL
  final Map<String, String?> _uploads = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingDocs();
  }

  Future<void> _loadExistingDocs() async {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    try {
      final roleStr = roleProvider.currentRole == UserRole.merchant ? 'merchant' : 'guide';
      final docs = await _onboardingService.getVerificationDocs(user.id, roleStr);
      
      if (docs != null) {
        setState(() {
          if (roleProvider.currentRole == UserRole.merchant) {
            _uploads['lgu'] = docs['lgu_endorsement_url'];
            _uploads['dot'] = docs['dot_accreditation_url'];
          } else {
            _uploads['dot'] = docs['dot_cert_url'];
            _uploads['barangay'] = docs['barangay_clearance_url'];
            _uploads['birth'] = docs['birth_cert_url'];
            _uploads['nbi'] = docs['nbi_clearance_url'];
            _uploads['app_form'] = docs['application_form_url'];
          }
          // Check if post-onboarding documents are actually uploaded
          bool hasAllRequired = false;
          if (roleProvider.currentRole == UserRole.merchant) {
            hasAllRequired = docs['lgu_endorsement_url'] != null;
          } else {
            hasAllRequired = docs['dot_cert_url'] != null && 
                             docs['barangay_clearance_url'] != null && 
                             docs['birth_cert_url'] != null && 
                             docs['nbi_clearance_url'] != null && 
                             docs['application_form_url'] != null;
          }

          if (hasAllRequired && (docs['status'] == 'submitted' || docs['status'] == 'approved')) {
            _submitted = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading docs: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<_DocRequirement> _getRequirements(UserRole role) {
    if (role == UserRole.merchant) {
      return [
        _DocRequirement('lgu', 'LGU Endorsement', 'Local government unit permit', Icons.location_city),
        _DocRequirement('dot', 'DOT Accreditation (Optional)', 'Department of Tourism cert', Icons.verified, isOptional: true),
      ];
    } else {
      return [
        _DocRequirement('dot', 'DOT Accreditation', 'Department of Tourism cert', Icons.verified),
        _DocRequirement('barangay', 'Barangay Clearance', 'Recent clearance from your barangay', Icons.home_work),
        _DocRequirement('birth', 'Birth Certificate', 'PSA or NSO copy', Icons.child_care),
        _DocRequirement('nbi', 'NBI Clearance', 'Valid NBI clearance certificate', Icons.security),
        _DocRequirement('app_form', 'Application Form', 'Completed and signed form', Icons.assignment),
      ];
    }
  }

  Future<void> _handleUpload(String key, UserRole role, String userId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      withData: true,
    );

    if (result != null) {
      setState(() => _isSubmitting = true);
      try {
        final file = result.files.first;
        // 1. Upload to storage immediately
        final url = await _onboardingService.uploadVerificationFile(
          userId: userId,
          fileName: '${key}_${file.name}',
          fileBytes: file.bytes ?? [],
        );

        // 2. Save progress to DB (draft)
        setState(() => _uploads[key] = url);
        
        if (role == UserRole.merchant) {
          await _onboardingService.submitMerchantVerification(
            userId: userId,
            status: 'draft',
            lguEndorsementUrl: _uploads['lgu'],
            dotAccreditationUrl: _uploads['dot'],
          );
        } else {
          await _onboardingService.submitGuideVerification(
            userId: userId,
            status: 'draft',
            dotCertUrl: _uploads['dot'],
            barangayClearanceUrl: _uploads['barangay'],
            birthCertUrl: _uploads['birth'],
            nbiClearanceUrl: _uploads['nbi'],
            applicationFormUrl: _uploads['app_form'],
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _submitVerification(UserRole role, String userId) async {
    setState(() => _isSubmitting = true);
    
    try {
      // Just update status to submitted
      if (role == UserRole.merchant) {
        await _onboardingService.submitMerchantVerification(
          userId: userId,
          status: 'submitted',
          lguEndorsementUrl: _uploads['lgu'],
          dotAccreditationUrl: _uploads['dot'],
        );
      } else {
        await _onboardingService.submitGuideVerification(
          userId: userId,
          status: 'submitted',
          dotCertUrl: _uploads['dot'],
          barangayClearanceUrl: _uploads['barangay'],
          birthCertUrl: _uploads['birth'],
          nbiClearanceUrl: _uploads['nbi'],
          applicationFormUrl: _uploads['app_form'],
        );
      }
      
      setState(() {
        _submitted = true;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);
    final role = roleProvider.currentRole;
    final userId = roleProvider.currentUser?.id ?? '';
    final requirements = _getRequirements(role);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_submitted) return _buildSubmittedView();

    bool allRequiredUploaded = requirements
        .where((r) => !r.isOptional)
        .every((r) => _uploads[r.key] != null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('Verification', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildHeader(role),
              const SizedBox(height: 24),
              Text('Required Documents', style: AppTheme.headline(size: 16)),
              const SizedBox(height: 12),
              ...requirements.map((req) => _docTile(req, _uploads[req.key] != null, role, userId)),
              const SizedBox(height: 32),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: (allRequiredUploaded && !_isSubmitting) 
                  ? () => _submitVerification(role, userId) 
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, 
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: AppColors.divider,
                ),
                child: _isSubmitting 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Submit for Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 20),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _buildHeader(UserRole role) {
    final roleName = role == UserRole.merchant ? 'Merchant' : 'Guide';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08), 
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(children: [
        const DurieMascot(size: 60),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Become a Verified $roleName', style: AppTheme.headline(size: 18)),
          const SizedBox(height: 4),
          Text('Upload these documents to unlock all features.', 
            style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }

  Widget _docTile(_DocRequirement req, bool isUploaded, UserRole role, String userId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUploaded ? AppColors.success.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isUploaded ? AppColors.success.withOpacity(0.3) : AppColors.divider),
        boxShadow: isUploaded ? [] : AppShadows.card,
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isUploaded ? AppColors.success : AppColors.primary).withOpacity(0.1), 
            borderRadius: BorderRadius.circular(AppRadius.sm)
          ),
          child: Icon(req.icon, size: 22, color: isUploaded ? AppColors.success : AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(req.title, style: AppTheme.label(size: 14)),
          Text(req.subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        GestureDetector(
          onTap: () => _handleUpload(req.key, role, userId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isUploaded ? AppColors.success : AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(isUploaded ? 'Replace' : 'Upload', 
              style: AppTheme.label(size: 12, color: Colors.white)),
          ),
        ),
      ]),
    );
  }

  Widget _buildSubmittedView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const DurieMascot(size: 140),
            const SizedBox(height: 32),
            Text('Application Submitted!', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 12),
            Text('Our team is reviewing your documents. You\'ll see a status banner on your home screen until you\'re approved.',
              style: AppTheme.body(size: 15, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, 
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )),
          ]),
        )),
      ),
    );
  }
}

class _DocRequirement {
  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isOptional;
  _DocRequirement(this.key, this.title, this.subtitle, this.icon, {this.isOptional = false});
}

import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_mascot.dart';

class VerificationGateScreen extends StatefulWidget {
  const VerificationGateScreen({super.key});
  @override
  State<VerificationGateScreen> createState() => _VerificationGateScreenState();
}

class _VerificationGateScreenState extends State<VerificationGateScreen> {
  final _docs = [
    _DocItem('Government ID', 'Valid Philippine ID', Icons.badge, false),
    _DocItem('DOT Accreditation', 'Department of Tourism cert', Icons.verified, false),
    _DocItem('NBI Clearance', 'National Bureau of Investigation', Icons.security, false),
    _DocItem('Profile Photo', 'Clear headshot, no filters', Icons.camera_alt, false),
  ];
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSubmittedView();
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(AppRadius.lg)),
                child: Row(children: [
                  const DurieMascot(size: 50),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Get Verified', style: AppTheme.headline(size: 18)),
                    Text('Upload your documents to start guiding', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                  ])),
                ]),
              ),
              const SizedBox(height: 24),
              Text('Required Documents', style: AppTheme.headline(size: 16)),
              const SizedBox(height: 12),
              ..._docs.asMap().entries.map((e) => _docTile(e.key, e.value)),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: _docs.every((d) => d.uploaded) ? () => setState(() => _submitted = true) : null,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Submit for Review', style: TextStyle(fontSize: 16)),
              )),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _docTile(int idx, _DocItem doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: doc.uploaded ? AppColors.success.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: doc.uploaded ? AppColors.success : AppColors.divider),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: (doc.uploaded ? AppColors.success : AppColors.primary).withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
          child: Icon(doc.icon, size: 22, color: doc.uploaded ? AppColors.success : AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(doc.title, style: AppTheme.label(size: 14)),
          Text(doc.subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        GestureDetector(
          onTap: () => setState(() => _docs[idx] = _DocItem(doc.title, doc.subtitle, doc.icon, !doc.uploaded)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: doc.uploaded ? AppColors.success : AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(doc.uploaded ? 'Done' : 'Upload', style: AppTheme.label(size: 12, color: Colors.white)),
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
            const DurieMascot(size: 120),
            const SizedBox(height: 24),
            Text('Documents Submitted!', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 8),
            Text('Our team will review your documents within 24-48 hours. We\'ll notify you once verified.',
              style: AppTheme.body(size: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
            )),
          ]),
        )),
      ),
    );
  }
}

class _DocItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool uploaded;
  _DocItem(this.title, this.subtitle, this.icon, this.uploaded);
}

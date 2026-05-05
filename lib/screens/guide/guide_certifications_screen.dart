import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../providers/role_provider.dart';

class GuideCertificationsScreen extends StatefulWidget {
  const GuideCertificationsScreen({super.key});

  @override
  State<GuideCertificationsScreen> createState() => _GuideCertificationsScreenState();
}

class _GuideCertificationsScreenState extends State<GuideCertificationsScreen> {
  Map<String, dynamic>? _verificationRecord;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVerifications();
  }

  Future<void> _loadVerifications() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final res = await Supabase.instance.client
          .from('guide_verifications')
          .select()
          .eq('guide_id', user.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _verificationRecord = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading verifications: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper function to determine the status of a specific document
  Map<String, dynamic> _getDocStatus(String docUrlKey) {
    if (_verificationRecord == null) {
      return {'status': 'Missing', 'color': AppColors.warning, 'icon': Icons.warning_amber_rounded};
    }
    
    final docUrl = _verificationRecord![docUrlKey];
    final globalStatus = _verificationRecord!['status'];

    if (docUrl == null || 
        (docUrl is String && docUrl.isEmpty) || 
        (docUrl is List && docUrl.isEmpty)) {
      return {'status': 'Missing', 'color': AppColors.warning, 'icon': Icons.warning_amber_rounded};
    }

    if (globalStatus == 'approved') {
      return {'status': 'Verified', 'color': AppColors.verified, 'icon': Icons.verified};
    } else if (globalStatus == 'rejected') {
      return {'status': 'Rejected', 'color': AppColors.error, 'icon': Icons.error_outline};
    } else {
      return {'status': 'Under Review', 'color': AppColors.primary, 'icon': Icons.pending_actions};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('My Certifications', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ListView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (_verificationRecord != null && _verificationRecord!['status'] == 'rejected')
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.error.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.md)),
                          child: Text(
                            'Rejection Reason: ${_verificationRecord!['rejection_reason'] ?? 'Please update your documents.'}', 
                            style: AppTheme.body(size: 14, color: AppColors.error)
                          ),
                        ),
                      
                      _buildDocTile('DOT Accreditation', 'dot_cert_url'),
                      _buildDocTile('NBI Clearance', 'nbi_clearance_url'),
                      _buildDocTile('Barangay Clearance', 'barangay_clearance_url'),
                      _buildDocTile('Valid ID', 'id_url'),
                      _buildDocTile('CV / Resume', 'cv_url'),
                      _buildDocTile('Portfolio', 'portfolio_urls'),
                      
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document upload coming soon!')));
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Document'),
                      ),
                    ],
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildDocTile(String title, String docKey) {
    final info = _getDocStatus(docKey);
    final statusText = info['status'] as String;
    final color = info['color'] as Color;
    final icon = info['icon'] as IconData;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withAlpha(26), shape: BoxShape.circle),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.label(size: 15)),
          const SizedBox(height: 4),
          Text(statusText, style: AppTheme.body(size: 12, color: color)),
        ])),
      ]),
    );
  }
}


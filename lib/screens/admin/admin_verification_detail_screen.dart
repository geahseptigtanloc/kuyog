import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/kuyog_back_button.dart';
import 'package:intl/intl.dart';

class AdminVerificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String type; // 'guide' or 'merchant'
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminVerificationDetailScreen({
    super.key,
    required this.data,
    required this.type,
    required this.onApprove,
    required this.onReject,
  });

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open document link.')),
        );
      }
    }
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return 'Unknown Date';
    final date = DateTime.parse(isoString).toLocal();
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  Map<String, String?> _extractDocuments() {
    if (type == 'guide') {
      final portfolioUrls = data['portfolio_urls'];
      String? firstPortfolioUrl;
      if (portfolioUrls != null && portfolioUrls is List && portfolioUrls.isNotEmpty) {
        firstPortfolioUrl = portfolioUrls.first.toString();
      }

      return {
        'Valid ID': data['id_url'],
        'CV/Resume': data['cv_url'],
        'Portfolio': firstPortfolioUrl,
        'DOT Accreditation': data['dot_cert_url'],
        'Barangay Clearance': data['barangay_clearance_url'],
        'Birth Certificate': data['birth_cert_url'],
        'NBI Clearance': data['nbi_clearance_url'],
        'Application Form': data['application_form_url'],
      };
    } else {
      return {
        'Business Permit': data['permit_url'],
        'LGU Endorsement': data['lgu_endorsement_url'],
        'DOT Accreditation': data['dot_accreditation_url'],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = type == 'guide' ? data['profiles'] : data['merchant_profiles'];
    final name = type == 'guide' 
        ? (profile['name'] ?? 'Unknown Guide')
        : (profile['businessName'] ?? 'Unknown Business');
    final location = type == 'guide' 
        ? (profile['location'] ?? 'Unknown Location')
        : (profile['address'] ?? 'Unknown Location');

    final documents = _extractDocuments();
    final uploadedDocs = documents.entries.where((e) => e.value != null && e.value!.isNotEmpty).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  KuyogBackButton(onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Application Details', style: AppTheme.headline(size: 20)),
                        Text('Submitted ${_formatDate(data['submitted_at'])}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: (type == 'guide' ? AppColors.primary : AppColors.accent).withAlpha(38),
                            child: Icon(type == 'guide' ? Icons.person : Icons.store, size: 30, color: type == 'guide' ? AppColors.primary : AppColors.accent),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: AppTheme.headline(size: 18)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(location, style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text('Uploaded Documents', style: AppTheme.headline(size: 16)),
                    const SizedBox(height: 12),

                    if (uploadedDocs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('No documents were uploaded with this application.', style: AppTheme.body(size: 14, color: AppColors.error)),
                      ),

                    ...uploadedDocs.map((doc) => _documentTile(context, doc.key, doc.value!)),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Action Bottom Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), offset: const Offset(0, -4), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onReject();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reject', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onApprove();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Approve', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentTile(BuildContext context, String title, String url) {
    final isImage = url.toLowerCase().endsWith('.png') || url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.jpeg');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadows.card,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.touristBlue.withAlpha(26),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(isImage ? Icons.image : Icons.picture_as_pdf, color: AppColors.touristBlue),
        ),
        title: Text(title, style: AppTheme.label(size: 14)),
        trailing: const Icon(Icons.open_in_new, size: 20, color: AppColors.textLight),
        onTap: () => _launchUrl(context, url),
      ),
    );
  }
}


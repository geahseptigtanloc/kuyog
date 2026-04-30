import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../providers/role_provider.dart';

class TermsAgreementSheet extends StatefulWidget {
  final UserRole role;
  final VoidCallback onAgreed;

  const TermsAgreementSheet({
    super.key,
    required this.role,
    required this.onAgreed,
  });

  static Future<void> checkAndShow(BuildContext context, UserRole role, VoidCallback onAgreed) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'terms_agreed_${role.name}';
    final hasAgreed = prefs.getBool(key) ?? false;

    if (hasAgreed) {
      onAgreed();
    } else {
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => TermsAgreementSheet(
          role: role,
          onAgreed: () async {
            await prefs.setBool(key, true);
            if (!ctx.mounted) return;
            Navigator.pop(ctx);
            onAgreed();
          },
        ),
      );
    }
  }

  @override
  State<TermsAgreementSheet> createState() => _TermsAgreementSheetState();
}

class _TermsAgreementSheetState extends State<TermsAgreementSheet> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;
  bool _isChecked = false;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent <= 0) {
        setState(() {
          _hasScrolledToBottom = true;
          _scrollProgress = 1.0;
        });
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    setState(() {
      if (maxScroll > 0) {
        _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      }
      if (currentScroll >= maxScroll - 20) {
        _hasScrolledToBottom = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.92,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Privacy Policy', style: AppTheme.headline(size: 20)),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Kuyog collects and processes personal data in accordance with the Philippine Data Privacy Act of 2012 (R.A. 10173).\n\nYour data will not be sold to third parties...',
                  style: AppTheme.body(size: 13, color: AppColors.textSecondary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Close', style: AppTheme.label(size: 14, color: AppColors.primary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDecline() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Are you sure?', style: AppTheme.headline(size: 20)),
        content: Text('You must agree to the Terms & Conditions to use Kuyog.', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
            child: Text('Go Back', style: AppTheme.label(size: 14, color: AppColors.primary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close terms sheet
              // Navigation back to onboarding is handled by caller or just popping
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Exit App'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header (Sticky)
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Icon(Icons.eco, size: 40, color: AppColors.primary),
          const SizedBox(height: 8),
          Text('Terms & Conditions', style: AppTheme.headline(size: 20)),
          const SizedBox(height: 4),
          Text('Please read and agree to continue using Kuyog.', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.primary),
          
          // Progress Bar
          LinearProgressIndicator(
            value: _scrollProgress,
            backgroundColor: AppColors.background,
            color: AppColors.primary,
            minHeight: 3,
          ),

          // Scrollable Content
          Expanded(
            child: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
                      child: Row(children: [
                        const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Text('Read all sections before agreeing', style: AppTheme.label(size: 12, color: AppColors.warning)),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    _termsSection('1. Acceptance of Terms', 'By using the Kuyog app, you agree to be bound by these Terms and Conditions and our Privacy Policy.'),
                    _termsSection('2. User Responsibilities', 'Users are responsible for providing accurate information during registration and maintaining the security of their accounts.'),
                    _termsSection('3. For Tourists', 'Tourists agree to respect local culture, follow guide instructions, and treat tour guides and merchants with respect and dignity.'),
                    _termsSection('4. For Tour Guides', 'Tour guides agree to maintain DOT accreditation standards, provide accurate service descriptions, and ensure tourist safety throughout all tours.'),
                    _termsSection('5. For Merchants', 'Merchants agree that all listed products and services comply with local business permit requirements and LGU endorsements.'),
                    _termsSection('6. Booking & Payments', 'All bookings are subject to availability. Cancellation policies vary by guide and tour package. Platform fees apply as disclosed during checkout.'),
                    _termsSection('7. Data Privacy', 'Kuyog collects and processes personal data in accordance with the Philippine Data Privacy Act of 2012 (R.A. 10173). Your data will not be sold to third parties.'),
                    _termsSection('8. Content Policy', 'Users may not post false, misleading, or harmful content on StoryHub or any other part of the platform.'),
                    _termsSection('9. Intellectual Property', 'All Kuyog branding, including the Durie mascot, logos, and app design, are the intellectual property of Kuyog and Ateneo de Davao University.'),
                    _termsSection('10. Termination', 'Kuyog reserves the right to suspend or terminate accounts that violate these terms.\n\nLast updated: January 2025\nKuyog — Ateneo de Davao University'),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),

          // Footer (Sticky)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 8)],
            ),
            child: Column(
              children: [
                if (_hasScrolledToBottom)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text("You've read the full terms", style: AppTheme.label(size: 11, color: AppColors.success)),
                  ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (v) => setState(() => _isChecked = v ?? false),
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Tap anywhere on text to check
                          setState(() => _isChecked = !_isChecked);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.body(size: 13, color: AppColors.textPrimary),
                            children: [
                              const TextSpan(text: 'I have read and agree to Kuyog\'s '),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () {}, // Not needed here, will just toggle check
                                  child: Text('Terms & Conditions', style: AppTheme.label(size: 13, color: AppColors.primary)),
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () => _showPrivacyPolicy(),
                                  child: Text('Privacy Policy', style: AppTheme.label(size: 13, color: AppColors.primary)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_hasScrolledToBottom && _isChecked) ? widget.onAgreed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      disabledBackgroundColor: AppColors.divider,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('I Agree & Continue'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _handleDecline,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Decline', style: AppTheme.label(size: 14, color: AppColors.error)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _termsSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.label(size: 14)),
          const SizedBox(height: 4),
          Text(body, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

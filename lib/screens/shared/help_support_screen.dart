import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
              Text('Help & Support', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _contactCard(),
                const SizedBox(height: 24),
                Text('Frequently Asked Questions', style: AppTheme.headline(size: 16)),
                const SizedBox(height: 12),
                _faqTile('How do I become a verified guide?', 'Go to the Guide Dashboard and complete the 3-step verification process by uploading your valid IDs and DOT accreditation.'),
                _faqTile('How does the Madayaw Crawl work?', 'Scan QR codes at participating tourist spots to earn stamps. Collect enough stamps to unlock exclusive discounts and merchandise.'),
                _faqTile('Are the products authentic?', 'Yes! All merchants with the "Official Kuyog Merchant" badge are verified locals selling authentic Mindanao-made crafts and food.'),
                _faqTile('What payment methods are supported?', 'Currently, we support GCash, Maya, and major credit cards via our secure payment gateway.'),
                _faqTile('How can I contact my guide?', 'Once you book an itinerary, a secure chat room will open between you and your guide in the Chat Hub.'),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _contactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Need immediate help?', style: AppTheme.headline(size: 18, color: Colors.white)),
        const SizedBox(height: 8),
        Text('Our support team is available 24/7 to assist you with your bookings and inquiries.', style: AppTheme.body(size: 13, color: Colors.white.withAlpha(230))),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.email_outlined, color: AppColors.primary),
          label: const Text('Contact Support'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ]),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: ExpansionTile(
        title: Text(question, style: AppTheme.label(size: 14)),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textLight,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(answer, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}


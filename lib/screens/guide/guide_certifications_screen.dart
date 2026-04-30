import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class GuideCertificationsScreen extends StatelessWidget {
  const GuideCertificationsScreen({super.key});

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
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                _certTile('DOT Accreditation', 'Valid until Dec 2026', AppColors.verified),
                _certTile('First Aid & CPR', 'Red Cross PH - Valid until Oct 2025', AppColors.primary),
                _certTile('NBI Clearance', 'Valid until Jan 2027', AppColors.textSecondary),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Upload New Document'),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _certTile(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.verified, size: 24, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.label(size: 15)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }
}

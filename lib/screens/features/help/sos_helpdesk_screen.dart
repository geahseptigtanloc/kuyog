import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class SosHelpdeskScreen extends StatelessWidget {
  const SosHelpdeskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.error,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Emergency SOS & Help', style: AppTheme.headline(size: 20, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Panic Button Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency signal sent. Tracking location.'), backgroundColor: Colors.black));
                    },
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.touch_app, size: 48, color: AppColors.error),
                          const SizedBox(height: 8),
                          Text('TAP TO SOS', style: AppTheme.headline(size: 18, color: AppColors.error)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('This will immediately alert local authorities and your emergency contacts.', textAlign: TextAlign.center, style: AppTheme.body(size: 14, color: Colors.white70)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local Hotlines', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 16),
                  _hotlineCard(Icons.local_police, 'National Emergency', '911', AppColors.primaryDark),
                  _hotlineCard(Icons.local_fire_department, 'Fire Department', '166', const Color(0xFFD97706)),
                  _hotlineCard(Icons.medical_services, 'Philippine Red Cross', '143', AppColors.error),
                  _hotlineCard(Icons.tour, 'Tourist Police', '0917-123-4567', AppColors.touristBlue),
                  const SizedBox(height: 32),

                  Text('Tourist HelpDesk', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                          title: const Text('Live Chat Support'),
                          subtitle: const Text('Available 24/7'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.article_outlined, color: AppColors.primary),
                          title: const Text('Frequently Asked Questions'),
                          subtitle: const Text('Guidelines and policies'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.report_problem_outlined, color: AppColors.primary),
                          title: const Text('Report an Issue'),
                          subtitle: const Text('App feedback or user reports'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hotlineCard(IconData icon, String title, String number, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.label(size: 14)),
                const SizedBox(height: 4),
                Text(number, style: AppTheme.headline(size: 20, color: color)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            color: color,
            onPressed: () {},
            style: IconButton.styleFrom(backgroundColor: color.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }
}

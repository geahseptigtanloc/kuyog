import 'package:flutter/material.dart';
import '../../app_theme.dart';

class AdminVerificationsTab extends StatelessWidget {
  const AdminVerificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), child: Row(children: [
            Text('Verifications', style: AppTheme.headline(size: 24)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('8 pending', style: AppTheme.label(size: 12, color: AppColors.warning))),
          ])),
          Expanded(child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _verificationCard('Rico Magbanua', 'Gen. Santos City', 'Apr 28, 2026', 3),
              _verificationCard('Amina Lidasan', 'Cotabato City', 'Apr 27, 2026', 2),
              _verificationCard('Ben Tiumalu', 'Butuan City', 'Apr 26, 2026', 4),
              _verificationCard('Grace Tabang', 'Zamboanga City', 'Apr 25, 2026', 2),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _verificationCard(String name, String city, String date, int docs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 22, backgroundColor: AppColors.primary.withOpacity(0.15), child: const Icon(Icons.person, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.label(size: 14)),
            Text('$city · Submitted $date', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.touristBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text('$docs docs', style: AppTheme.label(size: 10, color: AppColors.touristBlue))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 10)),
            child: const Text('Approve', style: TextStyle(fontSize: 13)))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 10)),
            child: const Text('Reject', style: TextStyle(fontSize: 13)))),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8)),
            child: const Text('Info', style: TextStyle(fontSize: 13))),
        ]),
      ]),
    );
  }
}

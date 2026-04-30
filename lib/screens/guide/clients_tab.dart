import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_app_bar.dart';

class ClientsTab extends StatelessWidget {
  const ClientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'Clients'),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), boxShadow: AppShadows.card),
              child: Row(children: [
                const Icon(Icons.search, color: AppColors.textLight, size: 20),
                const SizedBox(width: 10),
                Text('Search clients...', style: AppTheme.body(size: 14, color: AppColors.textLight)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _clientCard('Anna Reyes', 'Last trip: May 5, 2026', '5.0', true),
                _clientCard('Mike Torres', 'Last trip: Apr 28, 2026', '4.5', true),
                _clientCard('Sarah Kim', 'Last trip: Apr 20, 2026', '5.0', false),
                _clientCard('Carlos Garcia', 'Last trip: Apr 15, 2026', '4.8', true),
                _clientCard('Lena Park', 'Upcoming: May 10, 2026', '—', false),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _clientCard(String name, String lastTrip, String rating, bool hasMessage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        CircleAvatar(radius: 24, backgroundColor: AppColors.primary.withValues(alpha: 0.12), child: const Icon(Icons.person, color: AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 14)),
          Text(lastTrip, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ])),
        Column(children: [
          Text(rating, style: AppTheme.label(size: 12)),
          if (hasMessage) ...[
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble, size: 14, color: AppColors.primary)),
          ],
        ]),
      ]),
    );
  }
}

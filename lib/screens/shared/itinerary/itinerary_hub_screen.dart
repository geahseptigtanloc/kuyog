import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/mindanao_map.dart';
import 'itinerary_create_screen.dart';
import 'itinerary_detail_screen.dart';

class ItineraryHubScreen extends StatelessWidget {
  const ItineraryHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text('Itinerary', style: AppTheme.headline(size: 24)),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 200, child: MindanaoMap()),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.search, size: 18), label: const Text('Search'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryCreateScreen())), icon: const Icon(Icons.add, size: 18), label: const Text('Create New'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary))),
              ]),
            ),
            const SizedBox(height: 24),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Current Itineraries', style: AppTheme.headline(size: 18))),
            const SizedBox(height: 12),
            _itineraryTile(context, 'Davao City Explorer', '5 stops · 3 days', 'Active', AppColors.primary),
            _itineraryTile(context, 'Siargao Surf Trip', '4 stops · 5 days', 'Upcoming', AppColors.accent),
            _itineraryTile(context, 'Lake Sebu Cultural Tour', '3 stops · 2 days', 'Completed', AppColors.textLight),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _itineraryTile(BuildContext context, String title, String subtitle, String status, Color statusColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItineraryDetailScreen(
              title: title,
              status: status,
              statusColor: statusColor,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Icon(Icons.map, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTheme.label(size: 14)),
            Text(subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text(status, style: AppTheme.label(size: 11, color: statusColor)),
          ),
        ]),
      ),
    );
  }
}

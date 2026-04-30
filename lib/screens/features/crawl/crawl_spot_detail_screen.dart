import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/event.dart';
import '../../../providers/crawl_provider.dart';

class CrawlSpotDetailScreen extends StatelessWidget {
  final CrawlEvent event;

  const CrawlSpotDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final crawl = context.watch<CrawlProvider>();
    final isJoined = crawl.stampCount > 0; // Simple mock condition

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.accent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: event.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.pill)),
                          child: Text(event.category, style: AppTheme.label(size: 11, color: Colors.white)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.name,
                          style: AppTheme.headline(size: 24, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(event.dateRange, style: AppTheme.body(size: 13, color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isJoined) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.qr_code_scanner, color: AppColors.accent, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Scan QR to get Stamp', style: AppTheme.label(size: 14, color: AppColors.accent)),
                                Text('Visit participating spots to earn stamps and win prizes.', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  Text('About the Event', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 12),
                  Text(event.description, style: AppTheme.body(size: 14)),
                  const SizedBox(height: 24),

                  Text('Participating Spots', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 12),
                  ...event.spots.map((spot) => _spotTile(spot)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isJoined
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      crawl.collectStamp('Welcome Stamp');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined successfully! Earned 1 free stamp.'), backgroundColor: AppColors.success));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Join Crawl Event'),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _spotTile(CrawlSpot spot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Icon(Icons.store, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spot.name, style: AppTheme.label(size: 14)),
                const SizedBox(height: 2),
                Text(spot.address, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (spot.isCollected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text('Stamped', style: AppTheme.label(size: 11, color: AppColors.success)),
            )
          else
            const Icon(Icons.qr_code, color: AppColors.textLight),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/event.dart';
import '../../../providers/crawl_provider.dart';
import '../../../widgets/mock_qr_scanner.dart';

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
                    placeholder: (context, url) => Container(color: AppColors.divider),
                    errorWidget: (context, url, error) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.image, color: AppColors.primary, size: 48)),
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
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final success = await Navigator.push(context, MaterialPageRoute(builder: (_) => const MockQrScanner()));
                      if (success == true) {
                        context.read<CrawlProvider>().collectStampSimple('scanned_stamp');
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stamp Collected!'), backgroundColor: AppColors.success));
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR to Earn Stamp'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16), foregroundColor: Colors.white),
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      crawl.collectStampSimple('Welcome Stamp');
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
        border: spot.isFeatured ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: CachedNetworkImage(
                  imageUrl: spot.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.background),
                  errorWidget: (context, url, error) => Container(color: AppColors.divider, child: const Icon(Icons.place, color: AppColors.textLight)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(spot.name, style: AppTheme.label(size: 14))),
                        if (spot.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                            child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(spot.address, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text('${spot.milesReward} Miles', style: AppTheme.label(size: 12, color: AppColors.primary)),
                        const Spacer(),
                        _buildProximityHint(spot.proximityHint),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions_outlined, size: 16),
                  label: const Text('Get Directions', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (spot.isCollected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      const SizedBox(width: 4),
                      Text('Stamped', style: AppTheme.label(size: 12, color: AppColors.success)),
                    ],
                  ),
                )
              else
                const Icon(Icons.qr_code_2, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProximityHint(String hint) {
    Color color;
    String label;
    switch (hint.toLowerCase()) {
      case 'hot':
        color = Colors.red;
        label = 'Hot!';
        break;
      case 'warm':
        color = Colors.orange;
        label = 'Warmer';
        break;
      case 'durie':
        color = Colors.red;
        label = 'Durie is HERE!';
        break;
      default:
        color = Colors.grey;
        label = 'Cold';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: AppTheme.label(size: 10, color: color)),
    );
  }
}

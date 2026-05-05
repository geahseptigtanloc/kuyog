import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../models/event.dart';
import '../../../providers/crawl_provider.dart';
import '../../../widgets/mock_qr_scanner.dart';
import '../../../widgets/core/kuyog_button.dart';

class CrawlSpotDetailScreen extends StatelessWidget {
  final CrawlEvent event;

  const CrawlSpotDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final crawl = context.watch<CrawlProvider>();
    final isJoined = crawl.stampCount > 0; // Simple mock condition

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4EF), // Light sage background to match image
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Image & Title Card Stack
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Image
                CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(height: 350, color: AppColors.divider),
                  errorWidget: (context, url, error) => Container(
                    height: 350,
                    color: AppColors.primary.withAlpha(26),
                    child: const Icon(Icons.image, color: AppColors.primary, size: 48),
                  ),
                ),
                // Navigation Buttons
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary, size: 20),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                // Floating Title Card
                Positioned(
                  bottom: -40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: GoogleFonts.baloo2(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.8 ratings',
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: AppColors.divider,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '500 Points',
                              style: GoogleFonts.baloo2(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '/Crawl',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 64)),

          // Content Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // About section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About the event',
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Info Chips Scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _infoChip(Icons.access_time, 'Duration', 'All Day', const Color(0xFFFFF7ED)),
                        _infoChip(Icons.category, 'Category', event.category, const Color(0xFFFFF1DC)),
                        _infoChip(Icons.location_on, 'Location', 'Davao City', const Color(0xFFFFEDD5)),
                        _infoChip(Icons.people, 'Limit', 'None', const Color(0xFFFFE4D6)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Participating Spots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Participating Spots',
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See all',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...event.spots.map((spot) => _spotTile(spot)),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: KuyogButton(
          label: isJoined ? 'Scan QR to Earn Stamp' : 'Join Crawl Event',
          onPressed: () async {
            if (isJoined) {
              final success = await Navigator.push(context, MaterialPageRoute(builder: (_) => const MockQrScanner()));
              if (!context.mounted) return;
              if (success == true) {
                context.read<CrawlProvider>().collectStampSimple('scanned_stamp');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stamp Collected!'), backgroundColor: AppColors.success));
              }
            } else {
              crawl.collectStampSimple('Welcome Stamp');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined successfully! Earned 1 free stamp.'), backgroundColor: AppColors.success));
            }
          },
          fullWidth: true,
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value, Color bgColor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(icon, color: const Color(0xFF92400E), size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
        border: spot.isFeatured ? Border.all(color: AppColors.primary.withAlpha(76), width: 1.5) : null,
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
                  decoration: BoxDecoration(color: AppColors.success.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
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
      decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: AppTheme.label(size: 10, color: color)),
    );
  }
}


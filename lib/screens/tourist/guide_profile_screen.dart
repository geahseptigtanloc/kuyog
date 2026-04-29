import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';
import '../../../widgets/verified_badge.dart';

class GuideProfileScreen extends StatelessWidget {
  final Guide guide;

  const GuideProfileScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: guide.bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.primary),
                    errorWidget: (c, u, e) => Container(color: AppColors.primary),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage: CachedNetworkImageProvider(guide.photoUrl),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.name,
                                style: GoogleFonts.baloo2(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text(guide.city, style: AppTheme.body(size: 13, color: Colors.white70)),
                                  const SizedBox(width: 12),
                                  if (guide.isVerified) const VerifiedBadge(size: 16, showText: true),
                                ],
                              ),
                            ],
                          ),
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
                  // Stats
                  Row(
                    children: [
                      _statCard(Icons.star, '${guide.rating}', '${guide.reviewCount} reviews', AppColors.warning),
                      const SizedBox(width: 8),
                      _statCard(Icons.luggage, '${guide.tripCount}', 'Trips hosted', AppColors.touristBlue),
                      const SizedBox(width: 8),
                      _statCard(Icons.calendar_month, '${guide.yearsExperience}', 'Years exp.', AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.map),
                          label: const Text('Co-create Itinerary'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        child: const Icon(Icons.chat_bubble_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // About
                  Text('About ${guide.name.split(' ')[0]}', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 12),
                  Text(guide.bio, style: AppTheme.body(size: 14)),
                  const SizedBox(height: 24),

                  // Details
                  _detailSection('Specialties', guide.specialties, Icons.star),
                  const SizedBox(height: 20),
                  _detailSection('Languages', guide.languages, Icons.language),
                  const SizedBox(height: 20),
                  _detailSection('Certifications', guide.certifications, Icons.verified_user),
                  const SizedBox(height: 32),

                  // Gallery
                  if (guide.itineraryPhotos.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Past Trips', style: AppTheme.headline(size: 18)),
                        Text('See All', style: AppTheme.label(size: 13, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: guide.itineraryPhotos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: CachedNetworkImage(
                                imageUrl: guide.itineraryPhotos[index],
                                width: 160,
                                fit: BoxFit.cover,
                                placeholder: (c, u) => Container(width: 160, color: AppColors.divider),
                                errorWidget: (c, u, e) => Container(width: 160, color: AppColors.primary.withValues(alpha: 0.1)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(height: 4),
            Text(value, style: AppTheme.label(size: 16)),
            Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _detailSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(title, style: AppTheme.headline(size: 16)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(item, style: AppTheme.body(size: 13, color: AppColors.primary)),
          )).toList(),
        ),
      ],
    );
  }
}

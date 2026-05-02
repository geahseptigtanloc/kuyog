import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';
import '../../../widgets/verified_badge.dart';
import '../../../widgets/verified_content_badge.dart';
import '../../../providers/match_provider.dart';
import '../../../providers/travel_provider.dart';
import '../shared/travel/travel_type_screen.dart';
import '../shared/travel/group_setup_screen.dart';
import '../shared/travel/ai_matching_screen.dart';

class GuideProfileScreen extends StatelessWidget {
  final Guide guide;

  const GuideProfileScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final matchProvider = context.watch<MatchProvider>();
    final isPending = matchProvider.hasRequestedMatch(guide.id);

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
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                  // Guide type badge
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 50,
                    right: 16,
                    child: VerifiedContentBadge(
                      type: guide.guideType == 'regional' ? BadgeType.regionalGuide : BadgeType.communityGuide,
                      fontSize: 11,
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
                  // Verification badges
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    if (guide.dotAccredited) const VerifiedContentBadge(type: BadgeType.dotAccredited, fontSize: 10),
                    if (guide.lguEndorsed) const VerifiedContentBadge(type: BadgeType.lguEndorsed, fontSize: 10),
                    if (guide.pricingStatus == 'approved') const VerifiedContentBadge(type: BadgeType.adminApproved, fontSize: 10),
                  ]),
                  const SizedBox(height: 16),

                  // Why We Matched You
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('Why We Matched You', style: AppTheme.label(size: 14, color: AppColors.primary)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.pill)),
                          child: Text('${guide.matchScore}% Match', style: AppTheme.label(size: 11, color: Colors.white)),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text('Based on your interest in ${guide.specialties.take(2).join(" and ")}', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                    ]),
                  ),
                  const SizedBox(height: 16),

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
                          onPressed: isPending ? null : () {
                            _startTravelFlow(context);
                          },
                          icon: Icon(isPending ? Icons.hourglass_empty : Icons.handshake),
                          label: Text(isPending ? 'Request Pending' : 'Request Match'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPending ? AppColors.warning : AppColors.accent,
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
                  const SizedBox(height: 24),

                  // My Story
                  if (guide.fullStory.isNotEmpty) ...[
                    Text('My Story', style: AppTheme.headline(size: 18)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.card,
                        border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
                      ),
                      child: Text(guide.fullStory, style: AppTheme.body(size: 14).copyWith(height: 1.6)),
                    ),
                    const SizedBox(height: 24),
                  ],

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
                  const SizedBox(height: 24),

                  // Payment Methods
                  if (guide.acceptedPayments.isNotEmpty) ...[
                    Row(children: [
                      const Icon(Icons.payment, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text('Accepted Payments', style: AppTheme.headline(size: 16)),
                    ]),
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, runSpacing: 8, children: guide.acceptedPayments.map((p) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        boxShadow: AppShadows.card,
                        border: Border.all(color: _paymentColor(p).withOpacity(0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_paymentIcon(p), size: 18, color: _paymentColor(p)),
                        const SizedBox(width: 6),
                        Text(p, style: AppTheme.label(size: 12, color: _paymentColor(p))),
                      ]),
                    )).toList()),
                    const SizedBox(height: 24),
                  ],

                  // Pricing
                  if (guide.pricingStatus == 'approved') ...[
                    Text('Admin-Approved Rates', style: AppTheme.headline(size: 18)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text('These rates have been reviewed and approved by Kuyog admin.', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                        ]),
                        const SizedBox(height: 12),
                        _priceRow('Half Day Tour', guide.priceRange == '\u20B1' ? '\u20B1500-800' : guide.priceRange == '\u20B1\u20B1' ? '\u20B11,000-1,500' : '\u20B11,500-2,500'),
                        _priceRow('Full Day Tour', guide.priceRange == '\u20B1' ? '\u20B11,000-1,500' : guide.priceRange == '\u20B1\u20B1' ? '\u20B12,000-3,000' : '\u20B13,000-5,000'),
                        _priceRow('Multi-Day Package', 'Contact for quote'),
                      ]),
                    ),
                    const SizedBox(height: 24),
                  ],

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
                                errorWidget: (c, u, e) => Container(width: 160, color: AppColors.primary.withOpacity(0.1)),
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
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(item, style: AppTheme.body(size: 13, color: AppColors.primary)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _priceRow(String type, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(child: Text(type, style: AppTheme.label(size: 13))),
        Text(price, style: AppTheme.label(size: 14, color: AppColors.primary)),
      ]),
    );
  }

  Color _paymentColor(String method) {
    switch (method) {
      case 'GCash': return const Color(0xFF007BFF);
      case 'Maya': return const Color(0xFF00B140);
      case 'Bank Transfer': return const Color(0xFF1E3A5F);
      case 'Credit/Debit Card': return AppColors.accent;
      default: return AppColors.textSecondary;
    }
  }

  IconData _paymentIcon(String method) {
    switch (method) {
      case 'GCash': return Icons.phone_android;
      case 'Maya': return Icons.phone_android;
      case 'Bank Transfer': return Icons.account_balance;
      case 'Credit/Debit Card': return Icons.credit_card;
      default: return Icons.payments;
    }
  }

  void _startTravelFlow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TravelTypeScreen(
          onContinue: () {
            final provider = context.read<TravelProvider>();
            provider.selectGuide(guide.id);
            if (provider.travelType == 'group') {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => GroupSetupScreen(
                  onContinue: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const AIMatchingScreen(nextRoute: 'guide_profile'),
                    ));
                  },
                ),
              ));
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const AIMatchingScreen(nextRoute: 'guide_profile'),
              ));
            }
          },
        ),
      ),
    );
  }
}

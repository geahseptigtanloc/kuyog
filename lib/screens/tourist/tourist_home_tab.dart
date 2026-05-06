import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/tour_operator.dart';
import '../../providers/role_provider.dart';
import '../../widgets/durie_mascot.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_section_header.dart';
import '../../widgets/core/kuyog_badge.dart';
import 'just_show_up/just_show_up_screen.dart';
import 'just_show_up/package_detail_screen.dart';
import 'roam_free/roam_free_screen.dart';
import 'roam_free/transport_booking_screen.dart';
import 'discover_davao_screen.dart';
import 'events_calendar_screen.dart';
import '../shared/my_trips_screen.dart';

class TouristHomeTab extends StatefulWidget {
  const TouristHomeTab({super.key});
  @override
  State<TouristHomeTab> createState() => _TouristHomeTabState();
}

class _TouristHomeTabState extends State<TouristHomeTab> {
  List<TourPackage> _packages = [];
  List<TourOperator> _operators = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pkgs = await MockData.getTourPackages();
    final ops = await MockData.getTourOperators();
    if (mounted) {
      setState(() {
        _packages = pkgs;
        _operators = ops;
        _loading = false;
      });
    }
  }

  TourOperator? _opFor(String id) {
    try {
      return _operators.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Hero Section
                SliverToBoxAdapter(child: _heroSection(role)),
                // Madayaw Points
                SliverToBoxAdapter(child: _madayawPointsBar()),
                // Two Legs
                SliverToBoxAdapter(child: _twoLegs()),
                // Quick Actions
                SliverToBoxAdapter(child: _quickActions()),
                // Recommended Packages
                SliverToBoxAdapter(
                  child: const KuyogSectionHeader(
                    title: 'Recommended for You',
                    subtitle: 'AI-matched to your interests',
                    padding: EdgeInsets.fromLTRB(AppSpacing.xl, 32, AppSpacing.xl, 12),
                  ),
                ),
                SliverToBoxAdapter(child: _packageStrip()),
                // Featured Destinations
                SliverToBoxAdapter(
                  child: const KuyogSectionHeader(
                    title: 'From StoryHub',
                    subtitle: 'Stories from fellow travelers',
                    padding: EdgeInsets.fromLTRB(AppSpacing.xl, 32, AppSpacing.xl, 12),
                  ),
                ),
                SliverToBoxAdapter(child: _storyHubPreview()),
                // Madayaw Crawl Banner
                SliverToBoxAdapter(child: _crawlBanner()),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
    );
  }

  Widget _heroSection(RoleProvider role) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // Greeting and Durie row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kuyog ta, ${role.currentUser?.name ?? "Traveler"}!',
                          style: GoogleFonts.baloo2(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Experience Davao. Your Way.',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white.withAlpha(191),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const DurieMascot(size: 56),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Search bar
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.textLight, size: 20),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Search tours, destinations...',
                        style: AppTheme.body(size: 14, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _madayawPointsBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Madayaw Points',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '1,250',
                style: GoogleFonts.baloo2(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                ' pts',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.white.withAlpha(204),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _twoLegs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
      child: Column(
        children: [
          // JUST SHOW UP - PRIMARY (larger, top)
          KuyogCard(
            padding: EdgeInsets.zero,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JustShowUpScreen()),
            ),
            child: SizedBox(
              height: 180, // Even size
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/seed/just_show_up/800/600',
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.primary),
                    errorWidget: (c, u, e) => Container(color: AppColors.primary),
                  ),
                  // Solid Overlay
                  Container(
                    color: Colors.black.withAlpha(100),
                  ),
                  // Content
                  Positioned(
                    bottom: AppSpacing.lg,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            'Tour Package',
                            style: AppTheme.label(
                              size: 11,
                              color: AppColors.primary,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Just Show Up',
                          style: GoogleFonts.baloo2(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'All-in tour packages. Managed for you.',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white.withAlpha(204),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow button
                  Positioned(
                    top: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // ROAM FREE - SECONDARY (smaller)
          KuyogCard(
            padding: EdgeInsets.zero,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoamFreeScreen()),
            ),
            child: SizedBox(
              height: 180, // Even size
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/seed/roam_free/800/600',
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.primary),
                    errorWidget: (c, u, e) => Container(color: AppColors.primary),
                  ),
                  // Solid Overlay
                  Container(
                    color: Colors.black.withAlpha(100),
                  ),
                  // Content
                  Positioned(
                    bottom: AppSpacing.lg,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            'Build Your Own',
                            style: AppTheme.label(
                              size: 11,
                              color: AppColors.primary,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Roam Free',
                          style: GoogleFonts.baloo2(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Build your own AI-assisted itinerary.',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white.withAlpha(204),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow button
                  Positioned(
                    top: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      {
        'label': 'Discover\nDavao',
        'icon': Icons.explore,
        'tap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscoverDavaoScreen())),
      },
      {
        'label': 'Transport\nRental',
        'icon': Icons.directions_car,
        'tap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransportBookingScreen())),
      },
      {
        'label': 'Events\nCalendar',
        'icon': Icons.event,
        'tap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsCalendarScreen())),
      },
      {
        'label': 'My\nTrips',
        'icon': Icons.luggage,
        'tap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyTripsScreen())),
      },
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: KuyogCard(
                onTap: action['tap'] as VoidCallback?,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                radius: AppRadius.lg,
                border: Border.all(color: AppColors.accent.withAlpha(80), width: 1.2),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(action['icon'] as IconData,
                        color: AppColors.accent, size: 22),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(action['label'] as String,
                      style: AppTheme.label(size: 11, color: AppColors.textPrimary),
                      textAlign: TextAlign.center),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _packageStrip() {
    if (_packages.isEmpty) return const SizedBox();
    return SizedBox(
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: _packages.length,
        itemBuilder: (c, i) => _pkgCard(_packages[i]),
      ),
    );
  }

  Widget _pkgCard(TourPackage pkg) {
    final op = _opFor(pkg.operatorId);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md, bottom: AppSpacing.md),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PackageDetailScreen(package: pkg, operator: op))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                CachedNetworkImage(
                  imageUrl: pkg.photoUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(height: 140, color: AppColors.divider),
                  errorWidget: (c, u, e) => Container(
                    height: 140, 
                    color: AppColors.primary.withAlpha(25),
                    child: const Icon(Icons.image_not_supported, color: AppColors.primary),
                  ),
                ),
                // Content Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              pkg.name,
                              style: AppTheme.headline(size: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₱${pkg.price.toInt()}',
                                style: AppTheme.headline(size: 16, color: AppColors.primary),
                              ),
                              Text(
                                '/Person',
                                style: AppTheme.body(size: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Rating Row
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${pkg.rating}',
                            style: AppTheme.label(size: 13, color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ratings',
                            style: AppTheme.body(size: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Info Pills Row
                      Row(
                        children: [
                          // Duration Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule, size: 14, color: Color(0xFF0284C7)),
                                const SizedBox(width: 6),
                                Text(
                                  pkg.duration.isNotEmpty ? pkg.duration : '${pkg.durationDays} Days',
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0284C7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Operator Pill
                          if (op != null)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified, size: 14, color: Color(0xFF16A34A)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        op.companyName,
                                        style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF16A34A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _storyHubPreview() {
    // Mock story posts for preview
    final mockPosts = [
      {
        'image': 'https://picsum.photos/seed/story1/400/300',
        'title': 'Sunset at Mount Apo',
        'author': 'Maria Santos',
        'location': 'Davao City',
      },
      {
        'image': 'https://picsum.photos/seed/story2/400/300',
        'title': 'Hidden Waterfalls',
        'author': 'Juan Cruz',
        'location': 'Davao del Norte',
      },
      {
        'image': 'https://picsum.photos/seed/story3/400/300',
        'title': 'City Exploration',
        'author': 'Ana Reyes',
        'location': 'Davao City',
      },
    ];

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          final post = mockPosts[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md, bottom: AppSpacing.md),
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to StoryHub
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post image
                      CachedNetworkImage(
                        imageUrl: post['image'] as String,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (c, u) => Container(
                          height: 130,
                          color: AppColors.divider,
                        ),
                        errorWidget: (c, u, e) => Container(
                          height: 130,
                          color: AppColors.primary.withAlpha(25),
                        ),
                      ),
                      // Post content
                      Expanded(
                        child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'] as String,
                              style: AppTheme.headline(size: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: AppColors.primary.withAlpha(50),
                                  child: Text(
                                    (post['author'] as String).substring(0, 1),
                                    style: AppTheme.label(size: 10, color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    post['author'] as String,
                                    style: AppTheme.label(size: 11, color: AppColors.textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    post['location'] as String,
                                    style: AppTheme.body(size: 11, color: AppColors.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _crawlBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            border: Border.all(color: AppColors.primary.withAlpha(51)),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  KuyogBadge(
                    label: 'SEASON ACTIVE',
                    color: AppColors.primary.withAlpha(38),
                    labelColor: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Madayaw Lungsod Crawl',
                      style: AppTheme.headline(size: 20, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text('Explore heritage sites. Win rewards!',
                      style: AppTheme.body(size: 13, color: AppColors.primary.withAlpha(204))),
                ])),
            const SizedBox(width: AppSpacing.md),
            const DurieMascot(size: 64),
          ]),
        ),
      ),
    );
  }
}


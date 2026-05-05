import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/guide.dart';
import '../../models/destination.dart';
import '../../providers/match_provider.dart';
import '../../widgets/verified_content_badge.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_section_header.dart';
import '../../widgets/core/kuyog_button.dart';
import 'guide_profile_screen.dart';
import '../features/crawl/crawl_home_screen.dart';
import '../../providers/travel_provider.dart';
import '../shared/travel/travel_type_screen.dart';
import '../shared/travel/group_setup_screen.dart';
import '../shared/travel/ai_matching_screen.dart';
import '../../providers/role_provider.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});
  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _tabIndex = 0;
  final _tabs = [
    'Guides',
    'Destinations',
    'Marketplace',
    'Crawl & Events',
    'Tour Operators'
  ];
  final _tabIcons = [
    Icons.explore,
    Icons.map_outlined,
    Icons.store_outlined,
    Icons.confirmation_number_outlined,
    Icons.business_outlined
  ];
  List<Guide> _guides = [];
  List<Destination> _destinations = [];
  bool _loading = true;
  bool _verifiedOnly = true;
  final _userPrefs = ['Adventure Travel', 'Mountain Trekking', 'Photography'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final supabase = Supabase.instance.client;
      final currentUser = context.read<RoleProvider>().currentUser;
      final userInterests = currentUser?.interests ?? [];

      final guideRes = await supabase
          .from('profiles')
          .select('*, guide_profiles(*)')
          .eq('role', 'guide')
          .eq('isVerified', true);

      final List<Guide> loadedGuides = (guideRes as List).map((e) {
        final dynamic gpData = e['guide_profiles'];
        final Map<String, dynamic> gp = (gpData is List && gpData.isNotEmpty)
            ? gpData.first
            : (gpData is Map<String, dynamic> ? gpData : {});

        String priceString = '₱₱';
        if (gp['price_min'] != null && gp['price_max'] != null) {
          priceString = '₱${gp['price_min']} - ₱${gp['price_max']} / hr';
        }

        // Calculate dynamic match score
        final guideSpecialties = List<String>.from(gp['specialties'] ?? []);
        int matchScore = 70; // default minimum for verified guides

        if (userInterests.isNotEmpty && guideSpecialties.isNotEmpty) {
          final common = userInterests
              .where((interest) => guideSpecialties.any((spec) =>
                  spec.toLowerCase().contains(interest.toLowerCase()) ||
                  interest.toLowerCase().contains(spec.toLowerCase())))
              .toList();

          if (common.isNotEmpty) {
            matchScore = ((common.length / userInterests.length) * 100).round();
            if (matchScore < 75) {
              matchScore = 75; // boost slightly for presentation
            }
            if (matchScore > 98) matchScore = 98; // keep it realistic
          }
        }

        return Guide(
          id: e['id'],
          name: e['name'] ?? 'Unknown Guide',
          city: e['location'] ?? 'Philippines',
          specialties: guideSpecialties,
          rating: (gp['rating'] ?? 5.0).toDouble(),
          tripCount: gp['tripCount'] ?? 0,
          bio: e['bio'] ?? 'Hello, I am a tour guide.',
          certifications: List<String>.from(gp['certifications'] ?? []),
          photoUrl: e['avatarUrl'] ??
              'https://picsum.photos/seed/${e['id']}/200/200',
          bannerUrl: gp['bannerUrl'] ??
              'https://picsum.photos/seed/banner_${e['id']}/400/200',
          isVerified: e['isVerified'] ?? false,
          languages: List<String>.from(e['languages'] ?? ['English']),
          priceRange: priceString,
          yearsExperience: gp['yearsExperience'] ?? 1,
          guideType: gp['guideType'] ?? 'community',
          communityArea: gp['communityArea'] ?? '',
          fullStory: gp['fullStory'] ?? '',
          acceptedPayments:
              List<String>.from(gp['acceptedPayments'] ?? ['Cash']),
          matchScore: matchScore,
        );
      }).toList();

      final mGuides = await MockData.getGuides();
      final allGuides = [...loadedGuides, ...mGuides];

      final d = await MockData.getDestinations();
      if (mounted) {
        setState(() {
          _guides = allGuides;
          _destinations = d;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading real guides: $e');
      final g = await MockData.getGuides();
      final d = await MockData.getDestinations();
      if (mounted) {
        setState(() {
          _guides = g;
          _destinations = d;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'Explore'),
      body: Column(children: [
        // Pill Tabs
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: List.generate(
                  _tabs.length,
                  (i) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: GestureDetector(
                          onTap: () => setState(() => _tabIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: _tabIndex == i
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                              border: Border.all(
                                color: _tabIndex == i
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),
                            child: Row(children: [
                              Icon(_tabIcons[i],
                                  size: 16,
                                  color: _tabIndex == i
                                      ? Colors.white
                                      : AppColors.textSecondary),
                              const SizedBox(width: AppSpacing.xs),
                              Text(_tabs[i],
                                  style: AppTheme.label(
                                      size: 13,
                                      color: _tabIndex == i
                                          ? Colors.white
                                          : AppColors.textSecondary)),
                            ]),
                          ),
                        ),
                      )),
            ),
          ),
        ),
        // Content
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : RefreshIndicator(
                  onRefresh: _load,
                  color: AppColors.primary,
                  child: _buildContent(),
                ),
        ),
      ]),
    );
  }

  Widget _buildContent() {
    switch (_tabIndex) {
      case 0:
        return _buildGuidesMatching();
      case 1:
        return _buildDestinations();
      case 2:
        return _buildPlaceholder('Marketplace', Icons.store_outlined,
            'Discover Mindanao-made products\ncoming soon');
      case 3:
        return _buildCrawlEvents();
      case 4:
        return _buildTourOperators();
      default:
        return _buildGuidesMatching();
    }
  }

  // GUIDES TAB
  Widget _buildGuidesMatching() {
    final matchProvider = context.watch<MatchProvider>();
    final sortedGuides = List<Guide>.from(_guides)
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.xs, AppSpacing.xl, 100),
      children: [
        // Verified toggle row
        Row(children: [
          Icon(Icons.verified_user_outlined,
              size: 18, color: AppColors.primary.withAlpha(178)),
          const SizedBox(width: AppSpacing.sm),
          Text('Verified Only', style: AppTheme.label(size: 14)),
          const Spacer(),
          Switch.adaptive(
            value: _verifiedOnly,
            onChanged: (v) => setState(() => _verifiedOnly = v),
            activeColor: AppColors.primary,
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        // Preference match banner
        KuyogCard(
          color: AppColors.primary.withAlpha(20),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.auto_awesome,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: Text('Matched to your preferences',
                      style: AppTheme.label(
                          size: 14, color: AppColors.primary))),
            ]),
            const SizedBox(height: AppSpacing.md),
            Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: _userPrefs
                    .map((p) => KuyogBadge(
                          label: p,
                          color: AppColors.primary,
                        ))
                    .toList()),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: () {},
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Update Preferences',
                    style: AppTheme.label(size: 13, color: AppColors.accent)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios,
                    size: 12, color: AppColors.accent),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Guide cards
        ...sortedGuides.map((guide) => _guideMatchCard(guide, matchProvider)),
      ],
    );
  }

  Widget _guideMatchCard(Guide guide, MatchProvider matchProvider) {
    final matchingPrefs =
        guide.specialties.where((s) => _userPrefs.contains(s)).toList();
    final isPending = matchProvider.hasRequestedMatch(guide.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: KuyogCard(
        padding: EdgeInsets.zero,
        child: Column(children: [
          // Photo
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(children: [
              CachedNetworkImage(
                imageUrl: guide.photoUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider),
                errorWidget: (c, u, e) => Container(
                  color: AppColors.primary.withAlpha(26),
                  child: const Center(
                      child: Icon(Icons.person,
                          size: 48, color: AppColors.primary)),
                ),
              ),
              // Match score badge
              Positioned(
                  top: 12,
                  right: 12,
                  child: KuyogBadge(
                    label: guide.matchScore >= 90
                        ? 'Perfect Match'
                        : '${guide.matchScore}% Match',
                    color: guide.matchScore >= 90
                        ? AppColors.primary
                        : AppColors.touristBlue,
                    icon: Icons.favorite,
                  )),
              // Guide type badge
              Positioned(
                  top: 12,
                  left: 12,
                  child: VerifiedContentBadge(
                    type: guide.guideType == 'regional'
                        ? BadgeType.regionalGuide
                        : BadgeType.communityGuide,
                    fontSize: 10,
                    compact: true,
                  )),
              // Verified chip
              if (guide.isVerified)
                Positioned(
                    bottom: 12,
                    left: 12,
                    child: KuyogBadge(
                      label: 'Verified Guide',
                      color: AppColors.verified,
                      icon: Icons.verified,
                    )),
            ]),
          ),
          // Info section
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + DOT badge
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(guide.name,
                              style: AppTheme.headline(size: 18)),
                          const SizedBox(height: 2),
                          Row(children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: AppColors.textLight),
                            const SizedBox(width: 2),
                            Expanded(
                                child: Text(guide.city,
                                    style: AppTheme.body(
                                        size: 13,
                                        color: AppColors.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                          ]),
                        ])),
                    if (guide.dotAccredited)
                      const VerifiedContentBadge(
                          type: BadgeType.dotAccredited,
                          fontSize: 10,
                          compact: true),
                  ]),
                  // Matching preferences
                  if (matchingPrefs.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: matchingPrefs
                            .map((p) => KuyogBadge(
                                  label: p,
                                  color: AppColors.primary,
                                  icon: Icons.check_circle,
                                ))
                            .toList()),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  // Rating + price row
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text('${guide.rating}', style: AppTheme.label(size: 14)),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                        child: Text('(${guide.tripCount} trips)',
                            style: AppTheme.body(
                                size: 12, color: AppColors.textLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis)),
                    Text(guide.priceRange,
                        style: AppTheme.label(
                            size: 16, color: AppColors.primary)),
                  ]),
                  // Action buttons
                  const SizedBox(height: AppSpacing.lg),
                  Row(children: [
                    Expanded(
                        child: KuyogButton(
                      label: 'View Profile',
                      variant: KuyogButtonVariant.outline,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  GuideProfileScreen(guide: guide))),
                    )),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                        child: KuyogButton(
                      label: isPending ? 'Pending' : 'Request Match',
                      variant: isPending
                          ? KuyogButtonVariant.outline
                          : KuyogButtonVariant.primary,
                      onPressed: isPending
                          ? null
                          : () {
                              _startTravelFlow(context, guide.id);
                            },
                    )),
                  ]),
                ]),
          ),
        ]),
      ),
    );
  }

  // DESTINATIONS TAB
  Widget _buildDestinations() {
    final filtered = _verifiedOnly
        ? _destinations.where((d) => d.lguEndorsed).toList()
        : _destinations;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.xs, AppSpacing.xl, 100),
      itemCount: filtered.length + 1,
      itemBuilder: (c, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(children: [
              Icon(Icons.verified_user_outlined,
                  size: 18, color: AppColors.primary.withAlpha(178)),
              const SizedBox(width: AppSpacing.sm),
              Text('LGU Endorsed Only', style: AppTheme.label(size: 14)),
              const Spacer(),
              Switch.adaptive(
                value: _verifiedOnly,
                onChanged: (v) => setState(() => _verifiedOnly = v),
                activeColor: AppColors.primary,
              ),
            ]),
          );
        }
        return _destCard(filtered[i - 1]);
      },
    );
  }

  Widget _destCard(Destination d) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: KuyogCard(
        onTap: () {},
        padding: EdgeInsets.zero,
        child: Row(children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppRadius.lg)),
            child: CachedNetworkImage(
              imageUrl: d.imageUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              placeholder: (c, u) =>
                  Container(width: 110, height: 110, color: AppColors.divider),
              errorWidget: (c, u, e) => Container(
                  width: 110,
                  height: 110,
                  color: AppColors.primary.withAlpha(26)),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.name,
                      style: AppTheme.label(size: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(d.province,
                      style: AppTheme.body(size: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.sm),
                  Row(children: [
                    KuyogBadge(label: d.category, color: AppColors.primary),
                    if (d.lguEndorsed) ...[
                      const SizedBox(width: AppSpacing.xs),
                      const VerifiedContentBadge(
                          type: BadgeType.lguEndorsed,
                          fontSize: 10,
                          compact: true),
                    ],
                  ]),
                  const SizedBox(height: AppSpacing.sm),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text('${d.rating}', style: AppTheme.label(size: 13)),
                    const Spacer(),
                    Text(d.region,
                        style: AppTheme.body(
                            size: 11, color: AppColors.textLight)),
                  ]),
                ]),
          )),
        ]),
      ),
    );
  }

  // CRAWL & EVENTS TAB
  Widget _buildCrawlEvents() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          KuyogCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            shape: BoxShape.circle,
            color: AppColors.accent.withAlpha(20),
            child: Icon(Icons.confirmation_number_outlined,
                size: 48, color: AppColors.accent.withAlpha(153)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Crawl & Events', style: AppTheme.headline(size: 22)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Food crawls, festivals & more',
            style: AppTheme.body(size: 15, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          KuyogButton(
            label: 'Enter Crawl Hub',
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CrawlHomeScreen())),
          ),
        ]),
      ),
    );
  }

  // TOUR OPERATORS TAB
  Widget _buildTourOperators() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 100),
      children: [
        const KuyogSectionHeader(
            title: 'Partner Tour Operators',
            subtitle: 'DOT-accredited operators promoting Mindanao tourism',
            padding: EdgeInsets.zero),
        const SizedBox(height: AppSpacing.lg),
        _operatorCard(
            'Mindanao Eco Adventures',
            'Davao City',
            12,
            4.8,
            156,
            ['Mountain', 'Eco-Tourism', 'Adventure'],
            'https://picsum.photos/seed/eco_adv/100/100'),
        _operatorCard(
            'Surallah Tours Inc.',
            'Koronadal City',
            8,
            4.6,
            89,
            ['Cultural', 'Indigenous', 'Lake Tours'],
            'https://picsum.photos/seed/surallah/100/100'),
        _operatorCard(
            'Northern Mindanao Expeditions',
            'Cagayan de Oro',
            15,
            4.7,
            234,
            ['Adventure', 'River Sports', 'Extreme'],
            'https://picsum.photos/seed/nme_logo/100/100'),
      ],
    );
  }

  Widget _operatorCard(
      String name,
      String location,
      int guides,
      double rating,
      int reviews,
      List<String> specialties,
      String logoUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: KuyogCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
                radius: 28,
                backgroundImage: CachedNetworkImageProvider(logoUrl)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(name, style: AppTheme.headline(size: 16)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(location,
                            style: AppTheme.body(
                                size: 13, color: AppColors.textSecondary))),
                  ]),
                ])),
          ]),
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            const VerifiedContentBadge(
                type: BadgeType.dotAccredited, fontSize: 10, compact: true),
            const SizedBox(width: AppSpacing.sm),
            const VerifiedContentBadge(
                type: BadgeType.businessPermit, fontSize: 10, compact: true),
          ]),
          const SizedBox(height: AppSpacing.md),
          Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: specialties
                  .map((s) => KuyogBadge(
                        label: s,
                        color: AppColors.primary,
                      ))
                  .toList()),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.people_outline,
                    size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('$guides guides',
                    style: AppTheme.body(
                        size: 13, color: AppColors.textSecondary)),
                const SizedBox(width: AppSpacing.md),
                const Icon(Icons.star_rounded,
                    size: 18, color: AppColors.warning),
                const SizedBox(width: 4),
                Text('$rating', style: AppTheme.label(size: 14)),
                Text(' ($reviews)',
                    style: AppTheme.body(size: 12, color: AppColors.textLight)),
              ]),
              KuyogButton(
                label: 'Packages',
                variant: KuyogButtonVariant.outline,
                onPressed: () {},
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  // SHARED HELPERS
  Widget _buildPlaceholder(String title, IconData icon, String desc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          KuyogCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            shape: BoxShape.circle,
            color: AppColors.primary.withAlpha(20),
            child: Icon(icon,
                size: 48, color: AppColors.primary.withAlpha(128)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(title, style: AppTheme.headline(size: 22)),
          const SizedBox(height: AppSpacing.xs),
          Text(desc,
              style: AppTheme.body(size: 15, color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  void _startTravelFlow(BuildContext context, String guideId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TravelTypeScreen(
          onContinue: (travelType, guideType) {
            final provider = context.read<TravelProvider>();
            provider.selectGuide(guideId);
            if (provider.travelType == 'group') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupSetupScreen(
                      onContinue: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AIMatchingScreen(
                                  nextRoute: 'explore_tab'),
                            ));
                      },
                    ),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AIMatchingScreen(nextRoute: 'explore_tab'),
                  ));
            }
          },
        ),
      ),
    );
  }
}


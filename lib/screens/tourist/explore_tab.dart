import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/guide.dart';
import '../../models/destination.dart';
import '../../providers/match_provider.dart';
import '../../widgets/verified_badge.dart';
import '../../widgets/verified_content_badge.dart';
import '../../widgets/kuyog_app_bar.dart';
import 'guide_profile_screen.dart';
import '../features/crawl/crawl_home_screen.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});
  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _tabIndex = 0;
  final _tabs = ['Guides', 'Destinations', 'Marketplace', 'Crawl & Events', 'Tour Operators'];
  final _tabIcons = [Icons.explore, Icons.map_outlined, Icons.store_outlined, Icons.confirmation_number_outlined, Icons.business_outlined];
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
    final g = await MockData.getGuides();
    final d = await MockData.getDestinations();
    if (mounted) setState(() { _guides = g; _destinations = d; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'Explore'),
      body: Column(children: [
        // ── Category tabs ──
        Container(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          color: AppColors.background,
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tabs.length,
              itemBuilder: (c, i) {
                final selected = _tabIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.divider,
                          width: 1,
                        ),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_tabIcons[i], size: 16, color: selected ? Colors.white : AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(_tabs[i], style: AppTheme.label(size: 13, color: selected ? Colors.white : AppColors.textSecondary)),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // ── Content ──
        Expanded(
          child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _buildContent(),
        ),
      ]),
    );
  }

  Widget _buildContent() {
    switch (_tabIndex) {
      case 0: return _buildGuidesMatching();
      case 1: return _buildDestinations();
      case 2: return _buildPlaceholder('Marketplace', Icons.store_outlined, 'Discover Mindanao-made products\ncoming soon');
      case 3: return _buildCrawlEvents();
      case 4: return _buildTourOperators();
      default: return _buildGuidesMatching();
    }
  }

  // ══════════════════════════════════════════════
  // GUIDES TAB
  // ══════════════════════════════════════════════

  Widget _buildGuidesMatching() {
    final matchProvider = context.watch<MatchProvider>();
    final sortedGuides = List<Guide>.from(_guides)..sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        // Verified toggle row
        Row(children: [
          Icon(Icons.verified_user_outlined, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Text('Verified Only', style: AppTheme.label(size: 14)),
          const Spacer(),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: _verifiedOnly,
              onChanged: (v) => setState(() => _verifiedOnly = v),
              activeColor: AppColors.primary,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        // Preference match banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text('Matched to your preferences', style: AppTheme.label(size: 14, color: AppColors.primary))),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: _userPrefs.map((p) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(p, style: AppTheme.label(size: 12, color: AppColors.primary)),
            )).toList()),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {},
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Update Preferences', style: AppTheme.label(size: 13, color: AppColors.accent)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.accent),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        // Guide cards
        ...sortedGuides.map((guide) => _guideMatchCard(guide, matchProvider)),
      ],
    );
  }

  Widget _guideMatchCard(Guide guide, MatchProvider matchProvider) {
    final matchingPrefs = guide.specialties.where((s) => _userPrefs.contains(s)).toList();
    final isPending = matchProvider.hasRequestedMatch(guide.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        // Photo
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(children: [
            CachedNetworkImage(
              imageUrl: guide.photoUrl, width: double.infinity, height: 180, fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.divider),
              errorWidget: (c, u, e) => Container(
                color: AppColors.primary.withValues(alpha: 0.15),
                child: const Center(child: Icon(Icons.person, size: 48, color: AppColors.primary)),
              ),
            ),
            // Gradient overlay
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.45)],
                stops: const [0.4, 1.0],
              ),
            ))),
            // Match score badge
            Positioned(top: 12, right: 12, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: guide.matchScore >= 90 ? AppColors.primary : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.favorite, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  guide.matchScore >= 90 ? 'Perfect Match' : '${guide.matchScore}%',
                  style: AppTheme.label(size: 12, color: Colors.white),
                ),
              ]),
            )),
            // Guide type badge
            Positioned(top: 12, left: 12, child: VerifiedContentBadge(
              type: guide.guideType == 'regional' ? BadgeType.regionalGuide : BadgeType.communityGuide,
              fontSize: 10, compact: true,
            )),
            // Verified chip
            if (guide.isVerified)
              Positioned(bottom: 12, left: 12, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.verified, size: 14, color: AppColors.verified),
                  const SizedBox(width: 4),
                  Text('Verified Guide', style: AppTheme.label(size: 11, color: AppColors.verified)),
                ]),
              )),
          ]),
        ),
        // Info section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Name + DOT badge
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(guide.name, style: AppTheme.headline(size: 18)),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                  const SizedBox(width: 2),
                  Text(guide.city, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                ]),
              ])),
              if (guide.dotAccredited)
                const VerifiedContentBadge(type: BadgeType.dotAccredited, fontSize: 10, compact: true),
            ]),
            // Matching preferences
            if (matchingPrefs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 6, runSpacing: 6, children: matchingPrefs.map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_circle, size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(p, style: AppTheme.body(size: 12, color: AppColors.primary)),
                ]),
              )).toList()),
            ],
            // Story excerpt
            if (guide.storyExcerpt.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '"${guide.storyExcerpt}"',
                style: AppTheme.body(size: 13, color: AppColors.textSecondary).copyWith(fontStyle: FontStyle.italic),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            // Rating + price row
            Row(children: [
              const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
              const SizedBox(width: 2),
              Text('${guide.rating}', style: AppTheme.label(size: 14)),
              const SizedBox(width: 4),
              Text('(${guide.tripCount} trips)', style: AppTheme.body(size: 12, color: AppColors.textLight)),
              const Spacer(),
              Text(guide.priceRange, style: AppTheme.label(size: 16, color: AppColors.primary)),
            ]),
            const SizedBox(height: 4),
            Text('Speaks: ${guide.languages.join(", ")}', style: AppTheme.body(size: 12, color: AppColors.textLight)),
            // Payment methods
            if (guide.acceptedPayments.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: guide.acceptedPayments.take(3).map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _paymentColor(p).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(p, style: AppTheme.body(size: 11, color: _paymentColor(p))),
              )).toList()),
            ],
            // Action buttons
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideProfileScreen(guide: guide))),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child: Text('View Profile', style: AppTheme.label(size: 14, color: AppColors.primary)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: isPending ? null : () {
                  matchProvider.sendMatchRequest(guide.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Match request sent to ${guide.name}!', style: AppTheme.body(size: 14, color: Colors.white)),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPending ? AppColors.textLight : AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(isPending ? 'Pending' : 'Request Match', style: AppTheme.label(size: 14, color: Colors.white)),
              )),
            ]),
          ]),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════
  // DESTINATIONS TAB
  // ══════════════════════════════════════════════

  Widget _buildDestinations() {
    final filtered = _verifiedOnly ? _destinations.where((d) => d.lguEndorsed).toList() : _destinations;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: filtered.length + 1, // +1 for the toggle header
      itemBuilder: (c, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(children: [
              Icon(Icons.verified_user_outlined, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text('LGU Endorsed Only', style: AppTheme.label(size: 14)),
              const Spacer(),
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: _verifiedOnly,
                  onChanged: (v) => setState(() => _verifiedOnly = v),
                  activeColor: AppColors.primary,
                ),
              ),
            ]),
          );
        }
        return _destCard(filtered[i - 1]);
      },
    );
  }

  Widget _destCard(Destination d) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.lg)),
            child: CachedNetworkImage(
              imageUrl: d.imageUrl, width: 110, height: 110, fit: BoxFit.cover,
              placeholder: (c, u) => Container(width: 110, height: 110, color: AppColors.divider),
              errorWidget: (c, u, e) => Container(width: 110, height: 110, color: AppColors.primaryLight.withValues(alpha: 0.15)),
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.name, style: AppTheme.label(size: 15)),
              const SizedBox(height: 2),
              Text(d.province, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(d.category, style: AppTheme.body(size: 11, color: AppColors.primary)),
                ),
                if (d.lguEndorsed) ...[
                  const SizedBox(width: 6),
                  const VerifiedContentBadge(type: BadgeType.lguEndorsed, fontSize: 10, compact: true),
                ],
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                const SizedBox(width: 2),
                Text('${d.rating}', style: AppTheme.label(size: 13)),
                const Spacer(),
                Text(d.region, style: AppTheme.body(size: 11, color: AppColors.textLight)),
              ]),
            ]),
          )),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // CRAWL & EVENTS TAB
  // ══════════════════════════════════════════════

  Widget _buildCrawlEvents() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.confirmation_number_outlined, size: 48, color: AppColors.accent.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          Text('Crawl & Events', style: AppTheme.headline(size: 22)),
          const SizedBox(height: 8),
          Text(
            'Food crawls, festivals & more',
            style: AppTheme.body(size: 15, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CrawlHomeScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('Enter Crawl Hub', style: AppTheme.label(size: 15, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // TOUR OPERATORS TAB
  // ══════════════════════════════════════════════

  Widget _buildTourOperators() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        Text('Partner Tour Operators', style: AppTheme.headline(size: 18)),
        const SizedBox(height: 4),
        Text('DOT-accredited operators promoting Mindanao tourism', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        _operatorCard('Mindanao Eco Adventures', 'Davao City', 12, 4.8, 156, ['Mountain', 'Eco-Tourism', 'Adventure'], 'https://picsum.photos/seed/eco_adv/100/100'),
        _operatorCard('Surallah Tours Inc.', 'Koronadal City', 8, 4.6, 89, ['Cultural', 'Indigenous', 'Lake Tours'], 'https://picsum.photos/seed/surallah/100/100'),
        _operatorCard('Northern Mindanao Expeditions', 'Cagayan de Oro', 15, 4.7, 234, ['Adventure', 'River Sports', 'Extreme'], 'https://picsum.photos/seed/nme_logo/100/100'),
      ],
    );
  }

  Widget _operatorCard(String name, String location, int guides, double rating, int reviews, List<String> specialties, String logoUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 24, backgroundImage: CachedNetworkImageProvider(logoUrl)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.label(size: 15)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
              const SizedBox(width: 2),
              Text(location, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
            ]),
          ])),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const VerifiedContentBadge(type: BadgeType.dotAccredited, fontSize: 10, compact: true),
          const SizedBox(width: 6),
          const VerifiedContentBadge(type: BadgeType.businessPermit, fontSize: 10, compact: true),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: specialties.map((s) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(s, style: AppTheme.body(size: 12, color: AppColors.accent)),
        )).toList()),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text('$guides guides', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
          const SizedBox(width: 16),
          const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
          const SizedBox(width: 2),
          Text('$rating ($reviews)', style: AppTheme.label(size: 13)),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('View Packages', style: AppTheme.label(size: 12, color: AppColors.primary)),
          ),
        ]),
      ]),
    );
  }

  // ══════════════════════════════════════════════
  // SHARED HELPERS
  // ══════════════════════════════════════════════

  Widget _buildPlaceholder(String title, IconData icon, String desc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text(title, style: AppTheme.headline(size: 22)),
          const SizedBox(height: 8),
          Text(desc, style: AppTheme.body(size: 15, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
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
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/event.dart';
import '../../../models/crawl_route.dart';
import '../../../models/madayaw_season.dart';
import '../../../providers/crawl_provider.dart';
import '../../../widgets/crawl/durie_passport.dart';
import 'crawl_spot_detail_screen.dart';
import '../../shared/storyhub_tab.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../../../widgets/core/kuyog_card.dart';
import '../../../widgets/core/kuyog_badge.dart';
import '../../../widgets/core/kuyog_section_header.dart';
import '../../../widgets/durie_mascot.dart';
import 'package:shimmer/shimmer.dart';

class CrawlHomeScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const CrawlHomeScreen({super.key, this.onBack});

  @override
  State<CrawlHomeScreen> createState() => _CrawlHomeScreenState();
}

class _CrawlHomeScreenState extends State<CrawlHomeScreen> {
  int _tabIndex = 0;
  final List<String> _tabNames = ['Solo Crawl', 'Guide-Led'];
  final List<IconData> _tabIcons = [
    Icons.person_outline,
    Icons.groups_outlined
  ];
  List<CrawlEvent> _events = [];
  List<CrawlRoute> _routes = [];
  List<MadayawSeason> _seasons = [];
  List<Map<String, dynamic>> _merch = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ev = await MockData.getEvents();
    final rt = await MockData.getCrawlRoutes();
    final mc = await MockData.getCrawlMerch();
    final seasons = await MockData.getMadayawSeasons();
    if (mounted) {
      setState(() {
        _events = ev;
        _routes = rt;
        _merch = mc;
        _seasons = seasons;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(
        title: 'Madayaw Crawl',
        leading: widget.onBack != null
            ? Center(child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack))
            : null,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppColors.accent))
          : Column(
              children: [
                // Spacing and Tabs consistent with StoryHub
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl, vertical: 12),
                  child: Row(
                    children: List.generate(_tabNames.length, (i) {
                      final selected = _tabIndex == i;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: i != _tabNames.length - 1 ? 8 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _tabIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    selected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.divider,
                                    width: 1.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(_tabIcons[i],
                                      size: 16,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text(_tabNames[i],
                                      style: AppTheme.body(
                                          size: 13,
                                          weight: FontWeight.w600,
                                          color: selected
                                              ? Colors.white
                                              : AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Consumer<CrawlProvider>(
                    builder: (context, crawl, child) {
                      return _tabIndex == 0
                          ? _buildSoloCrawlTab(crawl)
                          : _buildGuideLedTab();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSoloCrawlTab(CrawlProvider crawl) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DuriePassport(
            touristName: 'Maria Santos',
            passportNumber: '1234567',
            stampsCount: crawl.stampCount,
            totalStamps: 8,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildMerchSection(),
          const SizedBox(height: AppSpacing.xl),
          _buildExploreMerchCard(),
          const SizedBox(height: AppSpacing.xxl),
          _buildFindingDurieSection(),
          const SizedBox(height: AppSpacing.xxl),
          const KuyogSectionHeader(title: 'Madayaw Seasons', padding: EdgeInsets.zero),
          const SizedBox(height: AppSpacing.md),
          ..._seasons.map((s) => _seasonCard(s)),
          const SizedBox(height: AppSpacing.xxl),
          const KuyogSectionHeader(title: 'Active Crawl Events', padding: EdgeInsets.zero),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemCount: _events.length,
            itemBuilder: (context, index) => _eventCard(_events[index]),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildStoryHubConnection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildGuideLedTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KuyogSectionHeader(
            title: 'Explore with a Guide',
            subtitle: 'Join curated routes led by verified local guides.',
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemCount: _routes.length,
            itemBuilder: (context, index) => _routeCard(_routes[index]),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildStoryHubConnection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMerchSection() {
    final displayMerch = [
      {
        'name': 'Durie Plushie — Season Edition',
        'price': '850',
        'photo_url': 'https://picsum.photos/seed/plushie/300/200',
        'limited': true
      },
      {
        'name': 'Davao Crawl Tote Bag',
        'price': '350',
        'photo_url': 'https://picsum.photos/seed/totebag/300/200',
        'limited': true
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KuyogSectionHeader(
          title: 'Season Exclusive Merch',
          subtitle: 'Collect limited crawl souvenirs before they run out.',
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _merchCard(displayMerch[0])),
            const SizedBox(width: 10),
            Expanded(child: _merchCard(displayMerch[1])),
          ],
        ),
      ],
    );
  }

  Widget _merchCard(Map<String, dynamic> item) {
    return SizedBox(
      height: 270,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Area
                CachedNetworkImage(
                  imageUrl: item['photo_url']!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(height: 120, color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                      height: 120, color: Colors.grey[200], child: const Icon(Icons.error)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₱${item['price']}',
                        style: GoogleFonts.baloo2(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3A7D44)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: SizedBox(
                    height: 36,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A7D44),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: GoogleFonts.nunito(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // LIMITED badge
            if (item['limited'] == true)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'LIMITED',
                    style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            // Heart Icon
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_border,
                    size: 16, color: Color(0xFF6B7280)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindingDurieSection() {
    return GestureDetector(
      onTap: () {
        if (_events.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CrawlSpotDetailScreen(event: _events.first)));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.accent.withAlpha(20),
          border: Border.all(color: AppColors.accent.withAlpha(51)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            _PeekingDurie(),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Where is Durie?',
                          style: AppTheme.headline(size: 16, color: AppColors.accent)),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.location_searching,
                          size: 16, color: AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Find Durie at a mystery spot and earn 300 bonus Miles!',
                      style: AppTheme.body(
                          size: 12, color: AppColors.accent.withAlpha(204))),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Start Searching',
                      style: AppTheme.label(
                          size: 14, color: AppColors.accent, weight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventCard(CrawlEvent e) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(25),
        border: Border.all(color: AppColors.primary.withAlpha(51), width: 1.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Circular Image Area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: e.imageUrl,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider),
                errorWidget: (c, u, er) => Container(color: AppColors.divider, child: const Icon(Icons.event)),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              e.name,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  e.location,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary.withAlpha(204),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Category
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category_outlined, size: 12, color: AppColors.primary.withAlpha(153)),
              const SizedBox(width: 4),
              Text(
                e.category, 
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  color: AppColors.primary.withAlpha(204),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CrawlSpotDetailScreen(event: e))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Show details',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seasonCard(MadayawSeason s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: KuyogCard(
        padding: EdgeInsets.zero,
        border: s.isActive ? Border.all(color: s.primaryColor, width: 2) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: s.primaryColor.withAlpha(25),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
              ),
              child: Center(
                  child: Text(s.month,
                      style: AppTheme.headline(size: 24, color: s.primaryColor))),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.name, style: AppTheme.headline(size: 18)),
                      if (s.isActive)
                        const KuyogBadge(label: 'ACTIVE', color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(s.description,
                      style: AppTheme.body(
                          size: 13, color: AppColors.primary.withAlpha(153))),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('Earn ${s.minStampsForReward * 100} Points',
                          style: AppTheme.label(size: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeCard(CrawlRoute r) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(25),
        border: Border.all(color: AppColors.primary.withAlpha(51), width: 1.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Circular Image Area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: r.photoUrl,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.primary.withAlpha(51)),
                errorWidget: (c, u, er) => Container(color: AppColors.primary.withAlpha(51), child: const Icon(Icons.map)),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              r.name,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Davao Region',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary.withAlpha(204),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Stops / Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month_outlined, size: 12, color: AppColors.primary.withAlpha(153)),
              const SizedBox(width: 4),
              Text(
                '${r.stopsCount} stops', 
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  color: AppColors.primary.withAlpha(204),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Show details',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconDetail(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(label,
            style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildExploreMerchCard() {
    return GestureDetector(
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
                  label: 'OFFICIAL GEAR',
                  color: AppColors.primary.withAlpha(38),
                  labelColor: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Kuyog Official Gear',
                    style:
                        AppTheme.headline(size: 20, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('Get exclusive souvenirs and travel essentials.',
                    style: AppTheme.body(
                        size: 13,
                        color: AppColors.primary.withAlpha(204))),
              ])),
          const SizedBox(width: AppSpacing.md),
          const DurieMascot(size: 64),
        ]),
      ),
    );
  }

  Widget _buildStoryHubConnection() {
    return KuyogCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => StoryhubTab(tagFilter: '#MadayawCrawl')),
        );
      },
      color: AppColors.primary.withAlpha(20),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Icon(Icons.auto_stories, color: AppColors.primary, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('See Crawl Stories', style: AppTheme.headline(size: 16)),
                Text('Read travel stories from fellow crawlers.',
                    style: AppTheme.body(
                        size: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _PeekingDurie extends StatefulWidget {
  @override
  State<_PeekingDurie> createState() => _PeekingDurieState();
}

class _PeekingDurieState extends State<_PeekingDurie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(38), shape: BoxShape.circle),
            child: const Icon(Icons.face,
                size: 40, color: AppColors.accent), // Placeholder for Durie mascot
          ),
        );
      },
    );
  }
}


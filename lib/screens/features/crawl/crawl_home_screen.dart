import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/event.dart';
import '../../../models/crawl_route.dart';
import '../../../providers/crawl_provider.dart';
import '../../../widgets/crawl/durie_passport.dart';
import 'crawl_spot_detail_screen.dart';
import 'finding_durie_celebration.dart';
import '../../shared/storyhub_tab.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../../../widgets/kuyog_back_button.dart';

class CrawlHomeScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const CrawlHomeScreen({super.key, this.onBack});

  @override
  State<CrawlHomeScreen> createState() => _CrawlHomeScreenState();
}

class _CrawlHomeScreenState extends State<CrawlHomeScreen> {
  int _tabIndex = 0;
  final List<String> _tabNames = ['Solo Crawl', 'Guide-Led'];
  final List<IconData> _tabIcons = [Icons.person_outline, Icons.groups_outlined];
  List<CrawlEvent> _events = [];
  List<CrawlRoute> _routes = [];
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
    if (mounted) {
      setState(() {
        _events = ev;
        _routes = rt;
        _merch = mc;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(
        title: 'Mindanao Crawl',
        leading: widget.onBack != null ? KuyogBackButton(onTap: widget.onBack) : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tabNames.length,
              itemBuilder: (c, i) {
                final selected = _tabIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.divider,
                          width: 1,
                        ),
                        boxShadow: selected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_tabIcons[i], size: 18, color: selected ? Colors.white : AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(_tabNames[i], style: AppTheme.label(size: 14, color: selected ? Colors.white : AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : Consumer<CrawlProvider>(
              builder: (context, crawl, child) {
                return _tabIndex == 0 ? _buildSoloCrawlTab(crawl) : _buildGuideLedTab();
              },
            ),
    );
  }

  Widget _buildSoloCrawlTab(CrawlProvider crawl) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DuriePassport(
            touristName: 'Maria Santos',
            passportNumber: '1234567',
            stampsCount: crawl.stampCount,
            totalStamps: 8,
          ),
          const SizedBox(height: 24),
          _buildMerchSection(),
          const SizedBox(height: 16),
          _buildExploreMerchCard(),
          const SizedBox(height: 24),
          _buildFindingDurieSection(),
          const SizedBox(height: 24),
          Text('Active Crawl Events', style: AppTheme.headline(size: 18)),
          const SizedBox(height: 16),
          ..._events.map((e) => _eventCard(e)),
          const SizedBox(height: 24),
          _buildStoryHubConnection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildGuideLedTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Explore with a Guide'),
          Text('Join curated routes led by verified local guides.', 
            style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ..._routes.map((r) => _routeCard(r)),
          const SizedBox(height: 24),
          _buildStoryHubConnection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: AppTheme.headline(size: 18));
  }

  Widget _buildMerchSection() {
    final displayMerch = _merch.isNotEmpty ? _merch : [
      {'name': 'Kuyog Travel Tee', 'price': '450', 'photo_url': 'https://picsum.photos/seed/tee/200/200', 'limited': true},
      {'name': 'Adventure Hat', 'price': '350', 'photo_url': 'https://picsum.photos/seed/hat/200/200', 'limited': false},
      {'name': 'Sticker Pack', 'price': '100', 'photo_url': 'https://picsum.photos/seed/stickers/200/200', 'limited': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Season Exclusive Merch', style: AppTheme.headline(size: 18)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text('LIMITED', style: AppTheme.label(size: 10, color: AppColors.accent)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayMerch.length,
            itemBuilder: (context, index) {
              final item = displayMerch[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                          child: CachedNetworkImage(
                            imageUrl: item['photo_url'],
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: AppColors.background),
                            errorWidget: (context, url, error) => Container(color: AppColors.divider, child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textLight)),
                          ),
                        ),
                        if (item['limited'] == true)
                          Positioned(
                            top: 8,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              color: Colors.red,
                              child: const Text('LIMITED', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'], style: AppTheme.label(size: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('₱${item['price']}', style: AppTheme.label(size: 14, color: AppColors.primary)),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: const Text('Add to Cart', style: TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFindingDurieSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE8872A), Color(0xFFF1B06F)]),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          _PeekingDurie(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Where is Durie?', style: AppTheme.headline(size: 16, color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_searching, size: 16, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Find Durie at a mystery spot and earn 300 bonus Miles!', 
                  style: AppTheme.body(size: 12, color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to first active event spots
                    if (_events.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CrawlSpotDetailScreen(event: _events.first)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                  ),
                  child: const Text('Start Searching'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(CrawlEvent e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            child: CachedNetworkImage(
              imageUrl: e.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.background),
              errorWidget: (context, url, error) => Container(color: AppColors.divider, child: const Icon(Icons.event_available, color: AppColors.textLight, size: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text(e.category, style: AppTheme.label(size: 11, color: AppColors.primary)),
                    ),
                    const Spacer(),
                    Icon(Icons.place, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(e.location, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(e.name, style: AppTheme.headline(size: 18)),
                const SizedBox(height: 4),
                Text(e.description, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CrawlSpotDetailScreen(event: e))),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('View Spots', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeCard(CrawlRoute r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                child: CachedNetworkImage(
                  imageUrl: r.photoUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.background),
                  errorWidget: (context, url, error) => Container(color: AppColors.divider, child: const Icon(Icons.map_outlined, color: AppColors.textLight, size: 48)),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                  child: Row(
                    children: [
                      const Icon(Icons.group, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('Guide-Led', style: AppTheme.label(size: 10, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name, style: AppTheme.headline(size: 18)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(radius: 12, backgroundColor: AppColors.divider),
                    const SizedBox(width: 8),
                    Text('Local Guide', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('4.9', style: AppTheme.label(size: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconDetail(Icons.map_outlined, '${r.stopsCount} stops'),
                    _iconDetail(Icons.schedule, '${r.durationHours}h'),
                    _iconDetail(Icons.star_rounded, '${r.milesEarned} Miles'),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₱${r.pricePerPerson}', style: AppTheme.headline(size: 20, color: AppColors.primary)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                      child: const Text('Join Route', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
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
        Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildExploreMerchCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF9), // Very light green background
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/kuyog_bag/200/200',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.background),
                errorWidget: (context, url, error) => const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kuyog Official Gear', style: AppTheme.headline(size: 16)),
                const SizedBox(height: 4),
                Text('Get exclusive souvenirs and travel essentials.', 
                  style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Explore Kuyog Merch', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryHubConnection() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoryhubTab(tagFilter: '#MindanaoCrawl')),
        );
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7F0),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_stories, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('See Crawl Stories', style: AppTheme.headline(size: 16)),
                  Text('Read travel stories from fellow crawlers.', 
                    style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _PeekingDurie extends StatefulWidget {
  @override
  State<_PeekingDurie> createState() => _PeekingDurieState();
}

class _PeekingDurieState extends State<_PeekingDurie> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: const Icon(Icons.face, size: 40, color: Colors.white), // Placeholder for Durie mascot
          ),
        );
      },
    );
  }
}

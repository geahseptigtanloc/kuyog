import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/guide.dart';
import '../../models/destination.dart';
import '../../providers/role_provider.dart';
import '../../providers/crawl_provider.dart';
import '../../providers/miles_provider.dart';
import '../../widgets/guide_card.dart';
import '../../widgets/destination_card.dart';
import '../../widgets/durie_mascot.dart';
import '../../widgets/durie_loading.dart';
import '../features/marketplace/marketplace_home_screen.dart';
import '../features/crawl/crawl_home_screen.dart';
import '../features/help/sos_helpdesk_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/cultural/cultural_guide_screen.dart';
import '../features/miles/miles_dashboard_screen.dart';
import '../shared/chat/chat_list_screen.dart';
import '../../widgets/kuyog_app_bar.dart';
import 'search_screen.dart';
import 'guide_profile_screen.dart';

class TouristHomeTab extends StatefulWidget {
  const TouristHomeTab({super.key});
  @override
  State<TouristHomeTab> createState() => _TouristHomeTabState();
}

class _TouristHomeTabState extends State<TouristHomeTab> {
  List<Guide> _guides = [];
  List<Destination> _destinations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final g = await MockData.getGuides();
    final d = await MockData.getDestinations();
    if (mounted) setState(() { _guides = g; _destinations = d; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>();
    final crawl = context.watch<CrawlProvider>();
    final miles = context.watch<MilesProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(title: role.greeting),
      body: SafeArea(
        child: _loading
            ? const DurieLoading()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHero(),
                    const SizedBox(height: 24),
                    _padded(Text('What would you like to do?', style: AppTheme.headline(size: 18))),
                    const SizedBox(height: 12),
                    _padded(_buildQuickActions()),
                    const SizedBox(height: 24),
                    _buildMilesCard(miles),
                    const SizedBox(height: 24),
                    _buildCtaCard(),
                    const SizedBox(height: 28),
                    _sectionHeader('Featured Tour Guides', 'See All'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: _guides.length,
                        itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => GuideProfileScreen(guide: _guides[i]),
                            )),
                            child: GuideCard(guide: _guides[i]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _sectionHeader('Explore Mindanao', 'See All'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20),
                        itemCount: _destinations.length,
                        itemBuilder: (c, i) => DestinationCard(destination: _destinations[i]),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildCrawlBanner(crawl),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _padded(Widget child) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: child);





  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        child: Stack(children: [
          CachedNetworkImage(
            imageUrl: 'https://picsum.photos/seed/davao_hero2/800/400', height: 190, width: double.infinity, fit: BoxFit.cover,
            placeholder: (c, u) => Container(height: 190, color: AppColors.divider),
            errorWidget: (c, u, e) => Container(height: 190, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]))),
          ),
          Positioned.fill(child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)])),
          )),
          Positioned(top: 16, left: 16, right: 16, child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Row(children: [
                const Icon(Icons.search, color: AppColors.textLight, size: 20),
                const SizedBox(width: 10),
                Text('Where do you want to go?', style: AppTheme.body(size: 14, color: AppColors.textLight)),
              ]),
            ),
          )),
        ]),
      ),
    );
  }

  Widget _buildQuickActions() {
    final items = [
      ('Services', Icons.miscellaneous_services_rounded, AppColors.primary),
      ('Citizen Guide', Icons.menu_book_rounded, AppColors.touristBlue),
      ('E-Services', Icons.phone_android_rounded, AppColors.adminPurple),
      ('Emergency', Icons.emergency_rounded, AppColors.error),
      ('Utilities', Icons.electrical_services_rounded, AppColors.warning),
      ('Transport', Icons.directions_bus_rounded, const Color(0xFF0891B2)),
      ('Marketplace', Icons.store_rounded, AppColors.accent),
      ('View More', Icons.grid_view_rounded, AppColors.textSecondary),
    ];
    return GridView.count(
      crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12, crossAxisSpacing: 8, childAspectRatio: 0.8,
      children: items.map((a) => GestureDetector(
        onTap: () => _handleQuickAction(a.$1),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: a.$3.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Icon(a.$2, color: a.$3, size: 24)),
          const SizedBox(height: 6),
          Text(a.$1, style: AppTheme.label(size: 10), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      )).toList(),
    );
  }

  void _handleQuickAction(String label) {
    switch (label) {
      case 'Marketplace':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceHomeScreen()));
      case 'Citizen Guide':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CulturalGuideScreen()));
      case 'Emergency':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SosHelpdeskScreen()));
      case 'Services':
        _showInfoSheet('Services', [
          ('Tour Booking', Icons.calendar_today, 'Book tours with verified guides'),
          ('Transportation', Icons.directions_car, 'Habal-habal, taxi, bus routes'),
          ('Accommodation', Icons.hotel, 'Find lodging and homestays'),
          ('Activities', Icons.surfing, 'Water sports, trekking, diving'),
          ('Emergency Services', Icons.local_hospital, 'Hospitals, police, fire'),
        ]);
      case 'E-Services':
        _showInfoSheet('E-Services', [
          ('DOT Online Portal', Icons.language, 'Department of Tourism portal'),
          ('LGU Tourism Office', Icons.business, 'Local government tourism'),
          ('Tourist Hotlines', Icons.phone, '1-555-TOUR (mock)'),
        ]);
      case 'Utilities':
        _showInfoSheet('Utilities', [
          ('Currency Converter', Icons.currency_exchange, '1 USD = 56.50 PHP'),
          ('Weather', Icons.cloud, 'Davao: 31C, Partly Cloudy'),
          ('Local Time', Icons.access_time, 'Philippine Standard Time (UTC+8)'),
          ('Contacts', Icons.contacts, 'Emergency & utility numbers'),
        ]);
      case 'Transport':
        _showInfoSheet('Transport Options', [
          ('Habal-habal', Icons.two_wheeler, 'P50-150 per ride'),
          ('E-Trike', Icons.electric_rickshaw, 'P30-80 per ride'),
          ('Taxi / Grab', Icons.local_taxi, 'P100-500, metered'),
          ('Bus Routes', Icons.directions_bus, 'Davao-GenSan, Davao-Cagayan'),
        ]);
      case 'View More':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('More services coming soon!', style: AppTheme.body(size: 14, color: Colors.white)), backgroundColor: AppColors.primary),
        );
    }
  }

  void _showInfoSheet(String title, List<(String, IconData, String)> items) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(title, style: AppTheme.headline(size: 20)),
            const SizedBox(height: 16),
            ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
                  child: Icon(item.$2, size: 22, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.$1, style: AppTheme.label(size: 14)),
                  Text(item.$3, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                ])),
              ]),
            )),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  Widget _buildMilesCard(MilesProvider miles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MilesDashboardScreen())),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight]),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          child: Row(children: [
            const DurieMascot(size: 50),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${miles.balance}', style: AppTheme.headline(size: 32, color: Colors.white)),
              Text('Kuyog Miles', style: AppTheme.label(size: 14, color: Colors.white.withValues(alpha: 0.85))),
              const SizedBox(height: 4),
              Text('Redeem rewards  \u2192', style: AppTheme.body(size: 12, color: Colors.white.withValues(alpha: 0.7))),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _buildCtaCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Switch to itinerary tab (index 3 for tourist)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to Itinerary tab...', style: AppTheme.body(size: 14, color: Colors.white)), backgroundColor: AppColors.primary, duration: const Duration(seconds: 1)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.primary]), borderRadius: BorderRadius.circular(AppRadius.xxl)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Create Itinerary', style: AppTheme.headline(size: 20, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Co-create customized itineraries with your guide!', style: AppTheme.body(size: 12, color: Colors.white70)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text('Start Creating', style: AppTheme.label(size: 13, color: Colors.white)),
              ),
            ])),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: const Icon(Icons.map_rounded, size: 40, color: Colors.white70)),
          ]),
        ),
      ),
    );
  }

  Widget _buildCrawlBanner(CrawlProvider crawl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CrawlHomeScreen())),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentLight]), borderRadius: BorderRadius.circular(AppRadius.xxl)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mindanao Crawl', style: AppTheme.headline(size: 18, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Collect stamps, win rewards!', style: AppTheme.body(size: 12, color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${crawl.stampCount}/8 stamps', style: AppTheme.label(size: 14, color: Colors.white)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text('Join the Crawl', style: AppTheme.label(size: 12, color: AppColors.accent)),
              ),
            ])),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.emoji_events, size: 36, color: Colors.white)),
          ]),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: AppTheme.headline(size: 18)),
        Text(action, style: AppTheme.label(size: 13, color: AppColors.primary)),
      ]),
    );
  }
}

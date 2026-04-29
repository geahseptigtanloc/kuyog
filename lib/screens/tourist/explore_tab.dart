import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/guide.dart';
import '../../models/destination.dart';
import '../../widgets/verified_badge.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});
  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _filterIndex = 0;
  final _filters = ['All', 'Guides', 'Destinations', 'Events', 'Merchants'];
  List<Guide> _guides = [];
  List<Destination> _destinations = [];
  bool _loading = true;

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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), boxShadow: AppShadows.card),
                child: Row(children: [
                  const Icon(Icons.search, color: AppColors.textLight),
                  const SizedBox(width: 10),
                  Text('Search guides, places, events...', style: AppTheme.body(size: 14, color: AppColors.textLight)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: _filters.length,
                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_filters[i]),
                    selected: _filterIndex == i,
                    onSelected: (_) => setState(() => _filterIndex = i),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: _filterIndex == i ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: _filterIndex == i ? AppColors.primary : AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_filterIndex == 1) return _buildGuideGrid();
    if (_filterIndex == 2) return _buildDestinationList();
    if (_filterIndex == 3) return _buildEventsList();
    if (_filterIndex == 4) return _buildMerchantList();
    return _buildAllContent();
  }

  Widget _buildAllContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Popular Guides', style: AppTheme.headline(size: 16)),
        const SizedBox(height: 12),
        ...(_guides.take(3).map((g) => _guideListTile(g))),
        const SizedBox(height: 24),
        Text('Top Destinations', style: AppTheme.headline(size: 16)),
        const SizedBox(height: 12),
        ...(_destinations.take(4).map((d) => _destListTile(d))),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _buildGuideGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: _guides.length,
      itemBuilder: (c, i) => _guideGridCard(_guides[i]),
    );
  }

  Widget _guideGridCard(Guide g) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
          child: CachedNetworkImage(imageUrl: g.photoUrl, height: 100, width: double.infinity, fit: BoxFit.cover,
            placeholder: (c, u) => Container(height: 100, color: AppColors.divider),
            errorWidget: (c, u, e) => Container(height: 100, color: AppColors.primaryLight.withValues(alpha: 0.2), child: const Icon(Icons.person, size: 40, color: AppColors.primary))),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(g.name, style: AppTheme.label(size: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (g.isVerified) const VerifiedBadge(size: 14),
            ]),
            const SizedBox(height: 2),
            Text(g.city, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Wrap(spacing: 4, children: g.specialties.take(2).map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text(s, style: AppTheme.body(size: 9, color: AppColors.primary)),
            )).toList()),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.star, size: 12, color: AppColors.warning),
              const SizedBox(width: 2),
              Text('${g.rating}', style: AppTheme.label(size: 11)),
              const SizedBox(width: 4),
              Text('${g.reviewCount} reviews', style: AppTheme.body(size: 10, color: AppColors.textLight)),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _guideListTile(Guide g) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        CircleAvatar(radius: 28, backgroundImage: CachedNetworkImageProvider(g.photoUrl)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(g.name, style: AppTheme.label(size: 14)),
            const SizedBox(width: 4),
            if (g.isVerified) const VerifiedBadge(size: 14),
          ]),
          Text('${g.city} · ${g.specialties.first}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star, size: 12, color: AppColors.warning),
            Text(' ${g.rating}', style: AppTheme.label(size: 11)),
            Text(' · ${g.tripCount} trips', style: AppTheme.body(size: 11, color: AppColors.textLight)),
          ]),
        ])),
        Text(g.priceRange, style: AppTheme.label(size: 14, color: AppColors.primary)),
      ]),
    );
  }

  Widget _destListTile(Destination d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.lg)),
          child: CachedNetworkImage(imageUrl: d.imageUrl, width: 100, height: 90, fit: BoxFit.cover,
            placeholder: (c, u) => Container(width: 100, height: 90, color: AppColors.divider),
            errorWidget: (c, u, e) => Container(width: 100, height: 90, color: AppColors.primaryLight.withValues(alpha: 0.2))),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.name, style: AppTheme.label(size: 14)),
            Text(d.province, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Text(d.category, style: AppTheme.body(size: 10, color: AppColors.primary))),
              const Spacer(),
              const Icon(Icons.star, size: 12, color: AppColors.warning),
              Text(' ${d.rating}', style: AppTheme.label(size: 11)),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _buildDestinationList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _destinations.length,
      itemBuilder: (c, i) => _destListTile(_destinations[i]),
    );
  }

  Widget _buildEventsList() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.event, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
      const SizedBox(height: 16),
      Text('Crawl Events', style: AppTheme.headline(size: 20)),
      const SizedBox(height: 8),
      Text('Discover food crawls, festivals & more', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
    ]));
  }

  Widget _buildMerchantList() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.store, size: 64, color: AppColors.accent.withValues(alpha: 0.3)),
      const SizedBox(height: 16),
      Text('Local Merchants', style: AppTheme.headline(size: 20)),
      const SizedBox(height: 8),
      Text('Support Mindanao MSMEs', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
    ]));
  }
}

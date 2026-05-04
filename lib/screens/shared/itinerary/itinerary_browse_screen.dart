import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';

class ItineraryBrowseScreen extends StatefulWidget {
  final dynamic preAssignedGuide;
  const ItineraryBrowseScreen({super.key, this.preAssignedGuide});
  @override
  State<ItineraryBrowseScreen> createState() => _ItineraryBrowseScreenState();
}

class _ItineraryBrowseScreenState extends State<ItineraryBrowseScreen> {
  String _regionFilter = 'All';
  final _regions = ['All', 'Davao Region', 'SOCCSKSARGEN', 'Caraga', 'Northern Mindanao', 'BARMM'];

  final _communityItineraries = [
    _CommunityItin('Davao City Explorer', 'Rico Magbanua', 'https://picsum.photos/seed/rico_guide/100/100', 'https://picsum.photos/seed/davao_comm/400/300', 5, 3, 4.8, 'Davao Region', 42),
    _CommunityItin('Siargao Island Hop', 'Maria Santos', 'https://picsum.photos/seed/maria/100/100', 'https://picsum.photos/seed/siargao_comm/400/300', 4, 5, 4.9, 'Caraga', 67),
    _CommunityItin('Lake Sebu Heritage', 'Datu Bai Mendoza', 'https://picsum.photos/seed/datu_guide/100/100', 'https://picsum.photos/seed/sebu_comm/400/300', 3, 2, 4.7, 'SOCCSKSARGEN', 28),
    _CommunityItin('CDO Extreme Weekend', 'Marco Santos', 'https://picsum.photos/seed/marco_guide/100/100', 'https://picsum.photos/seed/cdo_comm/400/300', 6, 3, 4.7, 'Northern Mindanao', 51),
    _CommunityItin('GenSan Food Trail', 'Jasmine Tan', 'https://picsum.photos/seed/jasmine_guide/100/100', 'https://picsum.photos/seed/gensan_comm/400/300', 8, 2, 4.6, 'SOCCSKSARGEN', 35),
    _CommunityItin('Marawi Heritage Walk', 'Khalil Omar', 'https://picsum.photos/seed/khalil_guide/100/100', 'https://picsum.photos/seed/marawi_comm/400/300', 4, 1, 4.5, 'BARMM', 12),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _regionFilter == 'All' ? _communityItineraries : _communityItineraries.where((i) => i.region == _regionFilter).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('Browse Itineraries', style: AppTheme.headline(size: 22)),
            ]),
          ),
          if (widget.preAssignedGuide != null)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Guide selected: ${widget.preAssignedGuide.name}. This guide will be assigned to whichever itinerary you choose.',
                      style: AppTheme.body(size: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), boxShadow: AppShadows.card),
              child: Row(children: [
                const Icon(Icons.search, size: 20, color: AppColors.textLight),
                const SizedBox(width: 10),
                Text('Search itineraries...', style: AppTheme.body(size: 14, color: AppColors.textLight)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _regions.map((r) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _regionFilter = r),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _regionFilter == r ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: _regionFilter == r ? AppColors.primary : AppColors.divider),
                    ),
                    child: Text(r, style: AppTheme.label(size: 12, color: _regionFilter == r ? Colors.white : AppColors.textSecondary)),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: filtered.length,
              itemBuilder: (c, i) => _itinCard(filtered[i]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _itinCard(_CommunityItin itin) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Stack(children: [
            CachedNetworkImage(imageUrl: itin.coverUrl, height: 100, width: double.infinity, fit: BoxFit.cover,
              placeholder: (c, u) => Container(height: 100, color: AppColors.divider),
              errorWidget: (c, u, e) => Container(height: 100, color: AppColors.primary.withOpacity(0.15))),
            Positioned(top: 8, right: 8, child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                child: const Icon(Icons.bookmark_border, size: 16, color: AppColors.primary),
              ),
            )),
          ]),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(itin.title, style: AppTheme.label(size: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Row(children: [
                CircleAvatar(radius: 10, backgroundImage: CachedNetworkImageProvider(itin.creatorAvatar)),
                const SizedBox(width: 4),
                Expanded(child: Text(itin.creatorName, style: AppTheme.body(size: 10, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const Spacer(),
              Row(children: [
                Text('${itin.stops} stops · ${itin.days}d', style: AppTheme.body(size: 10, color: AppColors.textLight)),
                const Spacer(),
                const Icon(Icons.star, size: 11, color: AppColors.warning),
                Text(' ${itin.rating}', style: AppTheme.label(size: 10)),
              ]),
              const SizedBox(height: 2),
              Text('${itin.saves} saves', style: AppTheme.body(size: 10, color: AppColors.textLight)),
            ]),
          )),
        ]),
      ),
    );
  }
}

class _CommunityItin {
  final String title, creatorName, creatorAvatar, coverUrl, region;
  final int stops, days, saves;
  final double rating;
  _CommunityItin(this.title, this.creatorName, this.creatorAvatar, this.coverUrl, this.stops, this.days, this.rating, this.region, this.saves);
}

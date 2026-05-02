import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../providers/travel_provider.dart';
import '../../../models/itinerary.dart';
import '../../../widgets/mindanao_map.dart';
import 'itinerary_create_screen.dart';
import 'itinerary_detail_screen.dart';
import 'itinerary_browse_screen.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../travel/travel_type_screen.dart';
import '../travel/group_setup_screen.dart';
import '../travel/ai_matching_screen.dart';

class TouristItineraryHubScreen extends StatefulWidget {
  const TouristItineraryHubScreen({super.key});
  @override
  State<TouristItineraryHubScreen> createState() => _TouristItineraryHubScreenState();
}

class _TouristItineraryHubScreenState extends State<TouristItineraryHubScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(
        title: 'My Itineraries',
        extraAction: IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.primary),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Consumer<ItineraryProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 12),
                // Stats row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    _statChip(Icons.calendar_today, 'Active', '${provider.activeCount}', AppColors.primary),
                    const SizedBox(width: 8),
                    _statChip(Icons.check_circle, 'Completed', '${provider.completedCount}', AppColors.success),
                    const SizedBox(width: 8),
                    _statChip(Icons.edit_note, 'Drafts', '${provider.draftCount}', AppColors.textSecondary),
                  ]),
                ),
                const SizedBox(height: 16),
                // Map
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.card,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const MindanaoMap(),
                ),
                const SizedBox(height: 20),
                // Quick actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    _quickAction(Icons.edit_note, 'Create\nMy Own', AppColors.primary, () {
                      _startTravelFlow(context, 'create');
                    }),
                    const SizedBox(width: 8),
                    _quickAction(Icons.explore, 'Browse\nItineraries', AppColors.accent, () {
                      _startTravelFlow(context, 'browse');
                    }),
                    const SizedBox(width: 8),
                    _quickAction(Icons.handshake, 'Co-Create\nwith Guide', AppColors.primaryDark, () {
                      _startTravelFlow(context, 'cocreate');
                    }),
                  ]),
                ),
                const SizedBox(height: 24),
                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Text('My Itineraries', style: AppTheme.headline(size: 18)),
                    const Spacer(),
                    InkWell(onTap: () {}, child: Text('See All', style: AppTheme.label(size: 13, color: AppColors.primary))),
                  ]),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: ['All', 'Active', 'Draft', 'Awaiting Guide', 'Completed'].map((f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() { _filter = f; provider.setFilter(f); }),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _filter == f ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(color: _filter == f ? AppColors.primary : AppColors.divider),
                          ),
                          child: Text(f, style: AppTheme.label(size: 12, color: _filter == f ? Colors.white : AppColors.textSecondary)),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                // Itinerary list
                ...provider.filteredItineraries.map((itin) => _itineraryCard(itin)),
                const SizedBox(height: 24),
                // Recommended section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Text('Popular in Mindanao', style: AppTheme.headline(size: 18)),
                    const Spacer(),
                    InkWell(onTap: () {}, child: Text('See All', style: AppTheme.label(size: 13, color: AppColors.primary))),
                  ]),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _recommendedCard('Siargao Island Hop', 'Caraga', 5, 4, 4.8, 'https://picsum.photos/seed/rec_siargao/300/200'),
                      _recommendedCard('CDO Extreme Weekend', 'Northern Mindanao', 6, 3, 4.7, 'https://picsum.photos/seed/rec_cdo/300/200'),
                      _recommendedCard('BARMM Heritage Trail', 'BARMM', 4, 2, 4.5, 'https://picsum.photos/seed/rec_barmm/300/200'),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            );
          },
        ),
      ),
    );
  }

  void _startTravelFlow(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TravelTypeScreen(
          onContinue: () {
            final provider = context.read<TravelProvider>();
            if (provider.travelType == 'group') {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => GroupSetupScreen(
                  onContinue: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const AIMatchingScreen(nextRoute: 'itinerary_create'),
                    ));
                  },
                ),
              ));
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const AIMatchingScreen(nextRoute: 'itinerary_create'),
              ));
            }
          },
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String label, String value, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text('$label: $value', style: AppTheme.label(size: 11, color: color)),
      ]),
    ));
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(label, style: AppTheme.label(size: 11, color: color), textAlign: TextAlign.center),
        ]),
      ),
    ));
  }

  Widget _itineraryCard(Itinerary itin) {
    final statusColor = _statusColor(itin.status);
    return Dismissible(
      key: Key(itin.id),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.lg)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.copy, color: Colors.white),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(AppRadius.lg)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          context.read<ItineraryProvider>().deleteItinerary(itin.id);
          return true;
        } else {
          context.read<ItineraryProvider>().duplicateItinerary(itin.id);
          return false;
        }
      },
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => ItineraryDetailScreen(title: itin.title, status: itin.status, statusColor: statusColor),
        )),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: CachedNetworkImage(
                imageUrl: itin.imageUrl, width: 70, height: 70, fit: BoxFit.cover,
                placeholder: (c, u) => Container(width: 70, height: 70, color: AppColors.divider),
                errorWidget: (c, u, e) => Container(width: 70, height: 70, color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.map, color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(itin.title, style: AppTheme.label(size: 15)),
              if (itin.guideName.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(children: [
                  CircleAvatar(radius: 10, backgroundImage: CachedNetworkImageProvider(itin.guideAvatar.isNotEmpty ? itin.guideAvatar : 'https://picsum.photos/seed/default/50/50')),
                  const SizedBox(width: 4),
                  Text(itin.guideName, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                ]),
              ],
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.place, size: 12, color: AppColors.textLight),
                Text(' ${itin.stopsCount} stops', style: AppTheme.body(size: 11, color: AppColors.textLight)),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today, size: 12, color: AppColors.textLight),
                Text(' ${itin.dateRange.isNotEmpty ? itin.dateRange : '${itin.durationDays}d'}', style: AppTheme.body(size: 11, color: AppColors.textLight)),
                if (itin.estimatedCost > 0) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.payments, size: 12, color: AppColors.textLight),
                  Text(' ₱${itin.estimatedCost.toStringAsFixed(0)}', style: AppTheme.body(size: 11, color: AppColors.textLight)),
                ],
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                  child: Text(itin.status, style: AppTheme.label(size: 10, color: statusColor)),
                ),
                if (itin.isOfflineAvailable) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.download_done, size: 10, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text('Offline', style: AppTheme.label(size: 9, color: AppColors.primary)),
                    ]),
                  ),
                ],
              ]),
            ])),
            OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => ItineraryDetailScreen(title: itin.title, status: itin.status, statusColor: statusColor),
              )),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(itin.status == 'Draft' ? 'Continue' : 'View', style: AppTheme.label(size: 11, color: AppColors.primary)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _recommendedCard(String title, String region, int stops, int days, double rating, String imageUrl) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        CachedNetworkImage(imageUrl: imageUrl, width: 170, height: 210, fit: BoxFit.cover,
          placeholder: (c, u) => Container(width: 170, height: 210, color: AppColors.divider),
          errorWidget: (c, u, e) => Container(width: 170, height: 210, color: AppColors.primary.withOpacity(0.2))),
        Positioned.fill(child: DecoratedBox(
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)])),
        )),
        Positioned(bottom: 12, left: 12, right: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.label(size: 14, color: Colors.white)),
          const SizedBox(height: 2),
          Text('$stops stops · ${days}d', style: AppTheme.body(size: 11, color: Colors.white70)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star, size: 12, color: AppColors.warning),
            Text(' $rating', style: AppTheme.label(size: 11, color: Colors.white)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text('Use This', style: AppTheme.label(size: 10, color: Colors.white)),
            ),
          ]),
        ])),
      ]),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active': return AppColors.primary;
      case 'Draft': return AppColors.textSecondary;
      case 'Completed': return const Color(0xFF6B7280);
      case 'Awaiting Guide': return AppColors.warning;
      default: return AppColors.accent;
    }
  }
}

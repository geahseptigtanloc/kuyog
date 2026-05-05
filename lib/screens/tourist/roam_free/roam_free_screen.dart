import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/destination.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/kuyog_card.dart';
import '../../../widgets/durie_loading.dart';
import 'destination_detail_screen.dart';
import 'itinerary_builder_screen.dart';

class RoamFreeScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const RoamFreeScreen({super.key, this.onBack});
  @override
  State<RoamFreeScreen> createState() => _RoamFreeScreenState();
}

class _RoamFreeScreenState extends State<RoamFreeScreen> {
  List<Destination> _destinations = [];
  bool _loading = true;
  String _filter = 'All';
  final _filters = ['All', 'Nature', 'Culture', 'Wildlife', 'Beach', 'Museum', 'Shopping', 'Water Sports', 'Mountain', 'Farm', 'Religious'];
  final List<Destination> _itinerary = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final d = await MockData.getDestinations();
    if (mounted) setState(() { _destinations = d; _loading = false; });
  }

  List<Destination> get _filtered => _filter == 'All' ? _destinations : _destinations.where((d) => d.category.toLowerCase() == _filter.toLowerCase()).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading ? const DurieLoading() : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            leading: KuyogBackButton(onTap: widget.onBack ?? () => Navigator.pop(context)),
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=800',
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.primaryDark),
                    errorWidget: (c, u, e) => Container(color: AppColors.primary),
                  ),
                  // Better Gradient Overlay
                  Container(
                    color: Colors.black.withAlpha(100),
                  ),
                  // Content
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            'BUILD YOUR OWN',
                            style: AppTheme.label(size: 10, color: Colors.white, weight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Roam Free',
                          style: AppTheme.headline(size: 34, color: Colors.white, height: 1.1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'AI-assisted. Self-planned.\nKUYOG gets you there.',
                          style: AppTheme.body(
                            size: 14, 
                            color: Colors.white.withAlpha(230),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // AI Suggestion Banner
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withAlpha(51), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('AI Suggested Itinerary', style: AppTheme.label(size: 14, color: Colors.white)),
                Text('Based on your interests, we recommend starting with these destinations', style: AppTheme.body(size: 12, color: Colors.white70)),
              ])),
            ]),
          )),
          // Itinerary Builder Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: KuyogCard(
                backgroundColor: Colors.white,
                onTap: () async {
                  final result = await Navigator.push<List<Destination>>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItineraryBuilderScreen(initialItinerary: _itinerary),
                    ),
                  );
                  if (result != null) {
                    setState(() => _itinerary.clear());
                    setState(() => _itinerary.addAll(result));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_awesome, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Smart Itinerary Builder', style: AppTheme.headline(size: 16)),
                            const SizedBox(height: 2),
                            Text('Drag to reorder, AI-optimized slots, & budget tracker', 
                              style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textLight),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // View My Itinerary Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  // This could also open the builder for now
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItineraryBuilderScreen(initialItinerary: _itinerary),
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt, size: 18),
                label: const Text('View My Itinerary'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  textStyle: AppTheme.label(size: 14),
                ),
              ),
            ),
          ),
          // My Itinerary
          if (_itinerary.isNotEmpty) ...[
            SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 8), child: Row(children: [
              Text('My Itinerary (${_itinerary.length})', style: AppTheme.headline(size: 16)),
              const Spacer(),
              TextButton(onPressed: () => setState(() => _itinerary.clear()), child: Text('Clear All', style: AppTheme.label(size: 12, color: AppColors.error))),
            ]))),
            SliverToBoxAdapter(child: SizedBox(height: 120, child: ListView.builder(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _itinerary.length,
              itemBuilder: (c, i) => Container(
                width: 160, margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1E5), // Light green to match the UI in image
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.primary.withAlpha(51)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 24, height: 24,
                      decoration: const BoxDecoration(color: Color(0xFF4A7D4C), shape: BoxShape.circle),
                      child: Center(child: Text('${i + 1}', style: AppTheme.label(size: 12, color: Colors.white))),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _itinerary.removeAt(i)),
                      child: const Icon(Icons.close, size: 18, color: AppColors.textLight),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Text(_itinerary[i].name, style: AppTheme.label(size: 13, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text('~${_itinerary[i].estimatedVisitMinutes} min', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                ]),
              ),
            ))),
            // Budget Tracker
            SliverToBoxAdapter(child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.accent.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(children: [
                const Icon(Icons.account_balance_wallet, size: 18, color: AppColors.accent),
                const SizedBox(width: 10),
                Text('Est. entrance fees: ', style: AppTheme.body(size: 13)),
                Text('P${_itinerary.fold<double>(0, (s, d) => s + d.pricePerDay).toInt()}', style: AppTheme.label(size: 14, color: AppColors.accent)),
                Text(' (paid at gate)', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
              ]),
            )),
          ],
          // Category filters
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.only(top: 8), child: SizedBox(height: 36, child: ListView.builder(
            scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _filters.length,
            itemBuilder: (c, i) {
              final sel = _filter == _filters[i];
              return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
                onTap: () => setState(() => _filter = _filters[i]),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: sel ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), border: Border.all(color: sel ? AppColors.primary : AppColors.divider)),
                  child: Center(child: Text(_filters[i], style: AppTheme.label(size: 11, color: sel ? Colors.white : AppColors.textSecondary)))),
              ));
            },
          )))),
          // Destinations
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 8), child: Text('Browse Destinations', style: AppTheme.headline(size: 16)))),
          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (c, i) => _destCard(_filtered[i]),
              childCount: _filtered.length,
            ))),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _destCard(Destination d) {
    final inItinerary = _itinerary.any((it) => it.id == d.id);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DestinationDetailScreen(destination: d))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: d.imageUrl, 
                width: 140, 
                fit: BoxFit.cover,
                placeholder: (c,u) => Container(width: 140, color: AppColors.divider),
                errorWidget: (c,u,e) => Container(width: 140, color: AppColors.primary.withAlpha(38))
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      // Title
                      Text(
                        d.name, 
                        style: AppTheme.headline(size: 15), 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis
                      ),
                      const SizedBox(height: 4),
                      // Province
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              d.province, 
                              style: AppTheme.body(size: 13, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Row for Category and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Text(
                              d.category, 
                              style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF16A34A))
                            )
                          ),
                          Text(
                            d.isFreeEntry ? 'Free' : '₱${d.pricePerDay.toInt()}', 
                            style: AppTheme.headline(size: 15, color: d.isFreeEntry ? const Color(0xFF16A34A) : AppColors.primary)
                          ),
                        ]
                      ),
                      const SizedBox(height: 12),
                      // Add Button
                      GestureDetector(
                        onTap: () {
                          setState(() { if (inItinerary) {
                            _itinerary.removeWhere((it) => it.id == d.id);
                          } else {
                            _itinerary.add(d);
                          } });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: inItinerary ? AppColors.error.withAlpha(20) : AppColors.accent, 
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(inItinerary ? Icons.remove : Icons.add, size: 14, color: inItinerary ? AppColors.error : Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                inItinerary ? 'Remove' : 'Add to Itinerary', 
                                style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: inItinerary ? AppColors.error : Colors.white)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  )
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}


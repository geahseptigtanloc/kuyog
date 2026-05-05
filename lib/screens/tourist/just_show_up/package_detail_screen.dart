import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/tour_operator.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'booking_flow_screen.dart';

class PackageDetailScreen extends StatelessWidget {
  final TourPackage package;
  final TourOperator? operator;
  const PackageDetailScreen({super.key, required this.package, this.operator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero
          SliverAppBar(
            expandedHeight: 280, pinned: true,
            leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                CachedNetworkImage(imageUrl: package.photoUrl, width: double.infinity, height: 340, fit: BoxFit.cover,
                  placeholder: (c,u) => Container(color: AppColors.primaryDark),
                  errorWidget: (c,u,e) => Container(color: AppColors.primary)),
                Container(color: Colors.black.withAlpha(100)),
                Positioned(bottom: 60, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (operator != null) Row(children: [
                    Icon(Icons.verified, size: 14, color: AppColors.verified),
                    const SizedBox(width: 4),
                    Text(operator!.companyName, style: AppTheme.label(size: 13, color: Colors.white)),
                  ]),
                  const SizedBox(height: 6),
                  Text(package.name, style: AppTheme.headline(size: 22, color: Colors.white)),
                  if (package.hookLine.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(package.hookLine, style: AppTheme.body(size: 13, color: Colors.white.withAlpha(217))),
                  ],
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text('${package.rating} (${package.reviewCount} reviews)', style: AppTheme.label(size: 13, color: Colors.white)),
                    const Spacer(),
                    Text('P${package.price.toInt()}', style: AppTheme.headline(size: 22, color: AppColors.accentLight)),
                    Text('/person', style: AppTheme.body(size: 12, color: Colors.white70)),
                  ]),
                ])),
              ]),
            ),
          ),
          // Summary strip
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _summaryItem(Icons.schedule, package.duration.isNotEmpty ? package.duration : '${package.durationDays} Day(s)'),
              _divider(),
              _summaryItem(Icons.group, '${package.minGroupSize}-${package.maxPax} pax'),
              _divider(),
              _summaryItem(Icons.terrain, package.difficulty),
              _divider(),
              _summaryItem(Icons.language, package.languagesAvailable.isNotEmpty ? package.languagesAvailable.first : 'EN'),
            ]),
          )),
          // Why This Tour
          if (package.whyThisTour.isNotEmpty)
            SliverToBoxAdapter(child: _section('Why This Tour', child: Text(package.whyThisTour, style: AppTheme.body(size: 14, color: AppColors.textPrimary).copyWith(height: 1.6, fontStyle: FontStyle.italic)))),
          // Highlights
          if (package.highlights.isNotEmpty)
            SliverToBoxAdapter(child: _section('Highlights of the Tour', child: Column(
              children: package.highlights.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.star_rounded, size: 18, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h['title'] ?? '', style: AppTheme.label(size: 14)),
                    Text(h['desc'] ?? '', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                  ])),
                ]),
              )).toList(),
            ))),
          // Full Itinerary
          if (package.fullItinerary.isNotEmpty)
            SliverToBoxAdapter(child: _section('Full Itinerary', child: Column(
              children: package.fullItinerary.map((day) {
                final stops = (day['stops'] as List<dynamic>?) ?? [];
                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text('Day ${day['day']} - ${day['title']}', style: AppTheme.label(size: 15, color: AppColors.primary)),
                    children: stops.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 65, child: Text(s['time'] ?? '', style: AppTheme.label(size: 12, color: AppColors.primary))),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s['activity'] ?? '', style: AppTheme.label(size: 13)),
                          if (s['location'] != null) Text(s['location'], style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                        ])),
                      ]),
                    )).toList(),
                  ),
                );
              }).toList(),
            ))),
          // Inclusions & Exclusions
          SliverToBoxAdapter(child: _section('What\'s Included', child: Column(children: [
            ...package.inclusions.map((inc) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [Icon(Icons.check_circle, size: 16, color: AppColors.success), const SizedBox(width: 8), Expanded(child: Text(inc, style: AppTheme.body(size: 13)))]),
            )),
            if (package.exclusions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: Text('Not Included', style: AppTheme.label(size: 14, color: AppColors.error))),
              const SizedBox(height: 6),
              ...package.exclusions.map((exc) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [Icon(Icons.cancel, size: 16, color: AppColors.error.withAlpha(153)), const SizedBox(width: 8), Expanded(child: Text(exc, style: AppTheme.body(size: 13, color: AppColors.textSecondary)))]),
              )),
            ],
          ]))),
          // Track on Map
          SliverToBoxAdapter(child: _trackOnMapSection()),
          // Entrance Fees
          if (package.entranceFees.isNotEmpty)
            SliverToBoxAdapter(child: _section('Entrance Fees Reference', child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Expanded(flex: 3, child: Text('Destination', style: AppTheme.label(size: 12, color: AppColors.primary))),
                    Expanded(flex: 2, child: Text('Fee', style: AppTheme.label(size: 12, color: AppColors.primary))),
                    Expanded(flex: 2, child: Text('Included?', style: AppTheme.label(size: 12, color: AppColors.primary))),
                  ]),
                ),
                ...package.entranceFees.map((ef) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(children: [
                    Expanded(flex: 3, child: Text(ef['destination'] ?? '', style: AppTheme.body(size: 12))),
                    Expanded(flex: 2, child: Text(ef['fee'] ?? '', style: AppTheme.body(size: 12))),
                    Expanded(flex: 2, child: Row(children: [
                      Icon(ef['included'] == true || ef['included'] == 'true' ? Icons.check_circle : Icons.cancel,
                        size: 14, color: ef['included'] == true || ef['included'] == 'true' ? AppColors.success : AppColors.error),
                      const SizedBox(width: 4),
                      Text(ef['included'] == true || ef['included'] == 'true' ? 'Yes' : 'No', style: AppTheme.body(size: 11)),
                    ])),
                  ]),
                )),
              ],
            ))),
          // FAQs
          if (package.faqs.isNotEmpty)
            SliverToBoxAdapter(child: _section('FAQs', child: Column(
              children: package.faqs.map((faq) => Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(faq['q'] ?? '', style: AppTheme.label(size: 14)),
                  children: [Padding(padding: const EdgeInsets.only(bottom: 12), child: Align(alignment: Alignment.centerLeft, child: Text(faq['a'] ?? '', style: AppTheme.body(size: 13, color: AppColors.textSecondary))))],
                ),
              )).toList(),
            ))),
          // Operator Card
          if (operator != null)
            SliverToBoxAdapter(child: _operatorProfileCard()),
          // Reviews
          SliverToBoxAdapter(child: _reviewsSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      // Book Now button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
        child: SafeArea(child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('Starts at', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
            Text('P${package.price.toInt()}/person', style: AppTheme.headline(size: 20, color: AppColors.primary)),
          ]),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFlowScreen(package: package, operator: operator))),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
            child: Text('Book Now', style: AppTheme.label(size: 16, color: Colors.white)),
          ),
        ])),
      ),
    );
  }

  Widget _trackOnMapSection() => _section('Track on Map — Getting There', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        image: const DecorationImage(
          image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=800'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(children: [
        Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), boxShadow: AppShadows.card),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.map, size: 16, color: AppColors.primary), const SizedBox(width: 8), Text('Open Interactive Map', style: AppTheme.label(size: 12))]))),
        // Pins simulation
        const Positioned(top: 40, left: 60, child: Icon(Icons.location_on, color: AppColors.primary, size: 30)),
        const Positioned(bottom: 50, right: 80, child: Icon(Icons.location_on, color: AppColors.primary, size: 30)),
      ]),
    ),
    const SizedBox(height: 16),
    Text('How to Get to the Starting Point', style: AppTheme.label(size: 14)),
    const SizedBox(height: 8),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text('Pickup starts at Francisco Bangoy International Airport (DVO) or your hotel in Davao City center.', style: AppTheme.body(size: 12))),
      ]),
    ),
  ]));

  Widget _operatorProfileCard() => _section('Tour Operator', child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.divider)),
    child: Column(children: [
      Row(children: [
        CircleAvatar(radius: 28, backgroundImage: CachedNetworkImageProvider(operator!.logoUrl)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(operator!.companyName, style: AppTheme.headline(size: 16))),
            Icon(Icons.verified, size: 18, color: AppColors.verified),
          ]),
          Text('${operator!.dotAccreditationNumber} • DOT Accredited', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
        ])),
      ]),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _opStat('Rating', '${operator!.rating} ★'),
        _opStat('Tours', '${operator!.totalTours}+'),
        _opStat('Response', operator!.responseRate),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.success),
        const SizedBox(width: 6),
        Text('Typically replies ${operator!.responseTime.toLowerCase()}', style: AppTheme.body(size: 12, color: AppColors.success)),
      ]),
      const SizedBox(height: 16),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44), side: const BorderSide(color: AppColors.primary)),
        child: Text('View All Packages by This Operator', style: AppTheme.label(size: 13, color: AppColors.primary)),
      ),
    ]),
  ));

  Widget _reviewsSection() => _section('Reviews and Ratings', child: Column(children: [
    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(children: [
        Text(package.rating.toString(), style: AppTheme.headline(size: 32, color: AppColors.textPrimary)),
        Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < package.rating.floor() ? Colors.amber : AppColors.divider))),
        const SizedBox(height: 4),
        Text('${package.reviewCount} reviews', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ]),
      const SizedBox(width: 24),
      Expanded(child: Column(children: [
        _ratingBar('Guide', 4.9),
        _ratingBar('Value', 4.7),
        _ratingBar('Accuracy', 4.8),
        _ratingBar('Safety', 5.0),
      ])),
    ]),
    const SizedBox(height: 24),
    // Sample Review
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider.withAlpha(127))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(radius: 14, backgroundColor: AppColors.primary, child: Text('J', style: TextStyle(color: Colors.white, fontSize: 10))),
          const SizedBox(width: 10),
          Text('John D.', style: AppTheme.label(size: 13)),
          const Spacer(),
          Text('2 weeks ago', style: AppTheme.body(size: 11, color: AppColors.textLight)),
        ]),
        const SizedBox(height: 10),
        Row(children: List.generate(5, (i) => const Icon(Icons.star, size: 12, color: Colors.amber))),
        const SizedBox(height: 8),
        Text('Incredible experience! The guide was so knowledgeable about Davao history. Highly recommended.', style: AppTheme.body(size: 13)),
        const SizedBox(height: 12),
        Row(children: [
          _reviewPhoto('https://picsum.photos/seed/tour1/100/100'),
          const SizedBox(width: 8),
          _reviewPhoto('https://picsum.photos/seed/tour2/100/100'),
          const SizedBox(width: 12),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withAlpha(26), borderRadius: BorderRadius.circular(4)),
            child: Row(children: [const Icon(Icons.camera_alt, size: 10, color: AppColors.success), const SizedBox(width: 4), Text('Verified Photo Review', style: AppTheme.label(size: 9, color: AppColors.success))])),
        ]),
      ]),
    ),
  ]));

  Widget _opStat(String l, String v) => Column(children: [
    Text(v, style: AppTheme.label(size: 15)),
    Text(l, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
  ]);

  Widget _ratingBar(String label, double score) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [
      SizedBox(width: 60, child: Text(label, style: AppTheme.body(size: 12, color: AppColors.textSecondary))),
      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(value: score / 5, minHeight: 4, backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation(AppColors.primary)))),
      const SizedBox(width: 8),
      Text(score.toString(), style: AppTheme.label(size: 11)),
    ]),
  );

  Widget _reviewPhoto(String url) => ClipRRect(borderRadius: BorderRadius.circular(6), child: CachedNetworkImage(imageUrl: url, width: 50, height: 50, fit: BoxFit.cover));

  Widget _summaryItem(IconData icon, String text) => Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 20, color: AppColors.primary), const SizedBox(height: 4),
    Text(text, style: AppTheme.body(size: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
  ]);

  Widget _divider() => Container(width: 1, height: 32, color: AppColors.divider);

  Widget _section(String title, {required Widget child}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTheme.headline(size: 18)),
      const SizedBox(height: 12),
      child,
    ]),
  );
}



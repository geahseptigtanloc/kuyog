import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/destination.dart';
import '../../../widgets/kuyog_back_button.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;
  const DestinationDetailScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero
          SliverAppBar(expandedHeight: 260, pinned: true,
            leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                CachedNetworkImage(imageUrl: destination.imageUrl, width: double.infinity, height: 320, fit: BoxFit.cover,
                  placeholder: (c,u) => Container(color: AppColors.primaryDark),
                  errorWidget: (c,u,e) => Container(color: AppColors.primary)),
                Container(color: Colors.black.withAlpha(100)),
                Positioned(bottom: 56, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.pill)),
                    child: Text(destination.category, style: AppTheme.label(size: 11, color: Colors.white))),
                  const SizedBox(height: 8),
                  Text(destination.name, style: AppTheme.headline(size: 24, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${destination.province}, ${destination.region}', style: AppTheme.body(size: 13, color: Colors.white70)),
                    const Spacer(),
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                    Text(' ${destination.rating}', style: AppTheme.label(size: 14, color: Colors.white)),
                  ]),
                ])),
              ]),
            )),
          // Quick Info Strip
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _quickInfo(Icons.access_time, destination.operatingHours.isNotEmpty ? destination.operatingHours.split(',').first.trim() : 'Check hours'),
              Container(width: 1, height: 30, color: AppColors.divider),
              _quickInfo(Icons.confirmation_number, destination.isFreeEntry ? 'Free Entry' : destination.entranceFee),
              Container(width: 1, height: 30, color: AppColors.divider),
              _quickInfo(Icons.timer, '~${destination.estimatedVisitMinutes} min'),
            ]),
          )),
          // Description
          SliverToBoxAdapter(child: _section('About', child: Text(destination.description, style: AppTheme.body(size: 14).copyWith(height: 1.6)))),
          // Why Visit
          if (destination.whyVisit.isNotEmpty)
            SliverToBoxAdapter(child: _section('Why Visit', child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.accent.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.accent.withAlpha(51))),
              child: Text(destination.whyVisit, style: AppTheme.body(size: 14, color: AppColors.textPrimary).copyWith(height: 1.5, fontStyle: FontStyle.italic)),
            ))),
          // Highlights
          if (destination.highlights.isNotEmpty)
            SliverToBoxAdapter(child: _section('Highlights', child: Column(
              children: destination.highlights.map((h) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.star_rounded, size: 16, color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: Text(h, style: AppTheme.body(size: 14))),
              ]))).toList(),
            ))),
          // Operating Hours
          if (destination.operatingHours.isNotEmpty)
            SliverToBoxAdapter(child: _section('Operating Hours', child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider)),
              child: Row(children: [
                const Icon(Icons.schedule, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(destination.operatingHours, style: AppTheme.body(size: 14))),
              ]),
            ))),
          // Entrance Fee
          SliverToBoxAdapter(child: _section('Entrance Fee', child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: destination.isFreeEntry ? AppColors.success.withAlpha(15) : AppColors.accent.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(children: [
              Icon(Icons.confirmation_number, size: 20, color: destination.isFreeEntry ? AppColors.success : AppColors.accent),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(destination.isFreeEntry ? 'Free Entry' : destination.entranceFee, style: AppTheme.label(size: 15, color: destination.isFreeEntry ? AppColors.success : AppColors.accent)),
                if (destination.entranceFeeNotes.isNotEmpty) Text(destination.entranceFeeNotes, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                if (!destination.isFreeEntry) Text('Paid at the gate - cash, GCash, or card (check with site)', style: AppTheme.body(size: 11, color: AppColors.textLight)),
              ])),
            ]),
          ))),
          // What to Bring
          if (destination.whatToBring.isNotEmpty)
            SliverToBoxAdapter(child: _section('What to Bring', child: Wrap(spacing: 8, runSpacing: 8,
              children: destination.whatToBring.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(item, style: AppTheme.body(size: 12, color: AppColors.primary)),
                ]),
              )).toList(),
            ))),
          // FAQs
          if (destination.faqs.isNotEmpty)
            SliverToBoxAdapter(child: _section('FAQs', child: Column(
              children: destination.faqs.map((faq) => Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(tilePadding: EdgeInsets.zero,
                  title: Text(faq['q'] ?? '', style: AppTheme.label(size: 14)),
                  children: [Padding(padding: const EdgeInsets.only(bottom: 12), child: Align(alignment: Alignment.centerLeft,
                    child: Text(faq['a'] ?? '', style: AppTheme.body(size: 13, color: AppColors.textSecondary))))],
                ),
              )).toList(),
            ))),
          // Contact
          if (destination.contactPhone.isNotEmpty || destination.contactEmail.isNotEmpty)
            SliverToBoxAdapter(child: _section('Contact', child: Column(children: [
              if (destination.contactPhone.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
                const Icon(Icons.phone, size: 16, color: AppColors.primary), const SizedBox(width: 8),
                Text(destination.contactPhone, style: AppTheme.body(size: 13)),
              ])),
              if (destination.contactEmail.isNotEmpty) Row(children: [
                const Icon(Icons.email, size: 16, color: AppColors.primary), const SizedBox(width: 8),
                Text(destination.contactEmail, style: AppTheme.body(size: 13)),
              ]),
            ]))),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _quickInfo(IconData icon, String text) => Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 18, color: AppColors.primary), const SizedBox(height: 4),
    Text(text, style: AppTheme.body(size: 10, color: AppColors.textSecondary), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
  ]));

  Widget _section(String title, {required Widget child}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTheme.headline(size: 18)),
      const SizedBox(height: 12), child,
    ]),
  );
}


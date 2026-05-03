import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../app_theme.dart';
import '../../../providers/miles_provider.dart';
import '../../../models/miles_activity.dart';
import '../../../widgets/kuyog_back_button.dart';

class MilesDashboardScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const MilesDashboardScreen({super.key, this.onBack});
  @override
  State<MilesDashboardScreen> createState() => _MilesDashboardScreenState();
}

class _MilesDashboardScreenState extends State<MilesDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    final miles = context.read<MilesProvider>();
    _animController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _countAnimation = IntTween(begin: 0, end: miles.balance).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() { _animController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final miles = context.watch<MilesProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Back button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: KuyogBackButton(onTap: widget.onBack ?? () => Navigator.pop(context)),
            ),
            // Hero Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [AppColors.primaryDark, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
              ),
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Kuyog Miles', style: AppTheme.label(size: 14, color: Colors.white70)),
                    const SizedBox(height: 4),
                    AnimatedBuilder(
                      animation: _countAnimation,
                      builder: (c, _) => Text('${_countAnimation.value}', style: AppTheme.headline(size: 42, color: Colors.white)),
                    ),
                    const SizedBox(height: 4),
                    Text('= ₱${miles.pesoEquivalent.toStringAsFixed(0)} in rewards', style: AppTheme.body(size: 12, color: Colors.white70)),
                  ])),
                  // Durie placeholder
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(Icons.star, size: 40, color: Colors.amber),
                  ),
                ]),
                const SizedBox(height: 16),
                // Progress bar
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: miles.tierProgress,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.amber),
                        minHeight: 8,
                      ),
                    )),
                  ]),
                  const SizedBox(height: 6),
                  Text('${miles.milesToNextTier} miles to next reward', style: AppTheme.body(size: 11, color: Colors.white70)),
                ]),
              ]),
            ),
            // Tier badges
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Reward Tiers', style: AppTheme.headline(size: 18))),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: miles.tiers.length,
                itemBuilder: (c, i) {
                  final tier = miles.tiers[i];
                  final isCurrent = i == miles.currentTierIndex;
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadows.card,
                      border: isCurrent ? Border.all(color: AppColors.primary, width: 2) : null,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(_tierIcon(i), size: 28, color: _tierColor(i)),
                      const SizedBox(height: 6),
                      Text(tier.name, style: AppTheme.label(size: 14, color: _tierColor(i))),
                      Text('${tier.minMiles}-${tier.maxMiles}', style: AppTheme.body(size: 10, color: AppColors.textLight)),
                      const Spacer(),
                      ...tier.perks.take(2).map((p) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('· $p', style: AppTheme.body(size: 9, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      )),
                    ]),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // How to Earn
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Earn Miles', style: AppTheme.headline(size: 18))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2,
                children: [
                  _earnCard(Icons.map, 'Complete Booking', '+150', AppColors.primary),
                  _earnCard(Icons.star, 'Leave a Review', '+50', AppColors.warning),
                  _earnCard(Icons.camera_alt, 'Post to StoryHub', '+30', AppColors.accent),
                  _earnCard(Icons.qr_code, 'Crawl Stamp', '+100', const Color(0xFF0891B2)),
                  _earnCard(Icons.school, 'Language Quiz', '+20', AppColors.adminPurple),
                  _earnCard(Icons.people, 'Refer a Friend', '+200', AppColors.guideGreen),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Redeem Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Redeem Rewards', style: AppTheme.headline(size: 18)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: miles.rewards.length,
                itemBuilder: (c, i) {
                  final reward = miles.rewards[i];
                  final canAfford = miles.balance >= reward.milesCost;
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(children: [
                      Container(height: 170, width: 150, color: AppColors.primary.withOpacity(0.1),
                        child: Icon(Icons.card_giftcard, size: 50, color: AppColors.primary.withOpacity(0.2))),
                      Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
                      ))),
                      Positioned(bottom: 12, left: 12, right: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(reward.name, style: AppTheme.label(size: 12, color: Colors.white)),
                        Text('${reward.milesCost} miles', style: AppTheme.label(size: 14, color: Colors.amber)),
                        const SizedBox(height: 6),
                        SizedBox(width: double.infinity, child: canAfford
                          ? ElevatedButton(
                              onPressed: () => miles.redeem(reward.milesCost),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 6), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              child: Text('Redeem', style: AppTheme.label(size: 11, color: Colors.white)),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(AppRadius.md)),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.lock, size: 12, color: Colors.white60),
                                const SizedBox(width: 4),
                                Text('${reward.milesCost - miles.balance} more', style: AppTheme.body(size: 10, color: Colors.white60)),
                              ]),
                            ),
                        ),
                      ])),
                    ]),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Miles Activity Timeline
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Miles Activity', style: AppTheme.headline(size: 18))),
            const SizedBox(height: 12),
            ...miles.history.map((activity) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TimelineTile(
                isFirst: miles.history.first == activity,
                isLast: miles.history.last == activity,
                indicatorStyle: IndicatorStyle(
                  width: 14, height: 14,
                  color: activity.type == 'earned' ? AppColors.primary : AppColors.accent,
                ),
                beforeLineStyle: LineStyle(color: AppColors.divider, thickness: 2),
                endChild: Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(activity.description, style: AppTheme.label(size: 13)),
                      Text(activity.date, style: AppTheme.body(size: 11, color: AppColors.textLight)),
                    ])),
                    Text(
                      '${activity.type == 'earned' ? '+' : '-'}${activity.miles}',
                      style: AppTheme.label(size: 16, color: activity.type == 'earned' ? AppColors.primary : AppColors.accent),
                    ),
                  ]),
                ),
              ),
            )),
            const SizedBox(height: 16),
            // Active Challenges Preview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Text('Active Challenges', style: AppTheme.headline(size: 18)),
                const Spacer(),
                InkWell(onTap: () {}, child: Text('View All', style: AppTheme.label(size: 13, color: AppColors.primary))),
              ]),
            ),
            const SizedBox(height: 12),
            _challengePreview('Visit 3 Waterfalls', 0.66, '+500 miles', 'https://picsum.photos/seed/waterfall_ch/100/100'),
            _challengePreview('Book a Local Guide', 0.0, '+300 miles', 'https://picsum.photos/seed/guide_ch/100/100'),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  Widget _earnCard(IconData icon, String label, String miles, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AppTheme.label(size: 11)),
            Text(miles, style: AppTheme.label(size: 13, color: AppColors.primary)),
          ])),
        ]),
      ),
    );
  }

  Widget _challengePreview(String title, double progress, String reward, String imageUrl) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(width: 50, height: 50, color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.emoji_events, color: AppColors.accent, size: 28)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTheme.label(size: 14)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation(AppColors.primary), minHeight: 6),
          ),
          const SizedBox(height: 4),
          Text('${(progress * 100).toInt()}% complete', style: AppTheme.body(size: 10, color: AppColors.textLight)),
        ])),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
          child: Text(reward, style: AppTheme.label(size: 10, color: AppColors.accent)),
        ),
      ]),
    );
  }

  IconData _tierIcon(int index) {
    switch (index) {
      case 0: return Icons.grass;
      case 1: return Icons.eco;
      case 2: return Icons.terrain;
      case 3: return Icons.star;
      default: return Icons.grass;
    }
  }

  Color _tierColor(int index) {
    switch (index) {
      case 0: return AppColors.textSecondary;
      case 1: return AppColors.primary;
      case 2: return const Color(0xFF0891B2);
      case 3: return Colors.amber;
      default: return AppColors.textSecondary;
    }
  }
}

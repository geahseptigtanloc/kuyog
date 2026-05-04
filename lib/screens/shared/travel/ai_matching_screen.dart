import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';
import '../../../models/tour_operator.dart';
import '../../../providers/travel_provider.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_mascot.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../../tourist/guide_profile_screen.dart';

class AIMatchingScreen extends StatefulWidget {
  final String? nextRoute;
  final VoidCallback? onBack;
  
  const AIMatchingScreen({super.key, this.nextRoute, this.onBack});

  @override
  State<AIMatchingScreen> createState() => _AIMatchingScreenState();
}

class _AIMatchingScreenState extends State<AIMatchingScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _pulseCtrl;
  late AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    
    // Simulate AI thinking
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingState();

    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final guides = provider.getMatchedGuides();
        final operators = provider.guideType == 'regional' ? provider.getMatchedOperators() : <TourOperator>[];
        final hasOperators = operators.isNotEmpty;

        return DefaultTabController(
          length: hasOperators ? 2 : 1,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: KuyogAppBar(
              title: 'Your Perfect Match',
              leading: widget.onBack != null
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                      onPressed: widget.onBack,
                    )
                  : (Navigator.canPop(context) 
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                          onPressed: () => Navigator.pop(context),
                        )
                      : null),
              bottom: hasOperators ? TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Regional Guides'),
                  Tab(text: 'Tour Operators'),
                ],
              ) : null,
            ),
            body: hasOperators ? TabBarView(
              children: [
                _buildGuideList(guides, provider),
                _buildOperatorList(operators, provider),
              ],
            ) : _buildGuideList(guides, provider),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (ctx, child) => Container(
                    width: 150 + (_pulseCtrl.value * 20),
                    height: 150 + (_pulseCtrl.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1 * (1 - _pulseCtrl.value)),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (ctx, child) => Transform.rotate(
                    angle: _rotateCtrl.value * 2 * pi,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2, style: BorderStyle.solid),
                      ),
                    ),
                  ),
                ),
                const DurieMascot(size: 80),
              ],
            ),
            const SizedBox(height: 32),
            Text('Analyzing your preferences...', style: AppTheme.headline(size: 20, color: AppColors.primary)),
            const SizedBox(height: 12),
            Text('Finding the best guides for your trip', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.primary.withOpacity(0.2),
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideList(List<Guide> guides, TravelProvider provider) {
    if (guides.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text('No exact matches found', style: AppTheme.headline(size: 20)),
              const SizedBox(height: 8),
              Text('Try adjusting your travel type or guide preferences.', textAlign: TextAlign.center, style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: guides.length,
      itemBuilder: (context, index) => _buildGuideCard(guides[index], provider, index),
    );
  }

  Widget _buildGuideCard(Guide guide, TravelProvider provider, int index) {
    bool isTopMatch = index == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Banner
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: guide.bannerUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider, height: 160),
                errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1), height: 160),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: isTopMatch ? AppColors.accent : Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(AppRadius.pill)),
                  child: Row(
                    children: [
                      Icon(isTopMatch ? Icons.star : Icons.check_circle, size: 14, color: isTopMatch ? Colors.white : AppColors.primary),
                      const SizedBox(width: 4),
                      Text('${guide.matchScore}% Match', style: AppTheme.label(size: 12, color: isTopMatch ? Colors.white : AppColors.primary)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12, left: 12, right: 12,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(guide.photoUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(guide.name, style: AppTheme.headline(size: 18, color: Colors.white))),
                              if (guide.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 16, color: Colors.blue),
                              ],
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 12, color: Colors.white70),
                              const SizedBox(width: 4),
                              Expanded(child: Text(guide.city, style: AppTheme.body(size: 12, color: Colors.white70))),
                            ],
                          ),
                          if (provider.travelType == 'group') ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.group, size: 12, color: AppColors.accent),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Available for groups of up to ${guide.maxGroupSize} people',
                                    style: AppTheme.label(size: 10, color: AppColors.accent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem(Icons.star, guide.rating.toString(), 'Rating'),
                    _statItem(Icons.map, guide.tripCount.toString(), 'Trips'),
                    _statItem(Icons.group, 'Up to ${guide.maxGroupSize}', 'Group Size'),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Why this is a good match:', style: AppTheme.label(size: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: provider.userPrefs.map((pref) {
                    bool matches = guide.matchTags.contains(pref);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: matches ? AppColors.primary.withOpacity(0.1) : AppColors.divider,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: matches ? AppColors.primary : Colors.transparent),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (matches) const Icon(Icons.check, size: 12, color: AppColors.primary),
                          if (matches) const SizedBox(width: 4),
                          Text(pref, style: AppTheme.label(size: 11, color: matches ? AppColors.primary : AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.selectGuide(guide.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GuideProfileScreen(guide: guide)),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Select Guide'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorList(List<TourOperator> operators, TravelProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: operators.length,
      itemBuilder: (context, index) => _buildOperatorCard(operators[index], index),
    );
  }

  Widget _buildOperatorCard(TourOperator op, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: op.bannerUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider, height: 140),
                errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1), height: 140),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12, left: 12, right: 12,
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(4),
                      child: CachedNetworkImage(imageUrl: op.logoUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(op.companyName, style: AppTheme.headline(size: 16, color: Colors.white)),
                          Row(
                            children: [
                              if (op.dotAccredited) Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                                child: Text('DOT Accredited', style: AppTheme.label(size: 9, color: Colors.white)),
                              ),
                              Text('${op.matchScore}% Match', style: AppTheme.label(size: 11, color: AppColors.accent)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(op.description, style: AppTheme.body(size: 13, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${op.packages.length} Tour Packages', style: AppTheme.label(size: 13)),
                    TextButton(
                      onPressed: () {},
                      child: Text('View Profile', style: AppTheme.label(size: 13, color: AppColors.primary)),
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

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.headline(size: 16)),
        Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../providers/role_provider.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../../../models/itinerary.dart';
import '../../../models/tour_operator.dart';
import '../../../data/mock_data.dart';
import '../../../providers/travel_provider.dart';
import 'travel_type_screen.dart';
import 'group_setup_screen.dart';
import 'ai_matching_screen.dart';
import '../itinerary/tourist_itinerary_hub_screen.dart';
import '../itinerary/guide_itinerary_hub_screen.dart';
import '../itinerary/itinerary_create_screen.dart';
import '../itinerary/itinerary_browse_screen.dart';

enum TravelSubPage {
  main,
  itineraries,
  guideType,
  groupSetup,
  aiMatching,
}

class TravelHubScreen extends StatefulWidget {
  const TravelHubScreen({super.key});

  @override
  State<TravelHubScreen> createState() => _TravelHubScreenState();
}

class _TravelHubScreenState extends State<TravelHubScreen> {
  List<Itinerary> _recentItineraries = [];
  List<TourOperator> _tourOperators = [];
  bool _isLoading = true;
  List<TravelSubPage> _subPageStack = [TravelSubPage.main];

  TravelSubPage get _currentSubPage => _subPageStack.last;

  void _pushSubPage(TravelSubPage page) {
    setState(() => _subPageStack.add(page));
  }

  void _popSubPage() {
    if (_subPageStack.length > 1) {
      setState(() => _subPageStack.removeLast());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final itineraries = await MockData.getItineraries();
    final operators = await MockData.getTourOperators();
    if (mounted) {
      setState(() {
        _recentItineraries = itineraries.take(3).toList();
        _tourOperators = operators;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>().currentRole;

    return PopScope(
      canPop: _subPageStack.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _subPageStack.length > 1) {
          _popSubPage();
        }
      },
      child: _buildCurrentPage(role),
    );
  }

  Widget _buildCurrentPage(UserRole role) {
    switch (_currentSubPage) {
      case TravelSubPage.itineraries:
        if (role == UserRole.guide) {
          return GuideItineraryHubScreen(onBack: _popSubPage);
        }
        return TouristItineraryHubScreen(
          onBack: _popSubPage,
          onFindGuide: () => _pushSubPage(TravelSubPage.guideType),
        );
      case TravelSubPage.guideType:
        return TravelTypeScreen(
          onBack: _popSubPage,
          onContinue: (travelType, guideType) {
            context.read<TravelProvider>().setTravelAndGuideType(travelType, guideType);
            if (travelType == 'group') {
              _pushSubPage(TravelSubPage.groupSetup);
            } else {
              _pushSubPage(TravelSubPage.aiMatching);
            }
          },
        );
      case TravelSubPage.groupSetup:
        return GroupSetupScreen(
          onBack: _popSubPage,
          onContinue: () => _pushSubPage(TravelSubPage.aiMatching),
        );
      case TravelSubPage.aiMatching:
        return AIMatchingScreen(
          onBack: _popSubPage,
        );
      case TravelSubPage.main:
      default:
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const KuyogAppBar(
            title: 'Travel',
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: role == UserRole.guide ? _buildGuideHub() : _buildTouristHub(),
                  ),
                ),
        );
    }
  }

  Widget _buildTouristHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('How are you traveling?'),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildTravelTypeCard(
                  icon: Icons.person_outline,
                  label: 'Solo Trip',
                  description: 'Just you, at your own pace.',
                  color: AppColors.primary,
                  onTap: () => _pushSubPage(TravelSubPage.guideType),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTravelTypeCard(
                  icon: Icons.group_outlined,
                  label: 'Group Trip',
                  description: 'Travel with friends or family.',
                  color: AppColors.accent,
                  onTap: () => _pushSubPage(TravelSubPage.guideType),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildGuideTypeComparison(),
        const SizedBox(height: 24),
        _buildAIQuickAccess(),
        const SizedBox(height: 24),
        _buildSectionHeader('Tour Operators', trailing: 'See All'),
        Text('DOT-accredited operators promoting Mindanao tourism.', 
          style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        _buildTourOperatorsList(),
        const SizedBox(height: 24),
        _buildSectionHeader('My Itineraries', trailing: 'See All', onTrailingTap: () {
           _pushSubPage(TravelSubPage.itineraries);
        }),
        _buildItineraryStats(),
        const SizedBox(height: 12),
        ..._recentItineraries.map((it) => _buildItineraryCard(it)).toList(),
        const SizedBox(height: 24),
        _buildSectionHeader('Popular in Mindanao', trailing: 'Browse All'),
        const SizedBox(height: 12),
        _buildRecommendedItineraries(),
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Widget _buildGuideHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('My Itineraries', trailing: 'See All', onTrailingTap: () {
           _pushSubPage(TravelSubPage.itineraries);
        }),
        _buildItineraryStats(isGuide: true),
        const SizedBox(height: 12),
        ..._recentItineraries.map((it) => _buildItineraryCard(it, isGuide: true)).toList(),
        const SizedBox(height: 24),
        _buildSectionHeader('Co-Create Requests'),
        _buildCoCreateRequests(),
        const SizedBox(height: 24),
        _buildSectionHeader('Create Options'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                label: 'Create Template',
                color: AppColors.primary,
                icon: Icons.add_to_photos_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryCreateScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOptionCard(
                label: 'Browse Hub',
                color: Colors.amber[700]!,
                icon: Icons.search_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryBrowseScreen())),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('My Templates'),
        const SizedBox(height: 12),
        _buildTemplatesList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing, VoidCallback? onTrailingTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.headline(size: 18)),
        if (trailing != null)
          TextButton(
            onPressed: onTrailingTap ?? () {},
            child: Text(trailing, style: AppTheme.label(size: 14, color: AppColors.primary)),
          ),
      ],
    );
  }

  Widget _buildTravelTypeCard({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 16),
            Text(label, style: AppTheme.label(size: 16)),
            const SizedBox(height: 4),
            Text(description, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideTypeComparison() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text('What is the difference between guide types?', 
          style: AppTheme.body(size: 13, color: AppColors.primary, weight: FontWeight.w600)),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildGuideTypeInfo(
                    'Community',
                    'LGU endorsed, 7-day training. Best for local cultural immersion.',
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: _buildGuideTypeInfo(
                    'Regional',
                    'DOT accredited, 30-day training. Covers multi-province tours.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideTypeInfo(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.label(size: 14)),
        const SizedBox(height: 4),
        Text(desc, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildAIQuickAccess() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -10,
            child: Opacity(
              opacity: 0.2,
              child: Icon(Icons.psychology, size: 120, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Find Your Guide', style: AppTheme.headline(size: 18, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Let our system match you with the perfect local guide.', 
                  style: AppTheme.body(size: 13, color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 80), // Space for possible Durie illustration
                    ElevatedButton(
                      onPressed: () => _pushSubPage(TravelSubPage.guideType),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                      ),
                      child: const Text('Find My Guide'),
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

  Widget _buildTourOperatorsList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tourOperators.length,
        itemBuilder: (context, index) {
          final op = _tourOperators[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(op.logoUrl),
                ),
                const SizedBox(height: 8),
                Text(op.companyName, style: AppTheme.label(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.verified, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text('DOT Accredited', style: AppTheme.body(size: 10, color: Colors.blue)),
                  ],
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: const Text('View Packages', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItineraryStats({bool isGuide = false}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _statsChip(isGuide ? 'Assigned: 4' : 'Active: 2'),
        _statsChip(isGuide ? 'Templates: 12' : 'Completed: 5'),
        _statsChip('Drafts: 1'),
      ],
    );
  }

  Widget _statsChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
    );
  }

  Widget _buildItineraryCard(Itinerary it, {bool isGuide = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: CachedNetworkImage(
              imageUrl: it.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.background),
              errorWidget: (context, url, error) => Container(
                color: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primary, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(it.title, style: AppTheme.label(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(it.dateRange, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(it.status, style: AppTheme.label(size: 10, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: AppColors.primary),
            ),
            child: Text(it.status == 'Active' ? 'Continue' : 'View', style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedItineraries() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recentItineraries.length,
        itemBuilder: (context, index) {
          final it = _recentItineraries[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: it.imageUrl,
                    width: 160,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.background),
                    errorWidget: (context, url, error) => Container(color: Colors.grey[300]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.title, style: AppTheme.label(size: 14, color: Colors.white)),
                        Text('${it.stopsCount} stops', style: AppTheme.body(size: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      child: const Icon(Icons.add, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoCreateRequests() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const Icon(Icons.handshake_outlined, size: 48, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text('No co-create requests yet.', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildOptionCard({required String label, required Color color, required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppTheme.label(size: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatesList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.description_outlined, color: AppColors.textLight),
          );
        },
      ),
    );
  }
}

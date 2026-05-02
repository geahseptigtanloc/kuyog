import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/tour_operator.dart';
import '../../../widgets/kuyog_back_button.dart';

class TourOperatorProfileScreen extends StatelessWidget {
  final TourOperator operator;

  const TourOperatorProfileScreen({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderInfo(),
                _buildAboutSection(),
                _buildPackagesSection(context),
                _buildReviewsSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.chat, color: Colors.white),
        label: Text('Chat Operator', style: AppTheme.label(size: 14, color: Colors.white)),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: KuyogBackButton(onTap: () => Navigator.pop(context), color: Colors.white),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: operator.bannerUrl,
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.cardHover,
                image: DecorationImage(image: CachedNetworkImageProvider(operator.logoUrl), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(operator.companyName, style: AppTheme.headline(size: 24)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(operator.location, style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (operator.dotAccredited) _badge('DOT Accredited', AppColors.touristBlue),
                const SizedBox(width: 8),
                if (operator.businessPermitVerified) _badge('Verified Business', AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: AppTheme.label(size: 11, color: color)),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About Us', style: AppTheme.headline(size: 18)),
          const SizedBox(height: 8),
          Text(operator.description, style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(Icons.star, operator.rating.toString(), 'Rating'),
              _statItem(Icons.groups, operator.guideCount.toString(), 'Guides'),
              _statItem(Icons.map, operator.totalTours.toString(), 'Tours Completed'),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.headline(size: 18)),
        Text(label, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildPackagesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Tour Packages', style: AppTheme.headline(size: 18)),
        ),
        const SizedBox(height: 16),
        ...operator.packages.map((pkg) => _packageCard(pkg, context)),
      ],
    );
  }

  Widget _packageCard(TourPackage pkg, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: pkg.photoUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(pkg.name, style: AppTheme.label(size: 16))),
                    Text('₱${pkg.groupPricePerPerson.toInt()}/pax', style: AppTheme.headline(size: 16, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(pkg.duration, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                    const SizedBox(width: 16),
                    const Icon(Icons.group, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('Up to ${pkg.maxPax} pax', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(pkg.description, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Package selected!')));
                    },
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
                    child: Text('Select Package', style: AppTheme.label(size: 14, color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviews (${operator.reviewCount})', style: AppTheme.headline(size: 18)),
          const SizedBox(height: 16),
          // Mock reviews
          _reviewItem('Carlos M.', 'Amazing experience with their guides. Very professional and the food was great!', 5),
          const Divider(),
          _reviewItem('Sarah T.', 'Well organized group trip. The zipline was the highlight.', 4),
        ],
      ),
    );
  }

  Widget _reviewItem(String name, String text, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: AppColors.primaryLight.withOpacity(0.2), child: Text(name[0], style: AppTheme.label(size: 12, color: AppColors.primary))),
              const SizedBox(width: 8),
              Text(name, style: AppTheme.label(size: 14)),
              const Spacer(),
              Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < rating ? AppColors.accent : AppColors.divider))),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

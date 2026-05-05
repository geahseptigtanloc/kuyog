import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class DiscoverDavaoScreen extends StatelessWidget {
  const DiscoverDavaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Discover Davao Region', style: AppTheme.headline(size: 18, color: Colors.white)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/seed/davao_region/800/600',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black26, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('Welcome to Davao Region', style: AppTheme.headline(size: 24)),
                const SizedBox(height: 12),
                Text(
                  'The Davao Region, designated as Region XI, is situated in the southeastern portion of Mindanao. It is known for its diverse landscapes, ranging from white-sand beaches and islands to rugged mountains and forests. It is home to Mount Apo, the highest peak in the Philippines, and is celebrated as the Durian Capital and the Cacao Capital of the country.',
                  style: AppTheme.body(size: 14, height: 1.6),
                ),
                const SizedBox(height: 24),
                Text('Provinces', style: AppTheme.headline(size: 20)),
                const SizedBox(height: 12),
                _provinceCard('Davao del Sur', 'Home to Mt. Apo and vibrant city life.', 'https://picsum.photos/seed/davsur/400/200'),
                _provinceCard('Davao del Norte', 'The Banana Capital, known for Samal Island.', 'https://picsum.photos/seed/davnor/400/200'),
                _provinceCard('Davao Oriental', 'Pristine beaches, Mati, and Aliwagwag Falls.', 'https://picsum.photos/seed/davor/400/200'),
                _provinceCard('Davao de Oro', 'Rich in gold, hot springs, and natural beauty.', 'https://picsum.photos/seed/davoro/400/200'),
                _provinceCard('Davao Occidental', 'Untouched coastlines and cultural heritage.', 'https://picsum.photos/seed/davocc/400/200'),
                const SizedBox(height: 24),
                Text('Must-Try Delicacies', style: AppTheme.headline(size: 20)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _delicacyCard('Durian', 'The King of Fruits', 'https://picsum.photos/seed/durian/150/150'),
                      _delicacyCard('Malagos Chocolate', 'Award-winning Cacao', 'https://picsum.photos/seed/cacao/150/150'),
                      _delicacyCard('Pomelo', 'Sweet and juicy', 'https://picsum.photos/seed/pomelo/150/150'),
                      _delicacyCard('Kinilaw', 'Fresh Tuna Ceviche', 'https://picsum.photos/seed/kinilaw/150/150'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _provinceCard(String name, String desc, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.cardHover,
        image: DecorationImage(image: CachedNetworkImageProvider(imgUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black87, Colors.transparent]),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTheme.headline(size: 18, color: Colors.white)),
            const SizedBox(height: 4),
            SizedBox(
              width: 200,
              child: Text(desc, style: AppTheme.body(size: 12, color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _delicacyCard(String name, String desc, String imgUrl) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
            child: CachedNetworkImage(imageUrl: imgUrl, height: 100, width: 140, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTheme.label(size: 14)),
                const SizedBox(height: 2),
                Text(desc, style: AppTheme.body(size: 11, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

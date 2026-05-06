import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'roam_free_form_screen.dart';
import 'roam_free_guide_matching_screen.dart';

class RoamFreeScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const RoamFreeScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
              child: Row(
                children: [
                  KuyogBackButton(
                    onTap: onBack ?? () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text('Roam Free', style: AppTheme.headline(size: 22)),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How do you want\nto explore?',
                      style: AppTheme.headline(size: 28, height: 1.2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose your adventure style and we\'ll help you plan the perfect Davao trip.',
                      style: AppTheme.body(
                        size: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Option 1: Explore on your own
                    _PathCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&q=80&w=800',
                      pill: 'AI-Assisted',
                      title: 'Explore on your own',
                      subtitle:
                          'AI-built itinerary, you navigate.\nBest for experienced travelers.',
                      icon: Icons.explore,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoamFreeFormScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Option 2: Go with a local guide
                    _PathCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&q=80&w=800',
                      pill: 'Local Expert',
                      title: 'Go with a local guide',
                      subtitle:
                          'Get matched with a certified local\nguide who plans with you.',
                      icon: Icons.person_pin,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RoamFreeGuideMatchingScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  final String imageUrl;
  final String pill;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PathCard({
    required this.imageUrl,
    required this.pill,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.primary),
              errorWidget: (c, u, e) => Container(color: AppColors.primary),
            ),
            // Overlay
            Container(color: Colors.black.withAlpha(110)),
            // Content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      pill,
                      style: AppTheme.label(
                        size: 11,
                        color: AppColors.primary,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: AppTheme.headline(size: 22, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.body(
                      size: 13,
                      color: Colors.white.withAlpha(204),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

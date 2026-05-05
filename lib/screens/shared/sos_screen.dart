import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../widgets/core/kuyog_card.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
        title: Text(
          'Emergency SOS',
          style: AppTheme.headline(size: 20, color: AppColors.error),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_rounded, size: 80, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Are you in an emergency?', style: AppTheme.headline(size: 24)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Select an option below to immediately connect with the appropriate authorities in the Davao Region. Your location will be shared automatically.',
              style: AppTheme.body(size: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            
            _sosAction(
              context,
              icon: Icons.local_police,
              title: 'Police Assistance',
              number: '911',
              color: const Color(0xFF1E3A8A), // Police Blue
            ),
            const SizedBox(height: AppSpacing.lg),
            _sosAction(
              context,
              icon: Icons.local_hospital,
              title: 'Medical Emergency',
              number: '911',
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            _sosAction(
              context,
              icon: Icons.fire_truck,
              title: 'Fire Department',
              number: '911',
              color: const Color(0xFFC2410C), // Orange Red
            ),
            const SizedBox(height: AppSpacing.lg),
            _sosAction(
              context,
              icon: Icons.tour,
              title: 'Tourist Police Unit (Davao)',
              number: '(082) 222-1111',
              color: AppColors.touristBlue,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            
            KuyogCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              border: Border.all(color: AppColors.error.withAlpha(76)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.error, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text('Your Current Location', style: AppTheme.headline(size: 16)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Roxas Night Market, Davao City', style: AppTheme.label(size: 14)),
                  Text(
                    'Coordinates: 7.0722° N, 125.6128° E',
                    style: AppTheme.body(size: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sosAction(BuildContext context,
      {required IconData icon,
      required String title,
      required String number,
      required Color color}) {
    return KuyogCard(
      onTap: () {
        // Mock calling functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calling $title ($number)...'),
            backgroundColor: color,
          ),
        );
      },
      color: color,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
      shadow: [
        BoxShadow(
          color: color.withAlpha(76),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.headline(size: 18, color: Colors.white),
                ),
                Text(
                  number,
                  style: AppTheme.label(
                    size: 14,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.phone, color: Colors.white),
        ],
      ),
    );
  }
}



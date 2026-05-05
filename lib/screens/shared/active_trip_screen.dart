import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_button.dart';
import '../../widgets/core/kuyog_section_header.dart';
import 'sos_screen.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
        title: Text('Active Trip', style: AppTheme.headline(size: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Status
            KuyogCard(
              color: AppColors.primary,
              shadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(77),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_walk, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ongoing Activity',
                            style: AppTheme.body(
                              size: 12,
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                          Text(
                            'Mt. Apo Trekking',
                            style: AppTheme.headline(size: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: Colors.white.withAlpha(51),
                    valueColor: const AlwaysStoppedAnimation(Colors.amber),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Day 1 of 3',
                        style: AppTheme.body(size: 12, color: Colors.white),
                      ),
                      Text(
                        'Next stop: Camp 1',
                        style: AppTheme.body(size: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // Your Guide
            const KuyogSectionHeader(title: 'Your Guide'),
            KuyogCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://picsum.photos/seed/guide1/100/100'),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Juan Dela Cruz', style: AppTheme.label(size: 16)),
                        Text(
                          'DOT Accredited Guide',
                          style: AppTheme.body(
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat, color: AppColors.primary),
                    onPressed: () {
                      // Navigate to chat
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // Itinerary
            const KuyogSectionHeader(title: 'Today\'s Itinerary'),
            _itineraryItem('08:00 AM', 'Meetup at Basecamp', true),
            _itineraryItem('09:00 AM', 'Start Trek', true),
            _itineraryItem('12:00 PM', 'Lunch at the falls', false, isCurrent: true),
            _itineraryItem('04:00 PM', 'Arrive at Camp 1', false),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            // SOS Button
            KuyogButton(
              label: 'EMERGENCY SOS',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SOSScreen()),
                );
              },
              variant: KuyogButtonVariant.destructive,
              icon: Icons.warning_rounded,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itineraryItem(String time, String title, bool isDone, {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75,
            child: Text(
              time,
              style: AppTheme.body(
                size: 12,
                color: isDone || isCurrent ? AppColors.textPrimary : AppColors.textLight,
                weight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.accent
                      : (isDone ? AppColors.primary : AppColors.divider),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: isDone ? AppColors.primary : AppColors.divider,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: KuyogCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              radius: AppRadius.md,
              color: isCurrent ? AppColors.accent.withAlpha(20) : Colors.white,
              border: Border.all(
                color: isCurrent
                    ? AppColors.accent
                    : (isDone ? AppColors.primary.withAlpha(77) : AppColors.divider),
              ),
              shadow: isCurrent ? AppShadows.cardHover : AppShadows.card,
              child: Text(
                title,
                style: AppTheme.label(
                  size: 14,
                  color: isDone || isCurrent ? AppColors.textPrimary : AppColors.textLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


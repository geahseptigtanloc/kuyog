import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_button.dart';
import '../../widgets/core/kuyog_section_header.dart';
import 'sos_screen.dart';
import '../../models/tour_booking.dart';

class ActiveTripScreen extends StatelessWidget {
  final TourBooking trip;

  const ActiveTripScreen({super.key, required this.trip});

  DateTime? _parseTime(String timeStr) {
    try {
      final cleanTime = timeStr.trim().toUpperCase();
      final now = DateTime.now();
      final format = DateFormat("h:mm a");
      final time = format.parse(cleanTime);
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayData = trip.fullItinerary.isNotEmpty ? trip.fullItinerary[0] : null;
    final stops = dayData != null ? (dayData['stops'] as List<dynamic>?) : null;
    
    int completedStops = 0;
    int? currentStopIndex;
    
    if (stops != null && stops.isNotEmpty) {
      for (int i = 0; i < stops.length; i++) {
        final stopTime = _parseTime(stops[i]['time'] ?? '');
        if (stopTime != null) {
          if (now.isAfter(stopTime)) {
            completedStops++;
            if (i < stops.length - 1) {
              final nextStopTime = _parseTime(stops[i + 1]['time'] ?? '');
              if (nextStopTime != null && now.isBefore(nextStopTime)) {
                currentStopIndex = i;
              }
            } else {
              currentStopIndex = i;
            }
          }
        }
      }
    }

    final progress = stops != null && stops.isNotEmpty 
        ? (completedStops / stops.length).clamp(0.1, 1.0) 
        : 0.1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
        title: Text(trip.status == 'active' ? 'Active Trip' : 'Trip Details', 
                   style: AppTheme.headline(size: 20)),
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
            KuyogCard(
              color: trip.status == 'active' ? AppColors.primary : AppColors.accent,
              shadow: [
                BoxShadow(
                  color: (trip.status == 'active' ? AppColors.primary : AppColors.accent).withAlpha(77),
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
                        child: Icon(trip.status == 'active' ? Icons.directions_walk : Icons.event_available, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.status == 'active' ? 'Ongoing Activity' : 'Upcoming Trip',
                              style: AppTheme.body(
                                size: 12,
                                color: Colors.white.withAlpha(204),
                              ),
                            ),
                            Text(
                              trip.packageName,
                              style: AppTheme.headline(size: 18, color: Colors.white),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (trip.status == 'active') ...[
                    const SizedBox(height: AppSpacing.xl),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withAlpha(51),
                      valueColor: const AlwaysStoppedAnimation(Colors.amber),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Day 1 of ${trip.fullItinerary.length}',
                          style: AppTheme.body(size: 12, color: Colors.white),
                        ),
                        Text(
                          currentStopIndex != null 
                            ? 'Currently: ${stops![currentStopIndex]['activity']}'
                            : (progress > 0.9 ? 'Finishing soon' : 'Starting soon'),
                          style: AppTheme.body(size: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'This trip starts on ${DateFormat('dd/MM/yyyy').format(trip.date)}. Get ready!',
                      style: AppTheme.body(size: 13, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            const KuyogSectionHeader(title: 'Your Operator'),
            KuyogCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: trip.operatorPhotoUrl.isNotEmpty 
                      ? CachedNetworkImageProvider(trip.operatorPhotoUrl)
                      : const NetworkImage('https://picsum.photos/seed/operator/100/100') as ImageProvider,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.operatorName, style: AppTheme.label(size: 16)),
                        Text(
                          'Verified Tour Operator',
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            KuyogSectionHeader(title: dayData != null ? 'Itinerary: ${dayData['title'] ?? "Day 1"}' : 'Trip Itinerary'),
            if (stops != null && stops.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  final stop = stops[index];
                  final stopTime = _parseTime(stop['time'] ?? '');
                  final isDone = stopTime != null && now.isAfter(stopTime);
                  final isCurrent = index == currentStopIndex;
                  
                  return _itineraryItem(
                    stop['time'] ?? '--:--', 
                    stop['activity'] ?? 'No activity', 
                    isDone,
                    isCurrent: isCurrent,
                    location: stop['location']
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('Itinerary details coming soon.', style: AppTheme.body(color: AppColors.textLight)),
                ),
              ),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            if (trip.status == 'active')
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

  Widget _itineraryItem(String time, String title, bool isDone, {bool isCurrent = false, String? location}) {
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
                height: 60,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.label(
                      size: 14,
                      color: isDone || isCurrent ? AppColors.textPrimary : AppColors.textLight,
                    ),
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 10, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTheme.body(size: 11, color: AppColors.textLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

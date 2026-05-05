import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import '../../providers/booking_provider.dart';
import '../../models/tour_booking.dart';
import 'active_trip_screen.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_empty_state.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 0;
  final _tabs = ['Upcoming', 'Past Trips'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'My Trips'),
      body: Consumer<BookingProvider>(builder: (c, bp, _) {
        return Column(
          children: [
            // Pill Tabs
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: 12),
              child: Row(
                children: List.generate(
                  _tabs.length,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i != _tabs.length - 1 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 44,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTab == i
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _selectedTab == i ? AppColors.primary : AppColors.divider,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[i],
                              style: AppTheme.body(
                                size: 14,
                                weight: FontWeight.w600,
                                color: _selectedTab == i
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Trip List
            Expanded(
              child: _selectedTab == 0
                  ? _tripList(context, bp.upcomingBookings, isUpcoming: true)
                  : _tripList(context, bp.pastBookings, isUpcoming: false),
            ),
          ],
        );
      }),
    );
  }

  Widget _tripList(BuildContext context, List<TourBooking> trips,
      {required bool isUpcoming}) {
    if (trips.isEmpty) {
      return KuyogEmptyState(
        icon: isUpcoming ? Icons.flight_takeoff : Icons.history,
        title: isUpcoming ? 'No upcoming trips' : 'No past trips yet',
        message: isUpcoming
            ? 'Book a tour to get started!'
            : 'Your completed trips will appear here',
        actionLabel: isUpcoming ? 'Explore Tours' : null,
        onAction: isUpcoming ? () {} : null,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: trips.length,
      itemBuilder: (c, i) => _tripCard(context, trips[i], isUpcoming),
    );
  }

  Widget _tripCard(BuildContext context, TourBooking trip, bool isUpcoming) {
    final bgColor = isUpcoming ? const Color(0xFFE7F0E8) : AppColors.accent.withAlpha(26);
    final borderColor = isUpcoming ? const Color(0xFFC4D7C7) : AppColors.accent.withAlpha(51);
    final titleColor = isUpcoming ? const Color(0xFF2D5A3A) : const Color(0xFF92400E);
    final subtitleColor = isUpcoming ? const Color(0xFF6B8E6F) : const Color(0xFFB45309);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (trip.status == 'active') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveTripScreen()));
          }
        },
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Circular Image centered at top
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: trip.photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.divider),
                    errorWidget: (c, u, e) => Container(color: AppColors.primary.withAlpha(26)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Centered Texts
              Text(
                trip.packageName,
                textAlign: TextAlign.center,
                style: AppTheme.headline(size: 18, color: titleColor),
              ),
              const SizedBox(height: 6),
              Text(
                trip.operatorName,
                style: AppTheme.body(size: 14, color: subtitleColor, weight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              // Meta Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _metaPill(Icons.calendar_today, DateFormat('MMM d').format(trip.date), titleColor),
                  const SizedBox(width: 8),
                  _metaPill(Icons.group, '${trip.groupSize} pax', titleColor),
                  const SizedBox(width: 8),
                  _metaPill(Icons.payments_outlined, '₱${trip.totalPrice.toInt()}', titleColor),
                ],
              ),
              const SizedBox(height: 24),
              // Show Details Button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withAlpha(77),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Show details',
                    style: AppTheme.label(size: 14, color: Colors.white, weight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Booking Ref: ${trip.bookingRef}',
                style: AppTheme.body(size: 10, color: subtitleColor.withAlpha(150)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metaPill(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(text, style: AppTheme.body(size: 10, color: color, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}

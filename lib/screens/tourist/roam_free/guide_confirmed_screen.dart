import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';
import '../../shared/chat/chat_list_screen.dart';
import '../../shared/my_trips_screen.dart';

class GuideConfirmedScreen extends StatelessWidget {
  final Guide guide;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final int totalStops;

  const GuideConfirmedScreen({
    super.key,
    required this.guide,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.totalStops,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  int get _totalDays => endDate.difference(startDate).inDays + 1;

  // Mock fee calculation
  int get _dailyRate => 1500;
  int get _totalGuideFee => _dailyRate * _totalDays;
  int get _holdingFee => 500;
  int get _remainingFee => _totalGuideFee - _holdingFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // X button to return home
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Success icon
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, size: 56, color: AppColors.success),
                    ),
                    const SizedBox(height: 20),
                    Text('Trip Confirmed!', style: AppTheme.headline(size: 26)),
                    const SizedBox(height: 6),
                    Text(
                      'Your itinerary is locked and your guide is ready.',
                      style: AppTheme.body(size: 14, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Guide card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withAlpha(30),
                          backgroundImage: CachedNetworkImageProvider(guide.photoUrl),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Your Guide', style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                            Text(guide.name, style: AppTheme.headline(size: 18)),
                            Text(guide.specialty, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                          ]),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, size: 20, color: AppColors.success),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    // Trip summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(children: [
                        _summaryRow(Icons.location_on, 'Destination', location),
                        const SizedBox(height: 10),
                        _summaryRow(Icons.calendar_today, 'Dates',
                            '${_formatDate(startDate)} - ${_formatDate(endDate)}'),
                        const SizedBox(height: 10),
                        _summaryRow(Icons.schedule, 'Duration', '$_totalDays days'),
                        const SizedBox(height: 10),
                        _summaryRow(Icons.place, 'Total Stops', '$totalStops destinations'),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    // Payment summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Payment Summary', style: AppTheme.headline(size: 16)),
                        const SizedBox(height: 14),
                        _paymentRow('Guide fee (P$_dailyRate x $_totalDays days)', 'P$_totalGuideFee'),
                        const SizedBox(height: 8),
                        _paymentRow('Holding fee paid', '- P$_holdingFee', isDeduction: true),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Amount Due', style: AppTheme.label(size: 15)),
                          Text('P$_remainingFee', style: AppTheme.headline(size: 18, color: AppColors.primary)),
                        ]),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(8),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Funds held in escrow — released to your guide 24 hours after you confirm trip completion.',
                                style: AppTheme.body(size: 11, color: AppColors.primary, height: 1.4),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatListScreen()),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: Text('Message Guide', style: AppTheme.label(size: 13, color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyTripsScreen()),
                      ),
                      icon: const Icon(Icons.luggage, size: 18),
                      label: Text('My Trips', style: AppTheme.label(size: 13, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 16, color: Colors.white70),
      const SizedBox(width: 10),
      Text(label, style: AppTheme.body(size: 12, color: Colors.white70)),
      const Spacer(),
      Text(value, style: AppTheme.label(size: 12, color: Colors.white)),
    ]);
  }

  Widget _paymentRow(String label, String amount, {bool isDeduction = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
      Text(amount, style: AppTheme.label(size: 13, color: isDeduction ? AppColors.success : AppColors.textPrimary)),
    ]);
  }
}

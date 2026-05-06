import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../models/guide.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'guide_planning_screen.dart';

class GuideWaitingScreen extends StatefulWidget {
  final Guide guide;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> interests;

  const GuideWaitingScreen({
    super.key,
    required this.guide,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.interests,
  });

  @override
  State<GuideWaitingScreen> createState() => _GuideWaitingScreenState();
}

class _GuideWaitingScreenState extends State<GuideWaitingScreen>
    with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate guide confirming after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _pulseController.stop();
        setState(() => _confirmed = true);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _onContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GuidePlanningScreen(
          guide: widget.guide,
          location: widget.location,
          startDate: widget.startDate,
          endDate: widget.endDate,
          interests: widget.interests,
        ),
      ),
    );
  }

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
              child: Row(children: [
                const KuyogBackButton(),
                const SizedBox(width: 8),
                Text('Guide Reservation', style: AppTheme.headline(size: 22)),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Guide avatar
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primary.withAlpha(30),
                      backgroundImage: CachedNetworkImageProvider(widget.guide.photoUrl),
                    ),
                    const SizedBox(height: 16),
                    Text(widget.guide.name, style: AppTheme.headline(size: 22)),
                    const SizedBox(height: 4),
                    Text(widget.guide.specialty,
                        style: AppTheme.body(size: 14, color: AppColors.textSecondary)),

                    const SizedBox(height: 28),

                    // Status card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _confirmed
                            ? AppColors.success.withAlpha(10)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: _confirmed
                              ? AppColors.success.withAlpha(60)
                              : AppColors.divider,
                        ),
                        boxShadow: AppShadows.card,
                      ),
                      child: _confirmed
                          ? Column(children: [
                              Container(
                                width: 56, height: 56,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 32),
                              ),
                              const SizedBox(height: 14),
                              Text('Guide Confirmed!', style: AppTheme.headline(size: 20, color: AppColors.success)),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.guide.name} has accepted your reservation and is ready to plan your trip.',
                                style: AppTheme.body(size: 13, color: AppColors.textSecondary, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ])
                          : Row(children: [
                              FadeTransition(
                                opacity: _pulseAnimation,
                                child: Container(
                                  width: 12, height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Waiting for confirmation...',
                                        style: AppTheme.label(size: 15)),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${widget.guide.name} has 5 hours to confirm your reservation.',
                                      style: AppTheme.body(size: 12, color: AppColors.textSecondary, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                    ),

                    const SizedBox(height: 16),

                    // Holding fee receipt
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(10),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.accent.withAlpha(40)),
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.receipt_long, color: AppColors.accent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Holding Fee Paid', style: AppTheme.label(size: 13, color: AppColors.accent)),
                            const SizedBox(height: 2),
                            Text('P500 — will be deducted from the final guide fee.',
                                style: AppTheme.body(size: 12, color: AppColors.textSecondary, height: 1.4)),
                          ]),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    // Trip details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(children: [
                        _tripDetailRow(Icons.location_on, 'Destination', widget.location),
                        const Divider(height: 20),
                        _tripDetailRow(Icons.calendar_today, 'Dates',
                            '${_formatDate(widget.startDate)} - ${_formatDate(widget.endDate)}'),
                        const Divider(height: 20),
                        _tripDetailRow(Icons.schedule, 'Duration',
                            '${widget.endDate.difference(widget.startDate).inDays + 1} days'),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    // Info note
                    if (!_confirmed)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(8),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'If the guide doesn\'t confirm, we\'ll automatically match you with the next available guide. Your holding fee will be rolled over.',
                              style: AppTheme.body(size: 12, color: AppColors.primary, height: 1.4),
                            ),
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
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.divider, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      child: Text('Cancel', style: AppTheme.label(size: 14, color: AppColors.textSecondary)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _confirmed ? _onContinue : null,
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: Text(_confirmed ? 'Plan Your Trip' : 'Waiting...',
                          style: AppTheme.label(size: 14, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.divider,
                        disabledForegroundColor: AppColors.textLight,
                        elevation: 0,
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

  Widget _tripDetailRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 12),
      Text(label, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: AppTheme.label(size: 13)),
    ]);
  }
}

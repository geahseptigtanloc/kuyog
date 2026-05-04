import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';

class ItineraryDetailScreen extends StatelessWidget {
  final String? title;
  final String? status;
  final Color? statusColor;
  final String? itineraryId;
  final bool isDraft;
  final bool isCollaborative;
  final dynamic preAssignedGuide;

  const ItineraryDetailScreen({
    super.key,
    this.title,
    this.status,
    this.statusColor,
    this.itineraryId,
    this.isDraft = false,
    this.isCollaborative = false,
    this.preAssignedGuide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  if (isCollaborative) _buildCollaborationBanner(),
                  const SizedBox(height: 24),
                  _buildDays(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(children: [
        KuyogBackButton(onTap: () => Navigator.pop(context)),
        const SizedBox(width: 12),
        Text('Itinerary Details', style: AppTheme.headline(size: 20)),
        const Spacer(),
        const Icon(Icons.share_outlined, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () => _showOptionsSheet(context),
        ),
      ]),
    );
  }

  Widget _buildHeader() {
    final displayStatus = isDraft ? 'Draft' : (status ?? 'Active');
    final displayStatusColor = isDraft ? AppColors.warning : (statusColor ?? AppColors.primary);
    final displayTitle = title ?? (isDraft ? 'New Collaborative Trip' : 'My Mindanao Adventure');
    final guideName = preAssignedGuide?.name ?? 'Rico Magbanua';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(displayTitle, style: AppTheme.headline(size: 24)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: displayStatusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text(displayStatus, style: AppTheme.label(size: 11, color: displayStatusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: AppColors.textLight),
              const SizedBox(width: 6),
              Text('May 15 - May 17, 2026', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColors.textLight),
              const SizedBox(width: 6),
              Text('Guide: $guideName', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.handshake, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Co-creating with ${preAssignedGuide?.name ?? "your guide"}. Any changes you make will be visible to them.',
              style: AppTheme.body(size: 12, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDays() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _daySection('Day 1 - Arrival & City Tour', [
            ('10:00 AM', 'Arrival at Francisco Bangoy International Airport', Icons.flight_land, false),
            ('12:00 PM', 'Lunch at Jack\'s Ridge', Icons.restaurant, false),
            ('2:30 PM', 'Visit Philippine Eagle Center', Icons.pets, false),
            ('5:00 PM', 'Check-in to Hotel', Icons.hotel, true),
          ]),
          const SizedBox(height: 24),
          _daySection('Day 2 - Island Hopping', [
            ('8:00 AM', 'Ferry to Samal Island', Icons.directions_boat, false),
            ('9:30 AM', 'Hagimit Falls', Icons.waterfall_chart, false),
            ('1:00 PM', 'Lunch at Paradise Island', Icons.restaurant, false),
            ('3:00 PM', 'Monfort Bat Cave', Icons.dark_mode, true),
          ]),
        ],
      ),
    );
  }

  Widget _daySection(String dayTitle, List<(String, String, IconData, bool)> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(dayTitle, style: AppTheme.headline(size: 18)),
        const SizedBox(height: 16),
        ...items.map((item) => _timelineItem(item.$1, item.$2, item.$3, item.$4)),
      ],
    );
  }

  Widget _timelineItem(String time, String title, IconData icon, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(time, style: AppTheme.label(size: 13, color: AppColors.textSecondary)),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 4),
              child: Text(title, style: AppTheme.body(size: 14)),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.primary),
                title: Text('Edit Itinerary', style: AppTheme.label(size: 16)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit mode activated'), backgroundColor: AppColors.primary));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: Text('Delete Itinerary', style: AppTheme.label(size: 16, color: AppColors.error)),
                onTap: () {
                  Navigator.pop(ctx); // Close sheet
                  Navigator.pop(context); // Close detail screen
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Itinerary deleted'), backgroundColor: AppColors.error));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

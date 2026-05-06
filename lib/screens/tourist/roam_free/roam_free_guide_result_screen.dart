import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/guide.dart';
import '../../../widgets/kuyog_back_button.dart';

class RoamFreeGuideResultScreen extends StatefulWidget {
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> interests;

  const RoamFreeGuideResultScreen({
    super.key,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.interests,
  });

  @override
  State<RoamFreeGuideResultScreen> createState() =>
      _RoamFreeGuideResultScreenState();
}

class _RoamFreeGuideResultScreenState
    extends State<RoamFreeGuideResultScreen> {
  List<Guide> _guides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    final all = await MockData.getGuides();
    if (mounted) {
      setState(() {
        _guides = all.take(5).toList();
        _loading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _showReserveSheet(Guide guide) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Guide avatar and name
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary.withAlpha(30),
              backgroundImage: CachedNetworkImageProvider(guide.photoUrl),
            ),
            const SizedBox(height: 12),
            Text(guide.name, style: AppTheme.headline(size: 18)),
            Text(guide.specialty,
                style: AppTheme.body(
                    size: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            // Holding fee info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(15),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                    color: AppColors.accent.withAlpha(40)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.info_outline,
                        color: AppColors.accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Holding Fee',
                            style: AppTheme.label(
                                size: 13, color: AppColors.accent)),
                        const SizedBox(height: 2),
                        Text(
                          'A refundable P500 holding fee will be deducted from the final guide fee.',
                          style: AppTheme.body(
                              size: 12,
                              color: AppColors.textSecondary,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Trip details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _detailChip(
                      Icons.location_on,
                      widget.location,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _detailChip(
                      Icons.calendar_today,
                      '${_formatDate(widget.startDate)} - ${_formatDate(widget.endDate)}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Reserve button
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${guide.name} reserved! They\'ll confirm within 5 hours.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Text(
                    'Reserve This Guide - P500',
                    style:
                        AppTheme.label(size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTheme.label(size: 11, color: AppColors.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primary))
          : SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
                    child: Row(
                      children: [
                        const KuyogBackButton(),
                        const SizedBox(width: 8),
                        Text('Your Guides',
                            style: AppTheme.headline(size: 22)),
                      ],
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.person_search,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'We found ${_guides.length} guides for you!',
                                  style: AppTheme.label(
                                      size: 15, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 12,
                                        color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.location} · ${_formatDate(widget.startDate)} - ${_formatDate(widget.endDate)}',
                                      style: AppTheme.body(
                                          size: 11,
                                          color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Guide List
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _guides.length,
                      itemBuilder: (context, index) =>
                          _buildGuideCard(_guides[index]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGuideCard(Guide guide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withAlpha(30),
                  backgroundImage:
                      CachedNetworkImageProvider(guide.photoUrl),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(guide.name,
                                style: AppTheme.headline(size: 16)),
                          ),
                          if (guide.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified,
                                      size: 12,
                                      color: Color(0xFF16A34A)),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Verified',
                                    style: AppTheme.label(
                                        size: 10,
                                        color:
                                            const Color(0xFF16A34A)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        guide.specialty,
                        style: AppTheme.body(
                            size: 12,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text('${guide.rating}',
                              style: AppTheme.label(size: 12)),
                          Text(
                              ' · ${guide.tripCount} trips · ${guide.languages.join(", ")}',
                              style: AppTheme.body(
                                  size: 11,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bio excerpt
            Text(
              guide.bio,
              style: AppTheme.body(
                  size: 13,
                  color: AppColors.textSecondary,
                  height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Specialties chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: guide.specialties.take(3).map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s,
                    style: AppTheme.label(
                        size: 10, color: AppColors.primary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            // Bottom row: price + reserve button
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Rate',
                        style: AppTheme.body(
                            size: 10,
                            color: AppColors.textSecondary)),
                    Text(guide.priceRange,
                        style: AppTheme.headline(
                            size: 16, color: AppColors.primary)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => _showReserveSheet(guide),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text('Reserve This Guide',
                        style: AppTheme.label(
                            size: 13, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/guide.dart';
import '../../../models/destination.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'destination_detail_screen.dart';
import 'guide_confirmed_screen.dart';
import 'guide_voice_call_screen.dart';
import 'guide_video_call_screen.dart';

class GuidePlanningScreen extends StatefulWidget {
  final Guide guide;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> interests;

  const GuidePlanningScreen({
    super.key,
    required this.guide,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.interests,
  });

  @override
  State<GuidePlanningScreen> createState() => _GuidePlanningScreenState();
}

class _GuidePlanningScreenState extends State<GuidePlanningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Itinerary state
  Map<int, List<Destination>> _dayItineraries = {};
  List<Destination> _suggestions = [];
  int _selectedDay = 1;
  bool _loading = true;

  // Approval state: destination id -> {tourist: bool, guide: bool}
  final Map<String, Map<String, bool>> _approvals = {};

  static const double _maxDistanceKm = 30.0;

  int get _totalDays => widget.endDate.difference(widget.startDate).inDays + 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDestinations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDestinations() async {
    final all = await MockData.getDestinations();
    if (!mounted) return;

    final days = _totalDays;
    final perDay = (all.length * 0.5 ~/ days).clamp(2, 4);
    final totalForItinerary = perDay * days;
    final itineraryDests = all.take(totalForItinerary).toList();
    final suggestionDests = all.skip(totalForItinerary).toList();

    final dayMap = <int, List<Destination>>{};
    for (int d = 1; d <= days; d++) {
      final start = (d - 1) * perDay;
      final end = (start + perDay).clamp(0, itineraryDests.length);
      dayMap[d] = itineraryDests.sublist(start, end);
    }

    // Pre-fill guide approvals for ~70% of destinations
    final rng = Random(42);
    for (final list in dayMap.values) {
      for (final dest in list) {
        _approvals[dest.id] = {
          'tourist': false,
          'guide': rng.nextDouble() < 0.7,
        };
      }
    }

    setState(() {
      _dayItineraries = dayMap;
      _suggestions = suggestionDests;
      _loading = false;
    });
  }

  static String _weekdayShort(int weekday) {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return days[weekday - 1];
  }

  static double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  int _estimatedTravelMinutes(double distKm) => (distKm / 30 * 60).round().clamp(5, 999);

  Set<int> _conflictsForDay(int day) {
    final list = _dayItineraries[day] ?? [];
    final conflicts = <int>{};
    for (int i = 0; i < list.length - 1; i++) {
      final a = list[i], b = list[i + 1];
      if (_distanceKm(a.latitude, a.longitude, b.latitude, b.longitude) > _maxDistanceKm) {
        conflicts.addAll([i, i + 1]);
      }
    }
    return conflicts;
  }

  bool get _hasAnyConflicts {
    for (int d = 1; d <= _totalDays; d++) {
      if (_conflictsForDay(d).isNotEmpty) return true;
    }
    return false;
  }

  bool get _allApproved {
    for (final list in _dayItineraries.values) {
      for (final dest in list) {
        final a = _approvals[dest.id];
        if (a == null || a['tourist'] != true || a['guide'] != true) return false;
      }
    }
    return true;
  }

  int get _totalStops => _dayItineraries.values.fold(0, (s, l) => s + l.length);

  bool get _canConfirm => _totalStops > 0 && !_hasAnyConflicts && _allApproved;

  void _toggleTouristApproval(String destId) {
    setState(() {
      _approvals.putIfAbsent(destId, () => {'tourist': false, 'guide': false});
      _approvals[destId]!['tourist'] = !(_approvals[destId]!['tourist'] ?? false);
    });
  }

  void _removeFromDay(int day, int index) {
    setState(() {
      final removed = _dayItineraries[day]!.removeAt(index);
      _approvals.remove(removed.id);
      if (!_suggestions.any((s) => s.id == removed.id)) _suggestions.insert(0, removed);
    });
  }

  void _addToCurrentDay(Destination d) {
    setState(() {
      _dayItineraries[_selectedDay]!.add(d);
      _suggestions.removeWhere((s) => s.id == d.id);
      _approvals[d.id] = {'tourist': false, 'guide': true};
    });
  }

  // ── Chat Tab ──

  Widget _buildChatTab() {
    final messages = [
      _ChatMsg(isGuide: true, text: 'Hi! I\'m ${widget.guide.name}. I\'m excited to explore ${widget.location} with you! I saw your interests — great picks!'),
      _ChatMsg(isGuide: false, text: 'Thanks! I really want to see the Eagle Center and try durian.'),
      _ChatMsg(isGuide: true, text: 'Perfect choices. I\'ll add those plus some hidden gems I know. Let me draft the itinerary — check the Itinerary tab!'),
      _ChatMsg(isGuide: true, text: 'I\'ve added destinations for each day. Please review and approve the ones you like. We can swap anything out.'),
      _ChatMsg(isGuide: false, text: 'Looks great! Let me go through them.'),
    ];

    return Column(children: [
      Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) => _buildChatBubble(messages[index]),
        ),
      ),
      // Input bar
      Container(
        padding: EdgeInsets.fromLTRB(12, 8, 8, MediaQuery.of(context).padding.bottom + 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text('Type a message...', style: AppTheme.body(size: 14, color: AppColors.textLight)),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _appBarCallButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }



  Widget _buildChatBubble(_ChatMsg msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: msg.isGuide ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (msg.isGuide) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(widget.guide.photoUrl),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isGuide ? Colors.white : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(msg.isGuide ? 4 : 16),
                  bottomRight: Radius.circular(msg.isGuide ? 16 : 4),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4, offset: const Offset(0, 1))],
              ),
              child: Text(
                msg.text,
                style: AppTheme.body(
                  size: 13,
                  color: msg.isGuide ? AppColors.textPrimary : Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (!msg.isGuide) const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ── Itinerary Tab ──

  Widget _buildItineraryTab() {
    final currentList = _dayItineraries[_selectedDay] ?? [];
    final currentConflicts = _conflictsForDay(_selectedDay);

    return Column(children: [
      // Day circles
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_totalDays, (index) {
            final day = index + 1;
            final isSelected = _selectedDay == day;
            final dayConflicts = _conflictsForDay(day).isNotEmpty;
            final date = widget.startDate.add(Duration(days: index));
            return GestureDetector(
              onTap: () => setState(() => _selectedDay = day),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dayConflicts ? AppColors.error : (isSelected ? AppColors.primary : AppColors.divider),
                      width: dayConflicts ? 2 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: dayConflicts && !isSelected
                        ? const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error)
                        : Text('${date.day}', style: AppTheme.label(size: 12,
                            color: isSelected ? Colors.white : (dayConflicts ? AppColors.error : AppColors.textPrimary))),
                  ),
                ),
                const SizedBox(height: 2),
                Text(_weekdayShort(date.weekday), style: AppTheme.body(size: 8, color: isSelected ? AppColors.primary : AppColors.textLight)),
              ]),
            );
          }),
        ),
      ),

      // Approval legend
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
        child: Row(children: [
          _approvalLegendDot(AppColors.primary, 'You approved'),
          const SizedBox(width: 12),
          _approvalLegendDot(AppColors.accent, 'Guide approved'),
          const Spacer(),
          Icon(Icons.drag_indicator, size: 12, color: AppColors.textLight),
          const SizedBox(width: 3),
          Text('Hold to reorder', style: AppTheme.body(size: 9, color: AppColors.textLight)),
        ]),
      ),

      // Scrollable list
      Expanded(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverReorderableList(
                itemCount: currentList.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = currentList.removeAt(oldIndex);
                    currentList.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) =>
                    _buildItineraryItem(_selectedDay, index, currentList, currentConflicts),
              ),
            ),

            if (currentList.isEmpty)
              SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.all(40),
                  child: Center(child: Text('No destinations for this day.\nAdd from suggestions below.',
                      style: AppTheme.body(size: 14, color: AppColors.textLight), textAlign: TextAlign.center))),
              ),

            if (_suggestions.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text('Suggested Destinations', style: AppTheme.headline(size: 16))),
              ),

            if (_suggestions.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildSuggestionCard(_suggestions[index]),
                  childCount: _suggestions.length,
                )),
              ),

            if (_suggestions.isEmpty) const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      // Bottom: Confirm button
      Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton.icon(
            onPressed: _canConfirm ? _onConfirmItinerary : null,
            icon: const Icon(Icons.lock_outline, size: 18),
            label: Text(
              _canConfirm ? 'Confirm Itinerary' : (_hasAnyConflicts ? 'Fix conflicts first' : 'Approve all to confirm'),
              style: AppTheme.label(size: 14, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.divider, disabledForegroundColor: AppColors.textLight,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _approvalLegendDot(Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: AppTheme.body(size: 9, color: AppColors.textSecondary)),
    ]);
  }

  Widget _buildItineraryItem(int day, int index, List<Destination> list, Set<int> conflicts) {
    final d = list[index];
    final isConflict = conflicts.contains(index);
    final approval = _approvals[d.id] ?? {'tourist': false, 'guide': false};
    final touristOk = approval['tourist'] ?? false;
    final guideOk = approval['guide'] ?? false;

    double? distToNext;
    int? travelMins;
    bool isTooFar = false;
    if (index < list.length - 1) {
      final next = list[index + 1];
      distToNext = _distanceKm(d.latitude, d.longitude, next.latitude, next.longitude);
      travelMins = _estimatedTravelMinutes(distToNext);
      isTooFar = distToNext > _maxDistanceKm;
    }

    return Column(
      key: ValueKey('${d.id}_plan_day$day'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => DestinationDetailScreen(destination: d))),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: isConflict ? AppColors.error.withAlpha(12) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isConflict ? Border.all(color: AppColors.error.withAlpha(80), width: 1.5) : null,
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Row(children: [
                const SizedBox(width: 8),
                // Approval indicators
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () => _toggleTouristApproval(d.id),
                    child: Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: touristOk ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: touristOk ? AppColors.primary : AppColors.divider, width: 1.5),
                      ),
                      child: touristOk ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: guideOk ? AppColors.accent : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: guideOk ? AppColors.accent : AppColors.divider, width: 1.5),
                    ),
                    child: guideOk ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                  ),
                ]),
                const SizedBox(width: 8),
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(imageUrl: d.imageUrl, width: 40, height: 40, fit: BoxFit.cover,
                    placeholder: (c, u) => Container(width: 40, height: 40, color: AppColors.divider),
                    errorWidget: (c, u, e) => Container(width: 40, height: 40, color: AppColors.primary.withAlpha(25))),
                ),
                const SizedBox(width: 8),
                // Name
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.name, style: AppTheme.label(size: 12, color: isConflict ? AppColors.error : AppColors.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(d.province, style: AppTheme.body(size: 10, color: AppColors.textLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ]),
                ),
                const Icon(Icons.drag_indicator, size: 14, color: AppColors.textLight),
                GestureDetector(
                  onTap: () => _removeFromDay(day, index),
                  child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.close, size: 14, color: AppColors.error)),
                ),
              ]),
            ),
          ),
        ),
        if (index < list.length - 1)
          _buildConnector(travelMins!, isTooFar, distToNext!),
      ],
    );
  }

  Widget _buildSuggestionCard(Destination d) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => DestinationDetailScreen(destination: d))),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 4, offset: const Offset(0, 1))],
          ),
          child: Row(children: [
            const SizedBox(width: 12),
            ClipRRect(borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl: d.imageUrl, width: 36, height: 36, fit: BoxFit.cover,
                placeholder: (c, u) => Container(width: 36, height: 36, color: AppColors.divider),
                errorWidget: (c, u, e) => Container(width: 36, height: 36, color: AppColors.primary.withAlpha(25)))),
            const SizedBox(width: 10),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.name, style: AppTheme.label(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(children: [
                  const Icon(Icons.location_on, size: 10, color: AppColors.textLight),
                  const SizedBox(width: 2),
                  Expanded(child: Text('${d.province} · ${d.category}', style: AppTheme.body(size: 10, color: AppColors.textLight),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
              ]),
            ),
            GestureDetector(
              onTap: () => _addToCurrentDay(d),
              child: Container(
                width: 36, height: 36, margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.add, size: 18, color: AppColors.primary),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildConnector(int minutes, bool isTooFar, double distKm) {
    final color = isTooFar ? AppColors.error : AppColors.primary;
    return SizedBox(
      height: 28,
      child: Row(children: [
        const SizedBox(width: 18),
        Container(width: 2, height: 28, color: color.withAlpha(40)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.pill)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(isTooFar ? Icons.warning_amber_rounded : Icons.directions_car, size: 10, color: color),
            const SizedBox(width: 3),
            Text('~$minutes mins', style: AppTheme.label(size: 8, color: color)),
          ]),
        ),
      ]),
    );
  }

  void _onConfirmItinerary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GuideConfirmedScreen(
          guide: widget.guide,
          location: widget.location,
          startDate: widget.startDate,
          endDate: widget.endDate,
          totalStops: _totalStops,
        ),
      ),
    );
  }

  // ── Main Build ──

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // App bar with guide info
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
            child: Row(children: [
              const KuyogBackButton(),
              const SizedBox(width: 8),
              CircleAvatar(radius: 16, backgroundImage: CachedNetworkImageProvider(widget.guide.photoUrl)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Plan with ${widget.guide.name}', style: AppTheme.label(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(widget.location, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                ]),
              ),
              const SizedBox(width: 8),
              _appBarCallButton(Icons.mic, () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => GuideVoiceCallScreen(guide: widget.guide),
                ));
              }),
              const SizedBox(width: 6),
              _appBarCallButton(Icons.videocam, () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => GuideVideoCallScreen(guide: widget.guide),
                ));
              }),
            ]),
          ),

          // Tab bar
          Container(
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            decoration: BoxDecoration(
              color: AppColors.divider.withAlpha(80),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTheme.label(size: 13),
              unselectedLabelStyle: AppTheme.body(size: 13),
              dividerHeight: 0,
              tabs: const [
                Tab(text: 'Chat', height: 40),
                Tab(text: 'Itinerary', height: 40),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatTab(),
                _buildItineraryTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _ChatMsg {
  final bool isGuide;
  final String text;
  const _ChatMsg({required this.isGuide, required this.text});
}

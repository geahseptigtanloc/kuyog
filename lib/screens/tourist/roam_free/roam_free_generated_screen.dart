import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app_theme.dart';
import '../../../data/mock_data.dart';
import '../../../models/destination.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'destination_detail_screen.dart';

class RoamFreeGeneratedScreen extends StatefulWidget {
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> interests;

  const RoamFreeGeneratedScreen({
    super.key,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.interests,
  });

  @override
  State<RoamFreeGeneratedScreen> createState() =>
      _RoamFreeGeneratedScreenState();
}

class _RoamFreeGeneratedScreenState extends State<RoamFreeGeneratedScreen> {
  Map<int, List<Destination>> _dayItineraries = {};
  List<Destination> _suggestions = [];
  bool _loading = true;
  int _selectedDay = 1;

  static const double _maxDistanceKm = 30.0;

  int get _totalDays => widget.endDate.difference(widget.startDate).inDays + 1;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    final all = await MockData.getDestinations();
    if (!mounted) return;

    final days = _totalDays;
    final perDay = (all.length * 0.6 ~/ days).clamp(2, 5);
    final totalForItinerary = perDay * days;
    final itineraryDests = all.take(totalForItinerary).toList();
    final suggestionDests = all.skip(totalForItinerary).toList();

    final dayMap = <int, List<Destination>>{};
    for (int d = 1; d <= days; d++) {
      final start = (d - 1) * perDay;
      final end = (start + perDay).clamp(0, itineraryDests.length);
      dayMap[d] = itineraryDests.sublist(start, end);
    }

    setState(() {
      _dayItineraries = dayMap;
      _suggestions = suggestionDests;
      _loading = false;
    });
  }

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _dayLabel(int day) {
    final date = widget.startDate.add(Duration(days: day - 1));
    return _formatDate(date);
  }

  static String _weekdayShort(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  static double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _toRad(double deg) => deg * pi / 180;

  int _estimatedTravelMinutes(double distKm) =>
      (distKm / 30 * 60).round().clamp(5, 999);

  Set<int> _conflictsForDay(int day) {
    final list = _dayItineraries[day] ?? [];
    final conflicts = <int>{};
    for (int i = 0; i < list.length - 1; i++) {
      final a = list[i];
      final b = list[i + 1];
      if (_distanceKm(a.latitude, a.longitude, b.latitude, b.longitude) > _maxDistanceKm) {
        conflicts.add(i);
        conflicts.add(i + 1);
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

  int get _totalStops =>
      _dayItineraries.values.fold(0, (sum, list) => sum + list.length);

  void _removeFromDay(int day, int index) {
    setState(() {
      final removed = _dayItineraries[day]!.removeAt(index);
      if (!_suggestions.any((s) => s.id == removed.id)) {
        _suggestions.insert(0, removed);
      }
    });
  }

  void _addToCurrentDay(Destination d) {
    setState(() {
      _dayItineraries[_selectedDay]!.add(d);
      _suggestions.removeWhere((s) => s.id == d.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final currentList = _dayItineraries[_selectedDay] ?? [];
    final currentConflicts = _conflictsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Sticky: App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
                  child: Row(children: [
                    const KuyogBackButton(),
                    const SizedBox(width: 8),
                    Text('Your Trip', style: AppTheme.headline(size: 22)),
                  ]),
                ),

                // Sticky: Summary Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.location, style: AppTheme.label(size: 15, color: Colors.white)),
                          const SizedBox(height: 2),
                          Row(children: [
                            const Icon(Icons.calendar_today, size: 11, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text('${_formatDate(widget.startDate)} - ${_formatDate(widget.endDate)}',
                                style: AppTheme.body(size: 11, color: Colors.white70)),
                          ]),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text('$_totalStops stops · $_totalDays days',
                            style: AppTheme.label(size: 10, color: Colors.white)),
                      ),
                    ]),
                  ),
                ),

                // Sticky: Day Circles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dayConflicts
                                    ? AppColors.error
                                    : (isSelected ? AppColors.primary : AppColors.divider),
                                width: dayConflicts ? 2 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: AppColors.primary.withAlpha(40), blurRadius: 8, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: Center(
                              child: dayConflicts && !isSelected
                                  ? Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error)
                                  : Text(
                                      '${date.day}',
                                      style: AppTheme.label(
                                        size: 14,
                                        color: isSelected
                                            ? Colors.white
                                            : (dayConflicts ? AppColors.error : AppColors.textPrimary),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _weekdayShort(date.weekday),
                            style: AppTheme.body(
                              size: 9,
                              color: isSelected ? AppColors.primary : AppColors.textLight,
                            ),
                          ),
                        ]),
                      );
                    }),
                  ),
                ),

                // Day date label + conflict warning
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(_dayLabel(_selectedDay), style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                      const Spacer(),
                      Icon(Icons.drag_indicator, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text('Hold to reorder', style: AppTheme.body(size: 10, color: AppColors.textLight)),
                    ]),
                    if (currentConflicts.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withAlpha(15),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: AppColors.error.withAlpha(60)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error),
                          const SizedBox(width: 6),
                          Expanded(child: Text('Some destinations are too far apart.',
                              style: AppTheme.body(size: 11, color: AppColors.error))),
                        ]),
                      ),
                    ],
                  ]),
                ),

                // Scrollable: Day itinerary + Suggestions
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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
                              _buildReorderableItem(_selectedDay, index, currentList, currentConflicts),
                        ),
                      ),

                      if (currentList.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: Text('No destinations for this day.\nAdd from suggestions below.',
                                  style: AppTheme.body(size: 14, color: AppColors.textLight),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),

                      if (_suggestions.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Suggested Destinations', style: AppTheme.headline(size: 18)),
                              const SizedBox(height: 2),
                              Text('Add to Day $_selectedDay', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                            ]),
                          ),
                        ),

                      if (_suggestions.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildSuggestionCard(_suggestions[index]),
                              childCount: _suggestions.length,
                            ),
                          ),
                        ),

                      if (_suggestions.isEmpty)
                        const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderableItem(int day, int index, List<Destination> list, Set<int> conflicts) {
    final d = list[index];
    final isConflict = conflicts.contains(index);

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
      key: ValueKey('${d.id}_day$day'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => DestinationDetailScreen(destination: d),
            )),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: isConflict ? AppColors.error.withAlpha(12) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isConflict ? Border.all(color: AppColors.error.withAlpha(80), width: 1.5) : null,
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Row(children: [
                const SizedBox(width: 12),
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: isConflict ? AppColors.error : AppColors.primary, shape: BoxShape.circle),
                  child: Center(child: Text('${index + 1}', style: AppTheme.label(size: 11, color: Colors.white))),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(imageUrl: d.imageUrl, width: 40, height: 40, fit: BoxFit.cover,
                    placeholder: (c, u) => Container(width: 40, height: 40, color: AppColors.divider),
                    errorWidget: (c, u, e) => Container(width: 40, height: 40, color: AppColors.primary.withAlpha(25))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.name, style: AppTheme.label(size: 13, color: isConflict ? AppColors.error : AppColors.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Row(children: [
                      Icon(Icons.location_on, size: 10, color: isConflict ? AppColors.error.withAlpha(150) : AppColors.textLight),
                      const SizedBox(width: 2),
                      Expanded(child: Text(d.province, style: AppTheme.body(size: 10, color: isConflict ? AppColors.error.withAlpha(150) : AppColors.textLight),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  ]),
                ),
                const Icon(Icons.drag_indicator, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _removeFromDay(day, index),
                  child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.close, size: 16, color: AppColors.error)),
                ),
                const SizedBox(width: 4),
              ]),
            ),
          ),
        ),
        if (index < list.length - 1)
          _buildTravelTimeConnector(travelMins!, isTooFar, distToNext!),
      ],
    );
  }

  Widget _buildSuggestionCard(Destination d) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => DestinationDetailScreen(destination: d),
        )),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(imageUrl: d.imageUrl, width: 40, height: 40, fit: BoxFit.cover,
                placeholder: (c, u) => Container(width: 40, height: 40, color: AppColors.divider),
                errorWidget: (c, u, e) => Container(width: 40, height: 40, color: AppColors.primary.withAlpha(25))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.name, style: AppTheme.label(size: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(children: [
                  Icon(Icons.location_on, size: 10, color: AppColors.textLight),
                  const SizedBox(width: 2),
                  Expanded(child: Text('${d.province} · ${d.category}', style: AppTheme.body(size: 10, color: AppColors.textLight),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
              ]),
            ),
            GestureDetector(
              onTap: () => _addToCurrentDay(d),
              child: Container(
                width: 40, height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.add, size: 20, color: AppColors.primary),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildTravelTimeConnector(int minutes, bool isTooFar, double distKm) {
    final color = isTooFar ? AppColors.error : AppColors.primary;
    return SizedBox(
      height: isTooFar ? 46 : 32,
      child: Row(children: [
        const SizedBox(width: 23),
        Container(width: 2, height: isTooFar ? 46 : 32, color: color.withAlpha(40)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: color.withAlpha(15), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(isTooFar ? Icons.warning_amber_rounded : Icons.directions_car, size: 11, color: color),
                const SizedBox(width: 4),
                Text('~$minutes mins · ${distKm.toStringAsFixed(1)} km', style: AppTheme.label(size: 9, color: color)),
              ]),
            ),
            if (isTooFar)
              Padding(padding: const EdgeInsets.only(left: 4, top: 1),
                child: Text('Too far — consider reordering', style: AppTheme.body(size: 8, color: AppColors.error))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildBottomBar() {
    final canConfirm = _totalStops > 0 && !_hasAnyConflicts;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(children: [
            Expanded(
              child: SizedBox(height: 50, child: OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trip saved to your account!'), behavior: SnackBarBehavior.floating)),
                icon: const Icon(Icons.bookmark_border, size: 18),
                label: Text('Save Trip', style: AppTheme.label(size: 14, color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(height: 50, child: ElevatedButton.icon(
                onPressed: canConfirm
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trip confirmed! Check My Trips.'), behavior: SnackBarBehavior.floating))
                    : null,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text('Confirm Trip', style: AppTheme.label(size: 14, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.divider, disabledForegroundColor: AppColors.textLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              )),
            ),
          ]),
        ),
      ),
    );
  }
}

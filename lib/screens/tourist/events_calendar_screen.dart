import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class EventsCalendarScreen extends StatefulWidget {
  const EventsCalendarScreen({super.key});
  @override
  State<EventsCalendarScreen> createState() => _EventsCalendarScreenState();
}

class _EventsCalendarScreenState extends State<EventsCalendarScreen> {
  int _selectedMonth = DateTime.now().month;
  final _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static final _events = <int, List<Map<String, String>>>{
    1: [{'name': 'Sinulog sa Davao', 'dates': 'Jan 15-19', 'location': 'Davao City', 'type': 'Festival'}, {'name': 'Feast of Sto. Nino', 'dates': 'Jan 18-19', 'location': 'Various Churches', 'type': 'Religious'}],
    2: [{'name': 'Davao Food Festival', 'dates': 'Feb 14-16', 'location': 'SMX Convention Center', 'type': 'Food'}, {'name': 'Heart of Davao Fair', 'dates': 'Feb 14', 'location': 'People\'s Park', 'type': 'Community'}],
    3: [{'name': 'Araw ng Davao', 'dates': 'Mar 16', 'location': 'Davao City-wide', 'type': 'Festival'}, {'name': 'Madayaw Lungsod Crawl', 'dates': 'Mar 1-14', 'location': 'City Landmarks', 'type': 'Madayaw Crawl'}],
    4: [{'name': 'Semana Santa', 'dates': 'Apr 14-20', 'location': 'Various Churches', 'type': 'Religious'}, {'name': 'Earth Month Activities', 'dates': 'Apr 22', 'location': 'Eden Nature Park', 'type': 'Nature'}],
    5: [{'name': 'Madayaw Lasang Crawl', 'dates': 'May 1-28', 'location': 'Nature Sites', 'type': 'Madayaw Crawl'}, {'name': 'Flores de Mayo', 'dates': 'May 1-31', 'location': 'Various', 'type': 'Religious'}],
    6: [{'name': 'Durian Festival', 'dates': 'Jun 20-22', 'location': 'Magsaysay Park', 'type': 'Food'}, {'name': 'Philippine Independence Day', 'dates': 'Jun 12', 'location': 'City Hall', 'type': 'National'}],
    7: [{'name': 'Kadayawan Pre-Events', 'dates': 'Jul 15-31', 'location': 'Various', 'type': 'Festival'}],
    8: [{'name': 'Kadayawan sa Dabaw', 'dates': 'Aug 16-22', 'location': 'Davao City-wide', 'type': 'Festival'}, {'name': 'Madayaw Ani Crawl', 'dates': 'Aug 1-21', 'location': 'Cultural Sites', 'type': 'Madayaw Crawl'}, {'name': 'Indak-Indak sa Kadalanan', 'dates': 'Aug 20', 'location': 'City Streets', 'type': 'Festival'}],
    9: [{'name': 'Philippine Eagle Week', 'dates': 'Sep 8-14', 'location': 'Eagle Center', 'type': 'Nature'}],
    10: [{'name': 'Davao Chocolate Fair', 'dates': 'Oct 10-12', 'location': 'Malagos', 'type': 'Food'}, {'name': 'Undas Preparations', 'dates': 'Oct 31', 'location': 'Various', 'type': 'National'}],
    11: [{'name': 'Davao Coffee Festival', 'dates': 'Nov 14-16', 'location': 'Toril', 'type': 'Food'}, {'name': 'Pasko sa Davao Opening', 'dates': 'Nov 28', 'location': 'City Hall', 'type': 'Festival'}],
    12: [{'name': 'Pasko Fiesta sa Dabaw', 'dates': 'Dec 1-31', 'location': 'Davao City-wide', 'type': 'Festival'}, {'name': 'Madayaw Pasko Crawl', 'dates': 'Dec 5-25', 'location': 'Markets & Parks', 'type': 'Madayaw Crawl'}],
  };

  final _typeIcons = {'Festival': Icons.celebration, 'Food': Icons.restaurant, 'Religious': Icons.church, 'Nature': Icons.eco, 'National': Icons.flag, 'Community': Icons.people, 'Madayaw Crawl': Icons.explore};
  final _typeColors = {'Festival': AppColors.accent, 'Food': AppColors.merchantAmber, 'Religious': Colors.purple, 'Nature': AppColors.primary, 'National': AppColors.touristBlue, 'Community': AppColors.primaryLight, 'Madayaw Crawl': AppColors.primary};

  @override
  Widget build(BuildContext context) {
    final events = _events[_selectedMonth] ?? [];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: KuyogBackButton(onTap: () => Navigator.pop(context)),
        title: Text('Events Calendar 2027', style: AppTheme.headline(size: 20)),
      ),
      body: Column(children: [
        // Month selector
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(height: 42, child: ListView.builder(
            scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: 12,
            itemBuilder: (c, i) {
              final sel = _selectedMonth == i + 1;
              return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
                onTap: () => setState(() => _selectedMonth = i + 1),
                child: Container(width: 48, decoration: BoxDecoration(color: sel ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(AppRadius.md), border: sel ? null : Border.all(color: AppColors.divider)),
                  child: Center(child: Text(_months[i], style: AppTheme.label(size: 12, color: sel ? Colors.white : AppColors.textSecondary)))),
              ));
            },
          )),
        ),
        const SizedBox(height: 8),
        Expanded(child: events.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.event_busy, size: 64, color: AppColors.textLight),
              const SizedBox(height: 12),
              Text('No events listed for ${_months[_selectedMonth - 1]}', style: AppTheme.body(size: 14, color: AppColors.textLight)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: events.length,
              itemBuilder: (c, i) {
                final e = events[i];
                final type = e['type'] ?? 'Festival';
                final color = _typeColors[type] ?? AppColors.primary;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card, border: Border(left: BorderSide(color: color, width: 4))),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(12)),
                      child: Icon(_typeIcons[type] ?? Icons.event, color: color, size: 24)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e['name'] ?? '', style: AppTheme.label(size: 15)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.calendar_today, size: 12, color: AppColors.textLight), const SizedBox(width: 4),
                        Text(e['dates'] ?? '', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                      ]),
                      Row(children: [
                        const Icon(Icons.location_on, size: 12, color: AppColors.textLight), const SizedBox(width: 4),
                        Expanded(child: Text(e['location'] ?? '', style: AppTheme.body(size: 12, color: AppColors.textSecondary))),
                      ]),
                    ])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text(type, style: AppTheme.label(size: 9, color: color))),
                  ]),
                );
              },
            ),
        ),
      ]),
    );
  }
}


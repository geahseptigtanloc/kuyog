import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../models/destination.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/kuyog_card.dart';

class ItineraryBuilderScreen extends StatefulWidget {
  final List<Destination> initialItinerary;
  const ItineraryBuilderScreen({super.key, required this.initialItinerary});

  @override
  State<ItineraryBuilderScreen> createState() => _ItineraryBuilderScreenState();
}

class _ItineraryBuilderScreenState extends State<ItineraryBuilderScreen> {
  late List<Destination> _itinerary;
  final TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _itinerary = List.from(widget.initialItinerary);
  }

  double get _totalEntranceFees => _itinerary.fold(0, (sum, d) => sum + d.pricePerDay);
  
  // Mock transport cost: 500 base + 150 per stop
  double get _estTransportCost => _itinerary.isEmpty ? 0 : 500 + (_itinerary.length * 150.0);

  String _formatTime(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    int totalMinutes = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(hour: (totalMinutes ~/ 60) % 24, minute: totalMinutes % 60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const KuyogBackButton(),
        title: Text(
          'Itinerary Builder',
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _itinerary),
            child: Text('SAVE', style: AppTheme.label(size: 14, color: AppColors.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Time Slot Legend
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withAlpha(10),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Drag items to reorder your day. AI will optimize travel times.',
                    style: AppTheme.body(size: 12, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _itinerary.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _itinerary.removeAt(oldIndex);
                  _itinerary.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final destination = _itinerary[index];
                
                // Calculate time slot
                int prevMinutes = 0;
                for (int i = 0; i < index; i++) {
                  prevMinutes += _itinerary[i].estimatedVisitMinutes + 45; // 45 min travel time avg
                }
                final startTime = _addMinutes(_startTime, prevMinutes);
                final endTime = _addMinutes(startTime, destination.estimatedVisitMinutes);

                return Container(
                  key: ValueKey(destination.id + index.toString()),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: KuyogCard(
                    backgroundColor: Colors.white,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // Time Column
                          Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(15),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppRadius.md),
                                bottomLeft: Radius.circular(AppRadius.md),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_formatTime(startTime), style: AppTheme.label(size: 10)),
                                const Icon(Icons.arrow_downward, size: 10, color: AppColors.textLight),
                                Text(_formatTime(endTime), style: AppTheme.label(size: 10)),
                              ],
                            ),
                          ),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          destination.name,
                                          style: AppTheme.headline(size: 14),
                                        ),
                                      ),
                                      const Icon(Icons.drag_indicator, color: AppColors.textLight),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_outlined, size: 12, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text('${destination.estimatedVisitMinutes} min visit', 
                                        style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.payments_outlined, size: 12, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text('₱${destination.pricePerDay.toInt()}', 
                                        style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Remove/Swap
                          Container(
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border(left: BorderSide(color: AppColors.divider)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.refresh, size: 18, color: AppColors.primary),
                                  onPressed: () {
                                    // AI Suggest alternative logic
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('AI is suggesting an alternative...'))
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  onPressed: () {
                                    setState(() => _itinerary.removeAt(index));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Budget Tracker Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Est. Total Budget', style: AppTheme.headline(size: 16)),
                      Text('₱${(_totalEntranceFees + _estTransportCost).toInt()}', 
                        style: AppTheme.headline(size: 18, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _budgetDetail('Entrance Fees', '₱${_totalEntranceFees.toInt()}'),
                      const SizedBox(width: 16),
                      _budgetDetail('Est. Transport', '₱${_estTransportCost.toInt()}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _itinerary),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Confirm Itinerary', style: AppTheme.label(size: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _budgetDetail(String label, String amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.divider.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.body(size: 10, color: AppColors.textSecondary)),
            Text(amount, style: AppTheme.label(size: 12)),
          ],
        ),
      ),
    );
  }
}

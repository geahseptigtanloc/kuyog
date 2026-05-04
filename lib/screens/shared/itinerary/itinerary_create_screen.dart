import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_mascot.dart';

class _GuideOption {
  final String id;
  final String name;
  _GuideOption({required this.id, required this.name});
}

class ItineraryCreateScreen extends StatefulWidget {
  final dynamic preAssignedGuide;
  const ItineraryCreateScreen({super.key, this.preAssignedGuide});
  @override
  State<ItineraryCreateScreen> createState() => _ItineraryCreateScreenState();
}

class _ItineraryCreateScreenState extends State<ItineraryCreateScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController(text: 'My Mindanao Adventure');
  List<_GuideOption> _guideOptions = [
    _GuideOption(id: 'mock_1', name: 'Rico Magbanua'),
    _GuideOption(id: 'mock_2', name: 'Amina Lidasan'),
    _GuideOption(id: 'mock_3', name: 'Ben Tiumalu'),
  ];
  _GuideOption? _selectedGuideOption;
  
  final List<String> _selectedDests = [];
  DateTimeRange? _dates;

  final _destOptions = ['Mt. Apo', 'Samal Island', 'Enchanted River', 'Lake Sebu', 'Tinuy-an Falls', 'Siargao'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.preAssignedGuide != null) {
      _selectedGuideOption = _GuideOption(
        id: widget.preAssignedGuide.id,
        name: widget.preAssignedGuide.name,
      );
    }
    _fetchGuides();
  }

  Future<void> _fetchGuides() async {
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('id, name')
          .eq('role', 'guide')
          .limit(10);
      
      if ((res as List).isNotEmpty) {
        if (mounted) {
          setState(() {
            _guideOptions = res.map((g) => _GuideOption(id: g['id'], name: g['name'])).toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching guides, using mock data: $e');
    }
  }

  Future<void> _submitItinerary() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      // Calculate duration
      int duration = 1;
      if (_dates != null) {
        duration = _dates!.end.difference(_dates!.start).inDays + 1;
      }

      String? guideId;
      if (widget.preAssignedGuide != null) {
        guideId = widget.preAssignedGuide.id;
      } else if (_selectedGuideOption != null) {
        guideId = _selectedGuideOption!.id;
      }

      // Validate if it's a real UUID. Mock IDs like 'g2' will crash Postgres.
      final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
      if (guideId != null && !uuidRegex.hasMatch(guideId)) {
        guideId = null;
      }

      await supabase.from('itineraries').insert({
        'touristId': userId,
        'guideId': guideId,
        'title': _nameCtrl.text,
        'status': 'Draft',
        'start_date': _dates?.start.toIso8601String(),
        'end_date': _dates?.end.toIso8601String(),
        'durationDays': duration,
        'creationMode': 'own',
        'destination': _selectedDests.isNotEmpty ? _selectedDests.first : 'Mindanao',
      });
      
      if (mounted) {
        context.read<ItineraryProvider>().refresh();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Itinerary created successfully!', style: AppTheme.body(size: 14, color: Colors.white)), backgroundColor: AppColors.primary)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating itinerary: $e'), backgroundColor: AppColors.warning)
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          _buildAppBar(),
          _buildStepIndicator(),
          Expanded(child: _buildStep()),
          _buildBottomButtons(),
        ]),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(children: [
        KuyogBackButton(onTap: () => _step > 0 ? setState(() => _step--) : Navigator.pop(context)),
        const SizedBox(width: 12),
        Text('Create Itinerary', style: AppTheme.headline(size: 20)),
        const Spacer(),
        Text('Step ${_step + 1}/4', style: AppTheme.label(size: 13, color: AppColors.primary)),
      ]),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(children: List.generate(4, (i) => Expanded(
        child: Container(
          height: 4, margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
          decoration: BoxDecoration(
            color: i <= _step ? AppColors.primary : AppColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ))),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _stepNameDates();
      case 1: 
        if (widget.preAssignedGuide != null) {
          return _stepPreAssignedGuide();
        }
        return _stepChooseGuide();
      case 2: return _stepAddDests();
      case 3: return _stepReview();
      default: return const SizedBox();
    }
  }

  Widget _stepNameDates() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Name your trip', style: AppTheme.headline(size: 18)),
        const SizedBox(height: 12),
        TextField(controller: _nameCtrl, style: AppTheme.body(size: 15),
          decoration: InputDecoration(hintText: 'e.g. Davao Weekend Getaway',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)))),
        const SizedBox(height: 24),
        Text('Select travel dates', style: AppTheme.headline(size: 18)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final range = await showDateRangePicker(context: context,
              firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (range != null) setState(() => _dates = range);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
            child: Row(children: [
              const Icon(Icons.calendar_today, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(_dates != null ? '${_fmt(_dates!.start)} - ${_fmt(_dates!.end)}' : 'Tap to select dates',
                style: AppTheme.body(size: 14, color: _dates != null ? AppColors.textPrimary : AppColors.textLight)),
            ]),
          ),
        ),
      ]),
    );
  }

  String _fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';

  Widget _stepPreAssignedGuide() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Guide Selected', style: AppTheme.headline(size: 18)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.preAssignedGuide.name, style: AppTheme.label(size: 16)),
                      Text('Assigned to your trip', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Click "Next" to continue adding destinations.', style: AppTheme.body(size: 14)),
        ],
      ),
    );
  }

  Widget _stepChooseGuide() {
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Choose a guide (optional)', style: AppTheme.headline(size: 18)),
      const SizedBox(height: 4),
      Text('A local guide can help customize your trip', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
      const SizedBox(height: 16),
      ..._guideOptions.map((g) => _selectableTile(
            g.name, 
            _selectedGuideOption?.id == g.id, 
            Icons.explore, 
            () => setState(() => _selectedGuideOption = g))),
      const SizedBox(height: 12),
      TextButton(onPressed: () => setState(() => _selectedGuideOption = null), child: const Text('Skip — I\'ll explore solo')),
    ]);
  }

  Widget _stepAddDests() {
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Add destinations', style: AppTheme.headline(size: 18)),
      const SizedBox(height: 4),
      Text('Select places you want to visit', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
      const SizedBox(height: 16),
      ..._destOptions.map((d) => _selectableTile(d, _selectedDests.contains(d), Icons.place, () {
        setState(() { _selectedDests.contains(d) ? _selectedDests.remove(d) : _selectedDests.add(d); });
      })),
    ]);
  }

  Widget _stepReview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const DurieMascot(size: 60),
        const SizedBox(height: 16),
        Text('Review your itinerary', style: AppTheme.headline(size: 20)),
        const SizedBox(height: 16),
        _reviewRow('Trip Name', _nameCtrl.text),
        _reviewRow('Dates', _dates != null ? '${_fmt(_dates!.start)} - ${_fmt(_dates!.end)}' : 'Not set'),
        _reviewRow('Guide', _selectedGuideOption == null ? 'Solo trip' : _selectedGuideOption!.name),
        _reviewRow('Destinations', _selectedDests.isEmpty ? 'None selected' : _selectedDests.join(', ')),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('Your guide can suggest changes after creation.', style: AppTheme.body(size: 13, color: AppColors.primary))),
          ]),
        ),
      ]),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(children: [
          Text(label, style: AppTheme.label(size: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Flexible(child: Text(value, style: AppTheme.label(size: 14), textAlign: TextAlign.end, maxLines: 2)),
        ]),
      ),
    );
  }

  Widget _selectableTile(String title, bool selected, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: 1.5),
        ),
        child: Row(children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTheme.label(size: 14))),
          if (selected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
        ]),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, -2))]),
      child: Row(children: [
        if (_step > 0)
          Expanded(child: OutlinedButton(onPressed: () => setState(() => _step--), child: const Text('Back'))),
        if (_step > 0) const SizedBox(width: 12),
        Expanded(child: ElevatedButton(
          onPressed: _isLoading ? null : () {
            if (_step < 3) { setState(() => _step++); }
            else { _submitItinerary(); }
          },
          style: ElevatedButton.styleFrom(backgroundColor: _step == 3 ? AppColors.accent : AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(_step == 3 ? 'Create Itinerary' : 'Next', style: const TextStyle(fontSize: 15)),
        )),
      ]),
    );
  }
}

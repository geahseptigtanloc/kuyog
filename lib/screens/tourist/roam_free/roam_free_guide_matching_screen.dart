import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'roam_free_loading_screen.dart';

class RoamFreeGuideMatchingScreen extends StatefulWidget {
  const RoamFreeGuideMatchingScreen({super.key});

  @override
  State<RoamFreeGuideMatchingScreen> createState() =>
      _RoamFreeGuideMatchingScreenState();
}

class _RoamFreeGuideMatchingScreenState
    extends State<RoamFreeGuideMatchingScreen> {
  String? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;
  final Set<String> _selectedInterests = {};
  String? _travelStyle;
  String? _touristType;
  String? _budgetRange;
  int _groupSize = 1;

  static const List<String> _locations = [
    'Davao City',
    'Davao del Norte',
    'Davao del Sur',
    'Davao de Oro',
    'Davao Occidental',
  ];

  static const List<String> _travelStyles = [
    'Solo',
    'Couple',
    'Small Group (3-5)',
    'Large Group (6+)',
  ];

  static const List<String> _touristTypes = [
    'Local Tourist',
    'International Tourist',
  ];

  static const List<String> _budgetRanges = ['Economy', 'Standard', 'Premium'];
  static const Map<String, String> _budgetDescriptions = {
    'Economy': 'Under P2,000/day',
    'Standard': 'P2,000-5,000/day',
    'Premium': 'P5,000+/day',
  };

  static const List<String> _preferences = [
    'Trekking & Hiking', 'Waterfalls', 'Caves', 'Mountain Climbing', 'Forests',
    'Rivers', 'Camping', 'Zipline', 'ATV Riding', 'Rock Climbing',
    'Wildlife & Birdwatching', 'Nature Reserves', 'Eco-Parks', 'Botanical Gardens',
    'Island Hopping', 'White Sand Beaches', 'Surfing', 'Scuba Diving',
    'Snorkeling', 'Free Diving', 'Wakeboarding', 'Kayaking', 'Sunset Viewing',
    'Indigenous Tribes', 'Historical Landmarks', 'Museums',
    'Local Festivals (Kadayawan, etc.)', 'Heritage Tours', 'Traditional Crafts',
    'Weaving', 'Local Music & Dance', 'Architecture', 'Monuments',
    'Durian Tasting', 'Coffee Shops', 'Cacao & Chocolate (Malagos)',
    'Street Food', 'Seafood', 'Halal Food', 'Local Delicacies',
    'Farm to Table', 'Night Markets', 'Cooking Classes',
    'Shopping', 'Spa & Wellness', 'City Tours', 'Nightlife', 'Theme Parks',
    'Photography Walks', 'Staycations', 'Golfing', 'Resorts', 'Souvenir Shopping',
  ];

  bool get _canSearch =>
      _selectedLocation != null &&
      _startDate != null &&
      _endDate != null &&
      _selectedInterests.isNotEmpty &&
      _travelStyle != null &&
      _touristType != null &&
      _budgetRange != null;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showLocationSheet() {
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
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Select Location', style: AppTheme.headline(size: 20)),
            const SizedBox(height: 8),
            Text(
              'Choose your destination province',
              style: AppTheme.body(size: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ..._locations.map((loc) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Icon(
                _selectedLocation == loc
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: _selectedLocation == loc
                    ? AppColors.primary
                    : AppColors.textLight,
                size: 22,
              ),
              title: Text(loc, style: AppTheme.body(
                size: 15,
                weight: _selectedLocation == loc ? FontWeight.w700 : FontWeight.w400,
                color: _selectedLocation == loc ? AppColors.primary : AppColors.textPrimary,
              )),
              onTap: () {
                setState(() => _selectedLocation = loc);
                Navigator.pop(context);
              },
            )),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showDateSheet({required bool isStart}) {
    final now = DateTime.now();
    final initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);
    final firstDate = isStart ? now : (_startDate ?? now);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 480,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isStart ? 'Select Start Date' : 'Select End Date',
              style: AppTheme.headline(size: 20),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CalendarDatePicker(
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: isStart
                    ? now.add(const Duration(days: 365))
                    : (_startDate != null
                        ? _startDate!.add(const Duration(days: 6))
                        : now.add(const Duration(days: 365))),
                onDateChanged: (date) {
                  setState(() {
                    if (isStart) {
                      _startDate = date;
                      if (_endDate != null && _endDate!.isBefore(date)) {
                        _endDate = null;
                      }
                      if (_endDate != null &&
                          _endDate!.difference(date).inDays > 6) {
                        _endDate = null;
                      }
                    } else {
                      _endDate = date;
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInterestsSheet() {
    final tempSelected = Set<String>.from(_selectedInterests);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Design your Davao Experience', style: AppTheme.headline(size: 20)),
              const SizedBox(height: 4),
              Text(
                '${tempSelected.length}/5 selected',
                style: AppTheme.body(size: 13, color: tempSelected.length >= 5 ? AppColors.primary : AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _preferences.map((pref) {
                      final isSelected = tempSelected.contains(pref);
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            if (isSelected) {
                              tempSelected.remove(pref);
                            } else if (tempSelected.length < 5) {
                              tempSelected.add(pref);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                pref,
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.check,
                                    size: 16, color: Colors.white),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20, 12, 20, MediaQuery.of(context).padding.bottom + 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedInterests.clear();
                        _selectedInterests.addAll(tempSelected);
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      'Done (${tempSelected.length}/5)',
                      style: AppTheme.label(size: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFindGuide() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoamFreeLoadingScreen(
          location: _selectedLocation!,
          startDate: _startDate!,
          endDate: _endDate!,
          interests: _selectedInterests.toList(),
          isGuideMatch: true,
          travelStyle: _travelStyle,
          touristType: _touristType,
          budgetRange: _budgetRange,
          groupSize: _groupSize,
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
              child: Row(
                children: [
                  KuyogBackButton(
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text('Find a Guide', style: AppTheme.headline(size: 22)),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text('Go with a local guide',
                        style: AppTheme.headline(size: 26)),
                    const SizedBox(height: 4),
                    Text(
                      'Tell us about your trip and we\'ll match you with a certified local guide who knows the area.',
                      style: AppTheme.body(
                        size: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Location Selector
                    Text('Where would you like to go?',
                        style: AppTheme.label(size: 14)),
                    const SizedBox(height: 10),
                    _buildSelectorCard(
                      icon: Icons.location_on,
                      iconColor: _selectedLocation != null
                          ? AppColors.primary
                          : AppColors.textLight,
                      iconBgColor: AppColors.primary.withAlpha(20),
                      text: _selectedLocation ?? 'Select your destination',
                      isSelected: _selectedLocation != null,
                      onTap: _showLocationSheet,
                    ),
                    const SizedBox(height: 20),

                    // Date Selectors
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: _selectedLocation != null
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('When are you traveling?',
                              style: AppTheme.label(size: 14)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateCard(
                                  label: 'Start Date',
                                  date: _startDate,
                                  onTap: () =>
                                      _showDateSheet(isStart: true),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Opacity(
                                  opacity:
                                      _startDate != null ? 1.0 : 0.5,
                                  child: _buildDateCard(
                                    label: 'End Date',
                                    date: _endDate,
                                    onTap: _startDate != null
                                        ? () => _showDateSheet(
                                            isStart: false)
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // Travel Style
                    Text('Travel style', style: AppTheme.label(size: 14)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _travelStyles.map((style) {
                        final isSelected = _travelStyle == style;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _travelStyle = style),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.divider,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? null
                                  : AppShadows.card,
                            ),
                            child: Text(
                              style,
                              style: AppTheme.label(
                                size: 13,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Tourist Type
                    Text('Are you a local or international tourist?',
                        style: AppTheme.label(size: 14)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _touristTypes.map((type) {
                        final isSelected = _touristType == type;
                        return GestureDetector(
                          onTap: () => setState(() => _touristType = type),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: 1.5),
                              boxShadow: isSelected ? null : AppShadows.card,
                            ),
                            child: Text(type, style: AppTheme.label(size: 13, color: isSelected ? Colors.white : AppColors.textPrimary)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Budget Range
                    Text('Budget range', style: AppTheme.label(size: 14)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _budgetRanges.map((b) {
                        final isSelected = _budgetRange == b;
                        return GestureDetector(
                          onTap: () => setState(() => _budgetRange = b),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: 1.5),
                              boxShadow: isSelected ? null : AppShadows.card,
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(b, style: AppTheme.label(size: 13, color: isSelected ? Colors.white : AppColors.textPrimary)),
                              Text(_budgetDescriptions[b]!, style: AppTheme.body(size: 10, color: isSelected ? Colors.white70 : AppColors.textLight)),
                            ]),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Group Size
                    Text('Number of people', style: AppTheme.label(size: 14)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(children: [
                        const Icon(Icons.group, size: 22, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(child: Text('$_groupSize ${_groupSize == 1 ? 'person' : 'people'}', style: AppTheme.label(size: 15))),
                        GestureDetector(
                          onTap: _groupSize > 1 ? () => setState(() => _groupSize--) : null,
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: _groupSize > 1 ? AppColors.primary.withAlpha(15) : AppColors.divider.withAlpha(50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.remove, size: 18, color: _groupSize > 1 ? AppColors.primary : AppColors.textLight),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('$_groupSize', style: AppTheme.headline(size: 18)),
                        ),
                        GestureDetector(
                          onTap: _groupSize < 20 ? () => setState(() => _groupSize++) : null,
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: _groupSize < 20 ? AppColors.primary.withAlpha(15) : AppColors.divider.withAlpha(50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add, size: 18, color: _groupSize < 20 ? AppColors.primary : AppColors.textLight),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // Interests Selector
                    Text('Design your Davao Experience',
                        style: AppTheme.label(size: 14)),
                    const SizedBox(height: 10),
                    _buildSelectorCard(
                      icon: Icons.interests,
                      iconColor: _selectedInterests.isNotEmpty
                          ? AppColors.accent
                          : AppColors.textLight,
                      iconBgColor: AppColors.accent.withAlpha(20),
                      text: _selectedInterests.isNotEmpty
                          ? '${_selectedInterests.length} interests selected'
                          : 'Tap to choose your interests',
                      isSelected: _selectedInterests.isNotEmpty,
                      onTap: _showInterestsSheet,
                    ),
                    if (_selectedInterests.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedInterests
                            .map((interest) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(20),
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.pill),
                                  ),
                                  child: Text(
                                    interest,
                                    style: AppTheme.label(
                                        size: 11,
                                        color: AppColors.primary),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 36),

                    // Find My Guide Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _canSearch ? _onFindGuide : null,
                        icon:
                            const Icon(Icons.person_search, size: 20),
                        label: Text(
                          'Find My Guide',
                          style: AppTheme.label(
                              size: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSearch
                              ? AppColors.primary
                              : AppColors.divider,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.divider,
                          disabledForegroundColor: AppColors.textLight,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
          border: isSelected
              ? Border.all(
                  color: AppColors.primary.withAlpha(80), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: AppTheme.body(
                  size: 15,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textLight,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required DateTime? date,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
          border: date != null
              ? Border.all(
                  color: AppColors.primary.withAlpha(80), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTheme.body(
                    size: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: date != null
                      ? AppColors.primary
                      : AppColors.textLight,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date) : 'Select',
                    style: AppTheme.label(
                      size: 13,
                      color: date != null
                          ? AppColors.textPrimary
                          : AppColors.textLight,
                    ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/travel_provider.dart';
import '../../../widgets/durie_mascot.dart';
import '../../../widgets/kuyog_back_button.dart';

class TravelTypeScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const TravelTypeScreen({super.key, required this.onContinue});

  @override
  State<TravelTypeScreen> createState() => _TravelTypeScreenState();
}

class _TravelTypeScreenState extends State<TravelTypeScreen> {
  String? _selectedTravelType;
  String? _selectedGuideType;
  bool _showComparison = false;

  void _onContinue(BuildContext context) {
    if (_selectedTravelType != null && _selectedGuideType != null) {
      context.read<TravelProvider>().setTravelAndGuideType(
            _selectedTravelType!,
            _selectedGuideType!,
          );
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedTravelType != null && _selectedGuideType != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const DurieMascot(size: 80),
                    const SizedBox(height: 16),
                    Text(
                      'Choose your travel style to get the best guide recommendations.',
                      style: AppTheme.body(size: 15, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildTravelCard(
                      type: 'solo',
                      icon: Icons.person_outline,
                      title: 'Travel as Individual',
                      description: 'Just you, exploring Mindanao at your own pace.',
                    ),
                    const SizedBox(height: 16),
                    _buildTravelCard(
                      type: 'group',
                      icon: Icons.groups_outlined,
                      title: 'Travel as Group',
                      description: 'Traveling with friends, family, or colleagues? Let\'s plan together.',
                    ),
                    const SizedBox(height: 24),
                    _buildComparisonSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildBottomBar(canContinue),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
      child: Row(
        children: [
          KuyogBackButton(onTap: () => Navigator.pop(context)),
          Expanded(
            child: Text(
              'How are you traveling?',
              style: AppTheme.headline(size: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), // Balance back button
        ],
      ),
    );
  }

  Widget _buildTravelCard({
    required String type,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final bool isSelected = _selectedTravelType == type;

    return GestureDetector(
      onTap: () => setState(() {
        if (_selectedTravelType != type) {
          _selectedTravelType = type;
          _selectedGuideType = null; // Reset guide type on travel type change
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.headline(size: 18, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(description, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text('Select Guide Type:', style: AppTheme.label(size: 13)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGuideChip(
                      guideType: 'community',
                      label: 'Community Guide',
                      icon: Icons.eco,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGuideChip(
                      guideType: 'regional',
                      label: 'Regional Guide',
                      icon: Icons.terrain,
                      color: AppColors.touristBlue,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuideChip({
    required String guideType,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final bool isSelected = _selectedGuideType == guideType;

    return GestureDetector(
      onTap: () => setState(() => _selectedGuideType = guideType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : color),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTheme.label(
                size: 11,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showComparison = !_showComparison),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("What's the difference?", style: AppTheme.label(size: 14, color: AppColors.primary)),
              const SizedBox(width: 4),
              Icon(
                _showComparison ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        if (_showComparison) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.eco, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Expanded(child: Text('Community Guide', style: AppTheme.label(size: 14, color: AppColors.primary))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _comparisonItem('Local community area'),
                          _comparisonItem('7-day training'),
                          _comparisonItem('LGU endorsed'),
                          const SizedBox(height: 8),
                          Text(
                            'Best for: local spots, barangay experiences, cultural immersion',
                            style: AppTheme.body(size: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 140, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.terrain, size: 16, color: AppColors.touristBlue),
                              const SizedBox(width: 6),
                              Expanded(child: Text('Regional Guide', style: AppTheme.label(size: 14, color: AppColors.touristBlue))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _comparisonItem('Broader regional coverage'),
                          _comparisonItem('30-day training'),
                          _comparisonItem('DOT Accredited'),
                          const SizedBox(height: 8),
                          Text(
                            'Best for: cross-province adventures, national parks, multi-day tours',
                            style: AppTheme.body(size: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _comparisonItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 4, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: AppTheme.body(size: 12))),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool canContinue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canContinue ? () => _onContinue(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            disabledBackgroundColor: AppColors.divider,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Continue',
            style: AppTheme.label(
              size: 16,
              color: canContinue ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

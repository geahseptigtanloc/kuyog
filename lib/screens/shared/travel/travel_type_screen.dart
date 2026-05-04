import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/travel_provider.dart';
import '../../../widgets/durie_mascot.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'group_setup_screen.dart';
import 'ai_matching_screen.dart';

class TravelTypeScreen extends StatefulWidget {
  final String? initialType; // 'Solo' or 'Group'
  final VoidCallback? onBack;
  final Function(String travelType, String guideType)? onContinue;

  const TravelTypeScreen({super.key, this.initialType, this.onBack, this.onContinue});

  @override
  State<TravelTypeScreen> createState() => _TravelTypeScreenState();
}

class _TravelTypeScreenState extends State<TravelTypeScreen> {
  String? _selectedTravelType;
  String? _selectedGuideType;
  bool _showComparison = false;

  @override
  void initState() {
    super.initState();
    _selectedTravelType = widget.initialType?.toLowerCase() ?? 'solo';
  }

  void _onContinue(BuildContext context) {
    if (_selectedTravelType != null && _selectedGuideType != null) {
      if (widget.onContinue != null) {
        widget.onContinue!(_selectedTravelType!, _selectedGuideType!);
      } else {
        context.read<TravelProvider>().setTravelAndGuideType(
              _selectedTravelType!,
              _selectedGuideType!,
            );
        if (_selectedTravelType == 'group') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GroupSetupScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIMatchingScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedGuideType != null;

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
                      'Select your guide type to get the best matches for your ${_selectedTravelType ?? ''} trip.',
                      style: AppTheme.body(size: 15, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    _buildGuideCard(
                      type: 'community',
                      icon: Icons.nature_people,
                      title: 'Community Guide',
                      description: 'Local barangay-level guide. LGU endorsed. 7-day training. Best for local spots, cultural immersion, and hidden gems.',
                      badge: 'Community Certified',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    _buildGuideCard(
                      type: 'regional',
                      icon: Icons.hiking,
                      title: 'Regional Guide',
                      description: 'DOT accredited. 30-day training. Covers broader regional destinations, national parks, and multi-day cross-province tours.',
                      badge: 'DOT Accredited',
                      color: Colors.blue[700]!,
                    ),
                    
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
          KuyogBackButton(onTap: widget.onBack ?? () => Navigator.pop(context)),
          Expanded(
            child: Text(
              'Choose Your Guide Type',
              style: AppTheme.headline(size: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), 
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required String type,
    required IconData icon,
    required String title,
    required String description,
    required String badge,
    required Color color,
  }) {
    final bool isSelected = _selectedGuideType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedGuideType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.headline(size: 18, color: isSelected ? color : AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(badge, style: AppTheme.label(size: 10, color: color)),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                   Icon(Icons.check_circle, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
          ],
        ),
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

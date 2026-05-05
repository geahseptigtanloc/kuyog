import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../data/services/onboarding_service.dart';
import '../../providers/role_provider.dart';

class TravelProfileScreen extends StatefulWidget {
  final VoidCallback onNext;

  const TravelProfileScreen({super.key, required this.onNext});

  @override
  State<TravelProfileScreen> createState() => _TravelProfileScreenState();
}

class _TravelProfileScreenState extends State<TravelProfileScreen> {
  String _travelerType = 'solo';
  String _visitorType = 'domestic';
  String _budgetRange = 'standard';
  int _groupSize = 1;
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final user = roleProvider.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final onboarding = OnboardingService();
      
      await onboarding.saveTouristPreferences(
        userId: user.id,
        travelStyle: _travelerType,
        countryOfOrigin: _visitorType,
        budgetRange: _budgetRange,
      );
      
      widget.onNext();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving preferences: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.maybePop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 0.5,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Travel Profile',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Help us tailor the perfect Mindanao experience for you. You can change these anytime.',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              
              Text('Who are you traveling with?', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _radioRow([
                ('solo', 'Solo', Icons.person),
                ('couple', 'Couple', Icons.favorite),
                ('family', 'Family', Icons.family_restroom),
                ('group', 'Group', Icons.groups),
              ], _travelerType, (v) => setState(() => _travelerType = v)),
              
              if (_travelerType != 'solo') ...[
                const SizedBox(height: 16),
                Row(children: [
                  Text('Group Size:', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(width: 16),
                  IconButton(onPressed: _groupSize > 1 ? () => setState(() => _groupSize--) : null, icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary)),
                  Text('$_groupSize', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: _groupSize < 20 ? () => setState(() => _groupSize++) : null, icon: const Icon(Icons.add_circle_outline, color: AppColors.primary)),
                ]),
              ],
              
              const SizedBox(height: 32),
              Text('Where are you from?', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _radioRow([
                ('domestic', 'Philippines', Icons.location_on),
                ('international', 'International', Icons.public),
              ], _visitorType, (v) => setState(() => _visitorType = v)),

              const SizedBox(height: 32),
              Text('What\'s your budget style?', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _radioRow([
                ('economy', 'Economy', Icons.savings),
                ('standard', 'Standard', Icons.account_balance_wallet),
                ('premium', 'Premium', Icons.star),
              ], _budgetRange, (v) => setState(() => _budgetRange = v)),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleConfirm,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Continue', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioRow(List<(String, String, IconData)> options, String currentVal, ValueChanged<String> onChanged) {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: options.map((opt) {
        final isSelected = currentVal == opt.$1;
        return GestureDetector(
          onTap: () => onChanged(opt.$1),
          child: Container(
            width: (MediaQuery.of(context).size.width - 48 - 12) / 2, // 2 columns
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withAlpha(20) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: isSelected ? 1.5 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(opt.$3, color: isSelected ? AppColors.primary : AppColors.textLight, size: 24),
                const SizedBox(height: 8),
                Text(opt.$2, style: GoogleFonts.nunito(fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}


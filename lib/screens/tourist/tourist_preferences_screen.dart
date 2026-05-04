import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';
import '../../providers/role_provider.dart';

class TouristPreferencesScreen extends StatefulWidget {
  const TouristPreferencesScreen({super.key});

  @override
  State<TouristPreferencesScreen> createState() => _TouristPreferencesScreenState();
}

class _TouristPreferencesScreenState extends State<TouristPreferencesScreen> {
  final List<String> _allInterests = [
    'Nature & Adventure',
    'Cultural Heritage',
    'Food & Culinary',
    'Local Lifestyle',
    'Photography',
    'Shopping',
    'Nightlife',
    'Eco-Tourism',
    'Beach & Water Sports',
    'Religious Sites',
  ];

  List<String> _selectedInterests = [];
  String _travelStyle = 'Comfort';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) return;

    try {
      final res = await Supabase.instance.client
          .from('tourist_preferences')
          .select()
          .eq('profile_id', user.id)
          .maybeSingle();
      
      if (res != null && mounted) {
        setState(() {
          _selectedInterests = List<String>.from(res['interests'] ?? []);
          _travelStyle = res['travel_style'] ?? 'Comfort';
        });
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _savePreferences() async {
    final user = context.read<RoleProvider>().currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final data = {
        'profile_id': user.id,
        'interests': _selectedInterests,
        'travel_style': _travelStyle,
      };

      await Supabase.instance.client
          .from('tourist_preferences')
          .upsert(data, onConflict: 'profile_id');

      // Refresh role provider to sync interests
      if (mounted) await context.read<RoleProvider>().initialize();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved! Matching scores updated.'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
            child: Row(children: [
              KuyogBackButton(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Text('Match Preferences', style: AppTheme.headline(size: 20)),
              const Spacer(),
              if (_isSaving)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              else
                TextButton(
                  onPressed: _savePreferences,
                  child: Text('Save', style: AppTheme.label(size: 16, color: AppColors.primary)),
                ),
            ]),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('What are you looking for?', style: AppTheme.headline(size: 18)),
                    const SizedBox(height: 8),
                    Text('Select interests to find guides who specialize in what you love.', 
                      style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 24),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allInterests.map((interest) {
                        final isSelected = _selectedInterests.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primary,
                          labelStyle: AppTheme.label(
                            size: 13, 
                            color: isSelected ? AppColors.primary : AppColors.textSecondary
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: BorderSide(color: isSelected ? AppColors.primary : AppColors.divider),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    Text('Travel Style', style: AppTheme.headline(size: 18)),
                    const SizedBox(height: 16),
                    _styleOption('Budget', 'I prefer affordable and local experiences.', Icons.savings),
                    _styleOption('Comfort', 'A balance of quality and value.', Icons.hotel),
                    _styleOption('Luxury', 'Premium, high-end services and comfort.', Icons.diamond),
                    
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Smart Matching Active', style: AppTheme.label(size: 15, color: AppColors.primary)),
                          Text('Your Explore tab will now feature guides who share your interests.', 
                            style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                        ])),
                      ]),
                    ),
                  ],
                ),
          ),
        ]),
      ),
    );
  }

  Widget _styleOption(String title, String subtitle, IconData icon) {
    final isSelected = _travelStyle == title;
    return GestureDetector(
      onTap: () => setState(() => _travelStyle = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textLight),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTheme.label(size: 15, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
            Text(subtitle, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
          ])),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
        ]),
      ),
    );
  }
}

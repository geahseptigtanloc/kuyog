import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../providers/role_provider.dart';
import '../../widgets/terms_agreement_sheet.dart';

class TourPreferencesScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final String title;
  final String subtitle;

  const TourPreferencesScreen({
    super.key,
    required this.onContinue,
    this.title = 'Tour Preferences',
    this.subtitle = 'Share your travel preferences, and we\'ll personalize recommendations. No worries! You can modify them later in settings.',
  });

  @override
  State<TourPreferencesScreen> createState() => _TourPreferencesScreenState();
}

class _TourPreferencesScreenState extends State<TourPreferencesScreen> {
  final Set<String> _selected = {};

  static const List<String> _preferences = [
    'Nature & Outdoors',
    'Water Sports',
    'Culture & Heritage',
    'Food & Culinary',
    'Trekking',
    'Photography',
    'Festivals',
    'Diving & Snorkeling',
    'Volcano Tours',
    'River Adventures',
    'Village & Homestay',
    'Wildlife & Birdwatching',
    'Arts & Crafts',
    'Wellness & Spa',
    'Cycling Tours',
    'Beach & Island',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
        actions: [
          TextButton(
            onPressed: () {
              TermsAgreementSheet.checkAndShow(context, UserRole.tourist, widget.onContinue);
            },
            child: Text('Skip', style: GoogleFonts.nunito(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Progress bar
              LinearProgressIndicator(
                value: 0.75,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Text(widget.title, style: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text(widget.subtitle, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 8),
              Text('Select at least 3', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _preferences.map((pref) {
                  final isSelected = _selected.contains(pref);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selected.remove(pref);
                        } else {
                          _selected.add(pref);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(pref, style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          )),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.check, size: 16, color: Colors.white),
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
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected.length >= 3
                    ? () {
                        TermsAgreementSheet.checkAndShow(context, UserRole.tourist, widget.onContinue);
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select at least 3 preferences'), backgroundColor: AppColors.warning),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selected.length >= 3 ? AppColors.primary : AppColors.divider,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Continue (${_selected.length}/3+)'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

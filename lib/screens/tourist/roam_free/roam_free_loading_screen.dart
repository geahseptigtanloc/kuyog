import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_logo.dart';
import 'roam_free_generated_screen.dart';
import 'roam_free_guide_result_screen.dart';

class RoamFreeLoadingScreen extends StatefulWidget {
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> interests;
  final bool isGuideMatch;
  final String? travelStyle;
  final String? touristType;
  final String? budgetRange;
  final int groupSize;

  const RoamFreeLoadingScreen({
    super.key,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.interests,
    this.isGuideMatch = false,
    this.travelStyle,
    this.touristType,
    this.budgetRange,
    this.groupSize = 1,
  });

  @override
  State<RoamFreeLoadingScreen> createState() => _RoamFreeLoadingScreenState();
}

class _RoamFreeLoadingScreenState extends State<RoamFreeLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => widget.isGuideMatch
                ? RoamFreeGuideResultScreen(
                    location: widget.location,
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                    interests: widget.interests,
                  )
                : RoamFreeGeneratedScreen(
                    location: widget.location,
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                    interests: widget.interests,
                  ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const KuyogLogo(fontSize: 50, type: KuyogLogoType.green),
            const SizedBox(height: 32),
            Text(
              widget.isGuideMatch
                  ? 'Finding your perfect guide...'
                  : 'Generating your trip...',
              style: AppTheme.headline(size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isGuideMatch
                  ? 'Matching based on your interests and dates'
                  : 'Finding the best destinations for you',
              style: AppTheme.body(size: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

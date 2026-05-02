import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/durie_mascot.dart';

class TripInviteScreen extends StatelessWidget {
  final VoidCallback onAccept;
  
  const TripInviteScreen({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DurieMascot(size: 100),
              const SizedBox(height: 24),
              Text('You\'re Invited!', style: AppTheme.headline(size: 28, color: AppColors.primary)),
              const SizedBox(height: 12),
              Text(
                'Maria Santos has invited you to join a trip to Mindanao.',
                textAlign: TextAlign.center,
                style: AppTheme.body(size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.cardHover,
                ),
                child: Column(
                  children: [
                    Text('Barkada Davao Trip 2025', style: AppTheme.headline(size: 18)),
                    const SizedBox(height: 16),
                    _detailRow(Icons.calendar_today, 'Dates TBD'),
                    _detailRow(Icons.group, '4 Members Joined'),
                    _detailRow(Icons.eco, 'Community Guide Setup'),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text('Accept Invitation', style: AppTheme.label(size: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Decline', style: AppTheme.label(size: 14, color: AppColors.textLight)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(text, style: AppTheme.body(size: 15)),
        ],
      ),
    );
  }
}

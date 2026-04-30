import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/miles_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MilesDashboardScreen extends StatelessWidget {
  const MilesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final miles = context.watch<MilesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Kuyog Miles', style: AppTheme.headline(size: 20, color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header / Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.stars, size: 64, color: AppColors.accent),
                  const SizedBox(height: 16),
                  Text('Total Balance', style: AppTheme.body(size: 14, color: Colors.white70)),
                  Text('${miles.balance}', style: AppTheme.headline(size: 48, color: Colors.white)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(Icons.card_giftcard, 'Redeem'),
                      _actionButton(Icons.swap_horiz, 'Transfer'),
                      _actionButton(Icons.add_circle_outline, 'Earn'),
                    ],
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Membership Tier
                  Text('Membership Tier', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.xl), boxShadow: AppShadows.card),
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 8.0,
                          percent: 0.65,
                          center: const Icon(Icons.workspace_premium, color: AppColors.primary, size: 32),
                          progressColor: AppColors.primary,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gold Explorer', style: AppTheme.label(size: 18, color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text('3,500 more miles to reach Platinum tier', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              Text('View Benefits', style: AppTheme.label(size: 12, color: AppColors.accent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Active Challenges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Challenges', style: AppTheme.headline(size: 18)),
                      Text('View All', style: AppTheme.label(size: 13, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _challengeCard('Visit 3 Waterfalls', 'Earn 500 Miles', 0.6, '2/3 completed'),
                  _challengeCard('Book a Local Guide', 'Earn 300 Miles', 0.0, '0/1 completed'),
                  _challengeCard('Try Tnalak Weaving', 'Earn 1000 Miles', 0.0, '0/1 completed'),
                  const SizedBox(height: 32),

                  // Recent Transactions
                  Text('Recent Activity', style: AppTheme.headline(size: 18)),
                  const SizedBox(height: 16),
                  _transactionTile(Icons.store, 'Marketplace Purchase', 'Applied Discount', -250),
                  _transactionTile(Icons.map, 'Guided Tour Completed', 'Mt. Apo Trek', 1500),
                  _transactionTile(Icons.person_add, 'Referral Bonus', 'Invited friend', 500),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTheme.body(size: 12, color: Colors.white)),
      ],
    );
  }

  Widget _challengeCard(String title, String reward, double progress, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTheme.label(size: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Text(reward, style: AppTheme.label(size: 11, color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(status, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _transactionTile(IconData icon, String title, String subtitle, int amount) {
    final isPositive = amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.divider)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.label(size: 14)),
                Text(subtitle, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}$amount',
            style: AppTheme.label(size: 16, color: isPositive ? AppColors.success : AppColors.error),
          ),
        ],
      ),
    );
  }
}

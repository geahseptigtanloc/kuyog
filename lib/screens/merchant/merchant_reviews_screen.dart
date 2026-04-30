import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class MerchantReviewsScreen extends StatelessWidget {
  const MerchantReviewsScreen({super.key});

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
              Text('Customer Reviews', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Text('4.8', style: AppTheme.headline(size: 40, color: AppColors.merchantAmber)),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: List.generate(5, (i) => Icon(i < 4 ? Icons.star : Icons.star_half, color: AppColors.warning, size: 20))),
                const SizedBox(height: 4),
                Text('Based on 124 reviews', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
              ]),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _reviewCard('Anna B.', '5', 'The T\'nalak bag is beautiful! Authentic and very high quality.', '2 days ago', true),
                _reviewCard('Mark S.', '4', 'Good quality, but shipping took a bit longer than expected.', '1 week ago', false),
                _reviewCard('Jessica L.', '5', 'Perfect souvenir! I bought 5 of these for my friends back home.', '2 weeks ago', true),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _reviewCard(String name, String rating, String comment, String time, bool replied) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(name[0], style: AppTheme.label(size: 14, color: AppColors.primary))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTheme.label(size: 14)),
            Text(time, style: AppTheme.body(size: 11, color: AppColors.textLight)),
          ])),
          Row(children: [
            const Icon(Icons.star, color: AppColors.warning, size: 16),
            const SizedBox(width: 4),
            Text(rating, style: AppTheme.label(size: 14)),
          ]),
        ]),
        const SizedBox(height: 12),
        Text(comment, style: AppTheme.body(size: 14)),
        const SizedBox(height: 12),
        if (replied)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.subdirectory_arrow_right, size: 16, color: AppColors.textLight),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Merchant Reply', style: AppTheme.label(size: 12)),
                const SizedBox(height: 4),
                Text('Thank you so much, $name! We are glad you loved it.', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
              ])),
            ]),
          )
        else
          TextButton(onPressed: () {}, child: Text('Reply', style: AppTheme.label(size: 13, color: AppColors.merchantAmber))),
      ]),
    );
  }
}

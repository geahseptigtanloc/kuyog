import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class GuidePricingScreen extends StatefulWidget {
  const GuidePricingScreen({super.key});
  @override
  State<GuidePricingScreen> createState() => _GuidePricingScreenState();
}

class _GuidePricingScreenState extends State<GuidePricingScreen> {
  final _hourlyCtrl = TextEditingController(text: '350');
  final _dailyCtrl = TextEditingController(text: '2500');

  @override
  void dispose() { _hourlyCtrl.dispose(); _dailyCtrl.dispose(); super.dispose(); }

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
              Text('Pricing & Rates', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                _field('Hourly Rate (PHP)', _hourlyCtrl),
                const SizedBox(height: 16),
                _field('Daily Rate (PHP)', _dailyCtrl),
                const SizedBox(height: 24),
                Text('Standard Kuyog guide rates range from ₱300-₱500/hr depending on experience and certifications.', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rates updated'), backgroundColor: AppColors.primary));
                },
                child: const Text('Save Rates'),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTheme.label(size: 14)),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
        ),
      ),
    ]);
  }
}

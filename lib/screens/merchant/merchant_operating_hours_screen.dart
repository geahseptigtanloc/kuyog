import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class MerchantOperatingHoursScreen extends StatefulWidget {
  const MerchantOperatingHoursScreen({super.key});
  @override
  State<MerchantOperatingHoursScreen> createState() => _MerchantOperatingHoursScreenState();
}

class _MerchantOperatingHoursScreenState extends State<MerchantOperatingHoursScreen> {
  final Map<String, bool> _days = {
    'Monday': true, 'Tuesday': true, 'Wednesday': true, 'Thursday': true,
    'Friday': true, 'Saturday': true, 'Sunday': false,
  };

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
              Text('Operating Hours', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: _days.length,
              itemBuilder: (ctx, i) {
                final day = _days.keys.elementAt(i);
                final isOpen = _days[day]!;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
                  child: Row(children: [
                    Expanded(child: Text(day, style: AppTheme.label(size: 15))),
                    if (isOpen) ...[
                      Text('08:00 AM - 05:00 PM', style: AppTheme.body(size: 14)),
                      const SizedBox(width: 16),
                    ] else ...[
                      Text('Closed', style: AppTheme.body(size: 14, color: AppColors.error)),
                      const SizedBox(width: 16),
                    ],
                    Switch(
                      value: isOpen,
                      onChanged: (v) => setState(() => _days[day] = v),
                      activeColor: AppColors.merchantAmber,
                    ),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

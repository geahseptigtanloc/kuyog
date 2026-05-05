import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class GuideAvailabilityScreen extends StatefulWidget {
  const GuideAvailabilityScreen({super.key});
  @override
  State<GuideAvailabilityScreen> createState() => _GuideAvailabilityScreenState();
}

class _GuideAvailabilityScreenState extends State<GuideAvailabilityScreen> {
  final List<int> _blockedDays = [12, 14, 15, 22]; // Mock blocked dates for current month

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
              Text('Availability Calendar', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
                      Text('May 2026', style: AppTheme.headline(size: 16)),
                      IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
                    ]),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
                      itemCount: 31,
                      itemBuilder: (ctx, i) {
                        final day = i + 1;
                        final isBlocked = _blockedDays.contains(day);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isBlocked) {
                                _blockedDays.remove(day);
                              } else {
                                _blockedDays.add(day);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isBlocked ? AppColors.error.withAlpha(26) : AppColors.primary.withAlpha(13),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: isBlocked ? Border.all(color: AppColors.error) : null,
                            ),
                            alignment: Alignment.center,
                            child: Text('$day', style: AppTheme.label(size: 14, color: isBlocked ? AppColors.error : AppColors.textPrimary)),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 24),
                Text('Legend', style: AppTheme.headline(size: 16)),
                const SizedBox(height: 12),
                Row(children: [
                  Container(width: 16, height: 16, decoration: BoxDecoration(color: AppColors.primary.withAlpha(13), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Text('Available', style: AppTheme.body(size: 14)),
                  const SizedBox(width: 24),
                  Container(width: 16, height: 16, decoration: BoxDecoration(color: AppColors.error.withAlpha(26), border: Border.all(color: AppColors.error), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Text('Blocked / Booked', style: AppTheme.body(size: 14)),
                ]),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calendar updated!'), backgroundColor: AppColors.primary));
                },
                child: const Text('Save Changes'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}


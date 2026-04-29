import 'package:flutter/material.dart';
import '../../app_theme.dart';

class AdminReportsTab extends StatelessWidget {
  const AdminReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), child: Text('Reports', style: AppTheme.headline(size: 24))),
          Expanded(child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _reportCard('Fake Profile', 'User reported a suspicious guide profile', 'High', AppColors.error),
              _reportCard('Inappropriate Content', 'Post contains misleading information', 'Medium', AppColors.warning),
              _reportCard('Safety Concern', 'Tourist reported unsafe tour conditions', 'High', AppColors.error),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _reportCard(String type, String desc, String priority, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text(type, style: AppTheme.label(size: 11, color: color))),
          const Spacer(),
          Text(priority, style: AppTheme.label(size: 11, color: color)),
        ]),
        const SizedBox(height: 8),
        Text(desc, style: AppTheme.body(size: 13)),
        const SizedBox(height: 12),
        Row(children: [
          _actionBtn('Warn', AppColors.warning),
          const SizedBox(width: 8),
          _actionBtn('Suspend', AppColors.error),
          const SizedBox(width: 8),
          _actionBtn('Dismiss', AppColors.textSecondary),
        ]),
      ]),
    );
  }

  Widget _actionBtn(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: AppTheme.label(size: 11, color: color)),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class AdminBroadcastScreen extends StatefulWidget {
  const AdminBroadcastScreen({super.key});
  @override
  State<AdminBroadcastScreen> createState() => _AdminBroadcastScreenState();
}

class _AdminBroadcastScreenState extends State<AdminBroadcastScreen> {
  final _titleCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  String _target = 'All Users';

  @override
  void dispose() { _titleCtrl.dispose(); _msgCtrl.dispose(); super.dispose(); }

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
              Text('Send Broadcast', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                Text('Target Audience', style: AppTheme.label(size: 14)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: ['All Users', 'Tourists', 'Guides', 'Merchants'].map((t) => ChoiceChip(
                  label: Text(t),
                  selected: _target == t,
                  onSelected: (_) => setState(() => _target = t),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _target == t ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                )).toList()),
                const SizedBox(height: 24),
                Text('Notification Title', style: AppTheme.label(size: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g. System Maintenance',
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Message Body', style: AppTheme.label(size: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _msgCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your message here...',
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
                  ),
                ),
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
                  if (_titleCtrl.text.isNotEmpty && _msgCtrl.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Broadcast sent successfully'), backgroundColor: AppColors.primary));
                  }
                },
                child: const Text('Send Notification'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class AdminInviteScreen extends StatefulWidget {
  const AdminInviteScreen({super.key});
  @override
  State<AdminInviteScreen> createState() => _AdminInviteScreenState();
}

class _AdminInviteScreenState extends State<AdminInviteScreen> {
  final _emailCtrl = TextEditingController();
  String _role = 'Admin';

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

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
              Text('Invite Administrator', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                Text('Email Address', style: AppTheme.label(size: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'e.g. juan@kuyog.app',
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Role Level', style: AppTheme.label(size: 14)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: ['Admin', 'Super Admin'].map((r) => ChoiceChip(
                  label: Text(r),
                  selected: _role == r,
                  onSelected: (_) => setState(() => _role = r),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _role == r ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                )).toList()),
                const SizedBox(height: 24),
                Text('An invitation email will be sent with instructions to set up their account.', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
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
                  if (_emailCtrl.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invite sent to ${_emailCtrl.text}'), backgroundColor: AppColors.primary));
                  }
                },
                child: const Text('Send Invitation'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

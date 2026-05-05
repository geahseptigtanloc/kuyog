import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/kuyog_back_button.dart';

class AdminManageRolesScreen extends StatelessWidget {
  const AdminManageRolesScreen({super.key});

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
              Text('Manage Roles', style: AppTheme.headline(size: 20)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search user by email or name...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _userTile('Rico M.', 'rico@example.com', 'Guide'),
                _userTile('T\'boli Weaves Co.', 'tboli@example.com', 'Merchant'),
                _userTile('Maria Santos', 'maria@example.com', 'Tourist'),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _userTile(String name, String email, String role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withAlpha(26), child: Text(name[0], style: AppTheme.label(size: 16, color: AppColors.primary))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 15)),
          Text(email, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
          child: Text(role, style: AppTheme.label(size: 12, color: AppColors.primary)),
        ),
      ]),
    );
  }
}


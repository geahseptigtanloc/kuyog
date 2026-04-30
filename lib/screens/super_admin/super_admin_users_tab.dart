import 'package:flutter/material.dart';
import '../../app_theme.dart';

class SuperAdminUsersTab extends StatelessWidget {
  const SuperAdminUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
            Text('User Management', style: AppTheme.headline(size: 24)),
          ])),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), boxShadow: AppShadows.card),
            child: Row(children: [
              const Icon(Icons.search, color: AppColors.textLight, size: 20),
              const SizedBox(width: 10),
              Text('Search users...', style: AppTheme.body(size: 14, color: AppColors.textLight)),
            ]),
          )),
          const SizedBox(height: 12),
          SizedBox(height: 36, child: ListView(
            scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 20),
            children: ['All', 'Tourist', 'Guide', 'Merchant', 'Admin'].map((f) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(f), selected: f == 'All', onSelected: (_) {},
                selectedColor: AppColors.primary, labelStyle: TextStyle(color: f == 'All' ? Colors.white : AppColors.textPrimary, fontSize: 12)),
            )).toList(),
          )),
          const SizedBox(height: 12),
          Expanded(child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _userTile('Maria Santos', 'Tourist', 'Active', AppColors.touristBlue),
              _userTile('Juan dela Cruz', 'Guide', 'Active', AppColors.primary),
              _userTile('Fatima Abubakar', 'Guide', 'Active', AppColors.primary),
              _userTile('T\'boli Weaves Co.', 'Merchant', 'Active', AppColors.merchantAmber),
              _userTile('Davao Delights', 'Merchant', 'Active', AppColors.merchantAmber),
              _userTile('Rico Magbanua', 'Guide', 'Pending', AppColors.warning),
              _userTile('Anna Reyes', 'Tourist', 'Active', AppColors.touristBlue),
              _userTile('Mike Torres', 'Tourist', 'Active', AppColors.touristBlue),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _userTile(String name, String role, String status, Color roleColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: roleColor.withOpacity(0.15), child: Icon(Icons.person, color: roleColor, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTheme.label(size: 14)),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text(role, style: AppTheme.body(size: 10, color: roleColor))),
            const SizedBox(width: 6),
            Text(status, style: AppTheme.body(size: 11, color: status == 'Active' ? AppColors.verified : AppColors.warning)),
          ]),
        ])),
        const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
      ]),
    );
  }
}

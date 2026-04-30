import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';
import '../admin/admin_manage_roles_screen.dart';
import '../admin/admin_invite_screen.dart';
import '../admin/admin_broadcast_screen.dart';

class SuperAdminSettingsTab extends StatelessWidget {
  const SuperAdminSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('System Settings', style: AppTheme.headline(size: 24)),
            const SizedBox(height: 24),
            _section('Role Management', [
              _item(Icons.admin_panel_settings, 'Manage Roles & Permissions', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminManageRolesScreen()))),
              _item(Icons.person_add, 'Invite Admin', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminInviteScreen()))),
            ]),
            const SizedBox(height: 16),
            _section('Platform', [
              _item(Icons.settings_applications, 'Platform Configuration'),
              _item(Icons.campaign, 'Notification Broadcast', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminBroadcastScreen()))),
              _item(Icons.toggle_on, 'Feature Flags'),
            ]),
            const SizedBox(height: 16),
            _section('System Health', [
              _healthCard('API Server', '99.9%', AppColors.verified),
              _healthCard('Database', '99.7%', AppColors.verified),
              _healthCard('CDN', '100%', AppColors.verified),
              _healthCard('Payment Gateway', '99.5%', AppColors.warning),
            ]),
            const SizedBox(height: 16),
            _section('Account', [
              _item(Icons.logout, 'Logout', isDestructive: true, onTap: () => _showLogoutDialog(context)),
            ]),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTheme.headline(size: 16)),
      const SizedBox(height: 8),
      ...children,
    ]);
  }

  Widget _item(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(children: [
          Icon(icon, size: 20, color: isDestructive ? AppColors.error : AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(title, style: AppTheme.body(size: 14, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
          const Spacer(),
          Icon(Icons.chevron_right, size: 18, color: isDestructive ? AppColors.error : AppColors.textLight),
        ]),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Log out of Kuyog?', style: AppTheme.headline(size: 20)),
        content: Text('You will need to sign in again to access your account.', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/onboarding');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _healthCard(String service, String uptime, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Text(service, style: AppTheme.body(size: 14)),
        const Spacer(),
        Text('$uptime uptime', style: AppTheme.label(size: 12, color: color)),
      ]),
    );
  }
}

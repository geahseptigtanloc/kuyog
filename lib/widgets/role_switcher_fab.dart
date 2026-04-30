import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/role_provider.dart';

class RoleSwitcherFab extends StatelessWidget {
  const RoleSwitcherFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'role_switcher',
      backgroundColor: AppColors.primary,
      onPressed: () => _showRoleSwitcher(context),
      child: const Icon(Icons.swap_horiz, size: 20, color: Colors.white),
    );
  }

  void _showRoleSwitcher(BuildContext context) {
    final roleProvider = context.read<RoleProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Switch Role', style: AppTheme.headline(size: 18)),
              const SizedBox(height: 4),
              Text('Dev mode — testing tool',
                  style: AppTheme.body(
                      size: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              ...UserRole.values.map((role) {
                final isActive = roleProvider.currentRole == role;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    onTap: () {
                      roleProvider.switchRole(role);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color:
                              isActive ? AppColors.primary : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _roleColor(role).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Center(
                              child: Icon(_roleIcon(role),
                                  size: 20, color: _roleColor(role)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_roleName(role),
                                    style: AppTheme.label(size: 15)),
                                Text(_roleDesc(role),
                                    style: AppTheme.body(
                                        size: 12,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          if (isActive)
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.tourist:
        return Icons.luggage;
      case UserRole.guide:
        return Icons.explore;
      case UserRole.merchant:
        return Icons.store;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.superAdmin:
        return Icons.shield;
    }
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.tourist:
        return AppColors.touristBlue;
      case UserRole.guide:
        return AppColors.guideGreen;
      case UserRole.merchant:
        return AppColors.merchantAmber;
      case UserRole.admin:
        return AppColors.adminPurple;
      case UserRole.superAdmin:
        return AppColors.superAdminRed;
    }
  }

  String _roleName(UserRole role) {
    switch (role) {
      case UserRole.tourist:
        return 'Tourist';
      case UserRole.guide:
        return 'Tour Guide';
      case UserRole.merchant:
        return 'Merchant / MSME';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  String _roleDesc(UserRole role) {
    switch (role) {
      case UserRole.tourist:
        return 'Browse, book, explore Mindanao';
      case UserRole.guide:
        return 'Manage tours, bookings, earnings';
      case UserRole.merchant:
        return 'Manage products, orders, sales';
      case UserRole.admin:
        return 'Verify guides, manage reports';
      case UserRole.superAdmin:
        return 'Full platform control & analytics';
    }
  }
}

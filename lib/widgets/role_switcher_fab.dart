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
      backgroundColor: AppColors.textPrimary.withValues(alpha: 0.85),
      onPressed: () => _showRoleSwitcher(context),
      child: const Icon(Icons.swap_horiz, size: 20, color: Colors.white),
    );
  }

  void _showRoleSwitcher(BuildContext context) {
    final roleProvider = context.read<RoleProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
            Text('Switch Role — Dev Mode', style: AppTheme.headline(size: 18)),
            const SizedBox(height: 4),
            Text('Testing tool for role switching', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isActive ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(_roleEmoji(role), style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_roleName(role), style: AppTheme.label(size: 15)),
                              Text(_roleDesc(role), style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (isActive)
                          const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
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
    );
  }

  String _roleEmoji(UserRole role) {
    switch (role) {
      case UserRole.tourist: return 'TR';
      case UserRole.guide: return 'GD';
      case UserRole.merchant: return 'MC';
      case UserRole.admin: return 'AD';
      case UserRole.superAdmin: return 'SA';
    }
  }

  String _roleName(UserRole role) {
    switch (role) {
      case UserRole.tourist: return 'Tourist';
      case UserRole.guide: return 'Tour Guide';
      case UserRole.merchant: return 'Merchant / MSME';
      case UserRole.admin: return 'Admin';
      case UserRole.superAdmin: return 'Super Admin';
    }
  }

  String _roleDesc(UserRole role) {
    switch (role) {
      case UserRole.tourist: return 'Browse, book, explore Mindanao';
      case UserRole.guide: return 'Manage tours, bookings, earnings';
      case UserRole.merchant: return 'Manage products, orders, sales';
      case UserRole.admin: return 'Verify guides, manage reports';
      case UserRole.superAdmin: return 'Full platform control & analytics';
    }
  }
}

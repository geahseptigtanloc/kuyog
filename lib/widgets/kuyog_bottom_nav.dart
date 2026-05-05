import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../providers/role_provider.dart';

class KuyogBottomNav extends StatelessWidget {
  final int currentIndex;
  final UserRole role;
  final ValueChanged<int> onTap;

  const KuyogBottomNav({
    super.key,
    required this.currentIndex,
    required this.role,
    required this.onTap,
  });

  List<_NavItem> _getItems() {
    switch (role) {
      case UserRole.tourist:
        return const [
          _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
          _NavItem(Icons.luggage_outlined, Icons.luggage_rounded, 'Trips'),
          _NavItem(Icons.auto_stories_outlined, Icons.auto_stories_rounded, 'StoryHub'),
          _NavItem(Icons.emoji_events_outlined, Icons.emoji_events, 'Crawl'),
          _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.guide:
        return const [
          _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
          _NavItem(Icons.people_alt_outlined, Icons.people_alt_rounded, 'Clients'),
          _NavItem(Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
          _NavItem(Icons.travel_explore_outlined, Icons.travel_explore, 'Travel'),
          _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.merchant:
        return const [
          _NavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
          _NavItem(Icons.storefront_outlined, Icons.storefront_rounded, 'Market'),
          _NavItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Orders'),
          _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
        ];
      case UserRole.admin:
        return const [
          _NavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
          _NavItem(Icons.verified_user_outlined, Icons.verified_user_rounded, 'Verify'),
          _NavItem(Icons.report_outlined, Icons.report_rounded, 'Reports'),
          _NavItem(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
        ];
      case UserRole.superAdmin:
        return const [
          _NavItem(Icons.analytics_outlined, Icons.analytics_rounded, 'Overview'),
          _NavItem(Icons.people_outline_rounded, Icons.people_rounded, 'Users'),
          _NavItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Analytics'),
          _NavItem(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 2),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Active dot indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: isActive ? 20 : 0,
                          height: 3,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Icon with animated switch
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            key: ValueKey('${item.label}_$isActive'),
                            size: 22,
                            color: isActive ? AppColors.primary : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                            color: isActive ? AppColors.primary : AppColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}

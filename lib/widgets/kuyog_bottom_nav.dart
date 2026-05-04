import 'package:flutter/material.dart';
import 'dart:ui';
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

  List<BottomNavigationBarItem> _getItems() {
    switch (role) {
      case UserRole.tourist:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'StoryHub'),
          BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: 'Travel'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ];
      case UserRole.guide:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: 'Travel'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ];
      case UserRole.merchant:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'Marketplace'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ];
      case UserRole.admin:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user_rounded), label: 'Verify'),
          BottomNavigationBarItem(icon: Icon(Icons.report_rounded), label: 'Reports'),
        ];
      case UserRole.superAdmin:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Analytics'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        boxShadow: AppShadows.bottomNav,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              items: _getItems(),
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textLight,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedFontSize: 12,
              unselectedFontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/role_provider.dart';
import '../widgets/kuyog_bottom_nav.dart';
import '../widgets/role_switcher_fab.dart';
import '../widgets/offline_banner.dart';
import '../providers/navigation_provider.dart';

import 'tourist/tourist_home_tab.dart';
import 'tourist/explore_tab.dart';
import 'shared/storyhub_tab.dart';
import 'shared/chat/chat_list_screen.dart';
import 'tourist/tourist_profile_tab.dart';
import 'guide/guide_home_tab.dart';
import 'guide/clients_tab.dart';
import 'guide/match_requests_screen.dart';
import 'guide/guide_profile_tab.dart';
import 'shared/travel/travel_hub_screen.dart';
import 'merchant/merchant_dashboard_tab.dart';
import 'merchant/merchant_listings_tab.dart';
import 'merchant/merchant_orders_tab.dart';
import 'merchant/merchant_profile_tab.dart';
import 'admin/admin_dashboard_tab.dart';
import 'admin/admin_verifications_tab.dart';
import 'admin/admin_reports_tab.dart';
import 'admin/admin_settings_tab.dart';
import 'super_admin/super_admin_overview_tab.dart';
import 'super_admin/super_admin_users_tab.dart';
import 'super_admin/super_admin_analytics_tab.dart';
import 'super_admin/super_admin_settings_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {

  List<Widget> _getTabs(UserRole role) {
    switch (role) {
      case UserRole.tourist:
        return const [TouristHomeTab(), ExploreTab(), StoryhubTab(), TravelHubScreen(), TouristProfileTab()];
      case UserRole.guide:
        return const [GuideHomeTab(), ClientsTab(), ExploreTab(), TravelHubScreen(), GuideProfileTab()];
      case UserRole.merchant:
        return const [MerchantDashboardTab(), MerchantListingsTab(), MerchantOrdersTab(), MerchantProfileTab()];
      case UserRole.admin:
        return const [AdminDashboardTab(), AdminVerificationsTab(), AdminReportsTab(), AdminSettingsTab()];
      case UserRole.superAdmin:
        return const [SuperAdminOverviewTab(), SuperAdminUsersTab(), SuperAdminAnalyticsTab(), SuperAdminSettingsTab()];
    }
  }

  bool _isStoryHubTab(UserRole role, int index) {
    return role == UserRole.tourist && index == 2;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoleProvider, NavigationProvider>(
      builder: (context, roleProvider, navProvider, _) {
        final tabs = _getTabs(roleProvider.currentRole);
        final currentIndex = navProvider.selectedIndex;
        final safeIndex = currentIndex.clamp(0, tabs.length - 1);
        
        if (safeIndex != currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navProvider.setIndex(safeIndex);
          });
        }

        return Scaffold(
          body: Column(
            children: [
              const OfflineBanner(),
              Expanded(
                child: IndexedStack(
                  index: safeIndex,
                  children: tabs,
                ),
              ),
            ],
          ),
          bottomNavigationBar: KuyogBottomNav(
            currentIndex: safeIndex,
            role: roleProvider.currentRole,
            onTap: (i) => navProvider.setIndex(i),
          ),
          floatingActionButton: _buildFabs(roleProvider.currentRole, safeIndex),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        );
      },
    );
  }

  Widget? _buildFabs(UserRole role, int index) {
    if (_isStoryHubTab(role, index)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'create_post',
            backgroundColor: AppColors.accent,
            onPressed: () => _showCreatePostSheet(context),
            child: const Icon(Icons.edit, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const RoleSwitcherFab(),
        ],
      );
    }
    return const RoleSwitcherFab();
  }

  void _showCreatePostSheet(BuildContext context) {
    final postCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Share your Mindanao story', style: AppTheme.headline(size: 18))),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(radius: 22, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Maria Santos', style: AppTheme.label(size: 14)),
                      Text('Tourist', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                    ]),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: postCtrl,
                  maxLines: 6,
                  style: AppTheme.body(size: 16),
                  decoration: InputDecoration(
                    hintText: "What's your Mindanao story?",
                    hintStyle: AppTheme.body(size: 16, color: AppColors.textLight),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _photoSlot(Icons.add_a_photo, 'Add'),
                      _photoSlot(Icons.image, ''),
                      _photoSlot(Icons.image, ''),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  children: [
                    _toolbarBtn(Icons.photo_camera, 'Photo'),
                    const SizedBox(width: 12),
                    _toolbarBtn(Icons.location_on, 'Location'),
                    const SizedBox(width: 12),
                    _toolbarBtn(Icons.tag, 'Hashtag'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (postCtrl.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Post shared to StoryHub!', style: AppTheme.body(size: 14, color: Colors.white)),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      ),
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoSlot(IconData icon, String label) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider, style: BorderStyle.solid, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          if (label.isNotEmpty) Text(label, style: AppTheme.body(size: 10, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _toolbarBtn(IconData icon, String label) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label, style: AppTheme.label(size: 12, color: AppColors.primary)),
        ]),
      ),
    );
  }
}

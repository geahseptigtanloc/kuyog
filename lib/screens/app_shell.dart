import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../widgets/kuyog_bottom_nav.dart';
import '../widgets/role_switcher_fab.dart';
import '../widgets/sos_button.dart';
import 'tourist/tourist_home_tab.dart';
import 'tourist/explore_tab.dart';
import 'shared/storyhub_tab.dart';
import 'shared/itinerary/itinerary_hub_screen.dart';
import 'tourist/tourist_profile_tab.dart';
import 'guide/guide_home_tab.dart';
import 'guide/clients_tab.dart';
import 'guide/guide_profile_tab.dart';
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
  int _currentIndex = 0;

  List<Widget> _getTabs(UserRole role) {
    switch (role) {
      case UserRole.tourist:
        return const [TouristHomeTab(), ExploreTab(), StoryhubTab(), ItineraryHubScreen(), TouristProfileTab()];
      case UserRole.guide:
        return const [GuideHomeTab(), ClientsTab(), ExploreTab(), ItineraryHubScreen(), GuideProfileTab()];
      case UserRole.merchant:
        return const [MerchantDashboardTab(), MerchantListingsTab(), MerchantOrdersTab(), MerchantProfileTab()];
      case UserRole.admin:
        return const [AdminDashboardTab(), AdminVerificationsTab(), AdminReportsTab(), AdminSettingsTab()];
      case UserRole.superAdmin:
        return const [SuperAdminOverviewTab(), SuperAdminUsersTab(), SuperAdminAnalyticsTab(), SuperAdminSettingsTab()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleProvider>(
      builder: (context, roleProvider, _) {
        final tabs = _getTabs(roleProvider.currentRole);
        final safeIndex = _currentIndex.clamp(0, tabs.length - 1);
        if (safeIndex != _currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _currentIndex = safeIndex);
          });
        }

        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: tabs,
          ),
          bottomNavigationBar: KuyogBottomNav(
            currentIndex: safeIndex,
            role: roleProvider.currentRole,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (roleProvider.currentRole == UserRole.tourist) const SosButton(),
              const SizedBox(height: 8),
              const RoleSwitcherFab(),
            ],
          ),
        );
      },
    );
  }
}

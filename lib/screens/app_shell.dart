import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/role_provider.dart';
import '../widgets/kuyog_bottom_nav.dart';
import '../widgets/role_switcher_fab.dart';
import '../widgets/offline_banner.dart';
import '../providers/navigation_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/services/story_service.dart';
import '../providers/story_provider.dart';
import '../widgets/core/kuyog_button.dart';

import 'tourist/tourist_home_tab.dart';
import 'tourist/explore_tab.dart';
import 'shared/my_trips_screen.dart';
import 'shared/storyhub_tab.dart';
import 'tourist/tourist_profile_tab.dart';
import 'guide/guide_home_tab.dart';
import 'guide/clients_tab.dart';
import 'guide/guide_profile_tab.dart';
import 'features/crawl/crawl_home_screen.dart';
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
        return const [
          TouristHomeTab(),
          MyTripsScreen(),
          StoryhubTab(),
          CrawlHomeScreen(),
          TouristProfileTab()
        ];
      case UserRole.guide:
        return const [
          GuideHomeTab(),
          ClientsTab(),
          ExploreTab(),
          TravelHubScreen(),
          GuideProfileTab()
        ];
      case UserRole.merchant:
        return [
          const MerchantDashboardTab(),
          const MerchantListingsTab(),
          const MerchantOrdersTab(),
          const MerchantProfileTab()
        ];
      case UserRole.admin:
        return [
          const AdminDashboardTab(),
          const AdminVerificationsTab(),
          const AdminReportsTab(),
          const AdminSettingsTab(),
        ];
      case UserRole.superAdmin:
        return [
          const SuperAdminOverviewTab(),
          const SuperAdminUsersTab(),
          const SuperAdminAnalyticsTab(),
          const SuperAdminSettingsTab(),
        ];
    }
  }

  bool _isStoryHubTab(UserRole role, int index) {
    return role == UserRole.tourist && index == 2;
  }

  bool _isProfileTab(UserRole role, int index) {
    switch (role) {
      case UserRole.tourist: return index == 4;
      case UserRole.guide: return index == 4;
      case UserRole.merchant: return index == 3;
      case UserRole.admin: return index == 3;
      case UserRole.superAdmin: return index == 3;
      default: return false;
    }
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
          key: ValueKey(roleProvider.currentRole),
          body: Stack(
            children: [
              Column(
                children: [
                  const OfflineBanner(),
                  if (roleProvider.needsVerificationBanner)
                    const VerificationBanner(),
                  Expanded(
                    child: IndexedStack(
                      index: safeIndex,
                      children: tabs,
                    ),
                  ),
                ],
              ),
              // FABs positioned absolutely
              ..._buildPositionedFabs(roleProvider.currentRole, safeIndex),
            ],
          ),
          bottomNavigationBar: KuyogBottomNav(
            currentIndex: safeIndex,
            role: roleProvider.currentRole,
            onTap: (i) => navProvider.setIndex(i),
          ),
          floatingActionButton: null,
        );
      },
    );
  }

  List<Widget> _buildPositionedFabs(UserRole role, int index) {
    final isStoryHub = _isStoryHubTab(role, index);
    final isProfile = _isProfileTab(role, index);
    
    return [
      // Role Switcher FAB - Bottom Left
      if (isProfile)
        Positioned(
          bottom: 80,
          left: 16,
          child: const RoleSwitcherFab(),
        ),
      // Create Post FAB - Bottom Right (StoryHub only)
      if (isStoryHub)
        Positioned(
          bottom: 80,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'create_post',
            backgroundColor: AppColors.accent,
            onPressed: () => _showCreatePostSheet(context),
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.edit_outlined, size: 22, color: Colors.white),
          ),
        ),
    ];
  }



  void _showCreatePostSheet(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final postCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final hashtagCtrl = TextEditingController();
    final hashtagFocusNode = FocusNode();
    List<XFile> pickedImages = [];
    bool isPosting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text('Share your Mindanao story',
                              style: AppTheme.headline(size: 18))),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: const BoxDecoration(
                              color: AppColors.background, shape: BoxShape.circle),
                          child: const Icon(Icons.close,
                              size: 20, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage:
                            roleProvider.currentUser?.avatarUrl.isNotEmpty == true
                                ? NetworkImage(roleProvider.currentUser!.avatarUrl)
                                : null,
                        child: roleProvider.currentUser?.avatarUrl.isEmpty == true
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(roleProvider.userName, style: AppTheme.label(size: 14)),
                        Text(roleProvider.roleDisplayName,
                            style: AppTheme.body(
                                size: 12, color: AppColors.textSecondary)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: postCtrl,
                    maxLines: 6,
                    style: AppTheme.body(size: 16),
                    decoration: InputDecoration(
                      hintText: "What's your Mindanao story?",
                      hintStyle:
                          AppTheme.body(size: 16, color: AppColors.textLight),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (pickedImages.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pickedImages.length,
                        itemBuilder: (context, i) => Stack(children: [
                          Container(
                            width: 90,
                            height: 90,
                            margin: const EdgeInsets.only(right: AppSpacing.md),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              image: DecorationImage(
                                image: kIsWeb
                                    ? NetworkImage(pickedImages[i].path)
                                    : FileImage(File(pickedImages[i].path))
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => setModalState(
                                  () => pickedImages.removeAt(i)),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.xs),
                                decoration: const BoxDecoration(
                                    color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: locationCtrl,
                    style: AppTheme.body(size: 14),
                    decoration: InputDecoration(
                      hintText: 'Add location (optional)',
                      prefixIcon: const Icon(Icons.location_on_outlined,
                          size: 20, color: AppColors.primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: hashtagCtrl,
                    focusNode: hashtagFocusNode,
                    style: AppTheme.body(size: 14),
                    decoration: InputDecoration(
                      hintText: 'Add hashtags (e.g. #mindanao #travel)',
                      prefixIcon: const Icon(Icons.tag,
                          size: 20, color: AppColors.primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _toolbarBtn(Icons.photo_camera, 'Photo', onTap: () async {
                        final picker = ImagePicker();
                        final image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setModalState(() => pickedImages.add(image));
                        }
                      }),
                      const SizedBox(width: AppSpacing.md),
                      _toolbarBtn(Icons.tag, 'Hashtag',
                          onTap: () => hashtagFocusNode.requestFocus()),
                      const Spacer(),
                      KuyogButton(
                        label: 'Post',
                        variant: KuyogButtonVariant.secondary,
                        isLoading: isPosting,
                        onPressed: () async {
                          if (postCtrl.text.isEmpty) return;

                          setModalState(() => isPosting = true);
                          try {
                            final storyService = StoryService();
                            final List<String> imageUrls = [];

                            for (var xFile in pickedImages) {
                              final bytes = await xFile.readAsBytes();
                              final url = await storyService.uploadPostPhoto(
                                  xFile.path, bytes);
                              imageUrls.add(url);
                            }

                            // Extract hashtags from content (e.g. #test)
                            final contentTags = RegExp(r'#(\w+)')
                                .allMatches(postCtrl.text)
                                .map((m) => m.group(0)!)
                                .toList();

                            // Extract from dedicated field
                            final rawTags = hashtagCtrl.text
                                .split(RegExp(r'[\s,]+'))
                                .where((t) => t.isNotEmpty)
                                .toList();
                            final List<String> fieldTags = rawTags
                                .map((t) => t.startsWith('#') ? t : '#$t')
                                .toList();

                            // Merge and remove duplicates
                            final allTags = <String>{...contentTags, ...fieldTags}
                                .toList();

                            await ctx.read<StoryProvider>().addPost(
                                  postCtrl.text,
                                  images: imageUrls,
                                  hashtags: allTags,
                                  location: locationCtrl.text.isNotEmpty
                                      ? locationCtrl.text
                                      : null,
                                );

                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Post shared to StoryHub!',
                                      style: AppTheme.body(
                                          size: 14, color: Colors.white)),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Error: $e')));
                              setModalState(() => isPosting = false);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _toolbarBtn(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: AppTheme.label(size: 12, color: AppColors.primary)),
        ]),
      ),
    );
  }
}

class VerificationBanner extends StatelessWidget {
  const VerificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        Provider.of<RoleProvider>(context).currentUser?.verificationStatus ??
            'pending';

    Color bgColor;
    IconData icon;
    String text;

    switch (status) {
      case 'submitted':
        bgColor = AppColors.touristBlue.withAlpha(242);
        icon = Icons.hourglass_empty;
        text = 'Your documents are currently under review by our team.';
        break;
      case 'draft':
        bgColor = AppColors.accent.withAlpha(242);
        icon = Icons.upload_file;
        text =
            'Resume your verification. Please finish uploading your documents.';
        break;
      case 'rejected':
        bgColor = AppColors.error.withAlpha(242);
        icon = Icons.error_outline;
        text =
            'Your verification was rejected. Please review and update your documents.';
        break;
      case 'pending':
      default:
        bgColor = AppColors.warning.withAlpha(242);
        icon = Icons.info_outline;
        text = 'Your account is incomplete. Please submit verification documents.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(color: bgColor),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTheme.body(
                color: Colors.white,
                size: 12,
                weight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.chevron_right,
              color: Colors.white.withAlpha(179), size: 18),
        ],
      ),
    );
  }
}


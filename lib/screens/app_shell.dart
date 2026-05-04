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
        return [const MerchantDashboardTab(), const MerchantListingsTab(), const MerchantOrdersTab(), const MerchantProfileTab()];
      case UserRole.admin:
        return [const AdminDashboardTab(), const AdminVerificationsTab(), const AdminReportsTab()];
      case UserRole.superAdmin:
        return [const SuperAdminOverviewTab(), const SuperAdminUsersTab(), const SuperAdminAnalyticsTab()];
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
          key: ValueKey(roleProvider.currentRole),
          body: Column(
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
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
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
                            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22, 
                          backgroundColor: AppColors.primaryLight,
                          backgroundImage: roleProvider.currentUser?.avatarUrl.isNotEmpty == true 
                              ? NetworkImage(roleProvider.currentUser!.avatarUrl) 
                              : null,
                          child: roleProvider.currentUser?.avatarUrl.isEmpty == true 
                              ? const Icon(Icons.person, color: Colors.white) 
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(roleProvider.userName, style: AppTheme.label(size: 14)),
                          Text(roleProvider.roleDisplayName, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
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
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                image: DecorationImage(
                                  image: kIsWeb 
                                      ? NetworkImage(pickedImages[i].path) 
                                      : FileImage(File(pickedImages[i].path)) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4, right: 16,
                              child: GestureDetector(
                                onTap: () => setModalState(() => pickedImages.removeAt(i)),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: locationCtrl,
                      style: AppTheme.body(size: 14),
                      decoration: InputDecoration(
                        hintText: 'Add location (optional)',
                        prefixIcon: const Icon(Icons.location_on_outlined, size: 20, color: AppColors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: hashtagCtrl,
                      focusNode: hashtagFocusNode,
                      style: AppTheme.body(size: 14),
                      decoration: InputDecoration(
                        hintText: 'Add hashtags (e.g. #mindanao #travel)',
                        prefixIcon: const Icon(Icons.tag, size: 20, color: AppColors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    Row(
                      children: [
                        _toolbarBtn(Icons.photo_camera, 'Photo', onTap: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setModalState(() => pickedImages.add(image));
                          }
                        }),
                        const SizedBox(width: 12),
                        _toolbarBtn(Icons.tag, 'Hashtag', onTap: () => hashtagFocusNode.requestFocus()),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: isPosting ? null : () async {
                            if (postCtrl.text.isEmpty) return;
                            
                            setModalState(() => isPosting = true);
                            try {
                              final storyService = StoryService();
                              final List<String> imageUrls = [];
                              
                              for (var xFile in pickedImages) {
                                final bytes = await xFile.readAsBytes();
                                final url = await storyService.uploadPostPhoto(xFile.path, bytes);
                                imageUrls.add(url);
                              }
                              
                              // Extract hashtags from content (e.g. #test)
                              final contentTags = RegExp(r'#(\w+)').allMatches(postCtrl.text).map((m) => m.group(0)!).toList();
                              
                              // Extract from dedicated field
                              final rawTags = hashtagCtrl.text.split(RegExp(r'[\s,]+')).where((t) => t.isNotEmpty).toList();
                              final List<String> fieldTags = rawTags.map((t) => t.startsWith('#') ? t : '#$t').toList();

                              // Merge and remove duplicates
                              final allTags = <String>{...contentTags, ...fieldTags}.toList();

                              await ctx.read<StoryProvider>().addPost(
                                postCtrl.text,
                                images: imageUrls,
                                hashtags: allTags,
                                location: locationCtrl.text.isNotEmpty ? locationCtrl.text : null,
                              );

                              if (ctx.mounted) {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Post shared to StoryHub!', style: AppTheme.body(size: 14, color: Colors.white)),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                setModalState(() => isPosting = false);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                          ),
                          child: isPosting 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Post'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _toolbarBtn(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
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

class VerificationBanner extends StatelessWidget {
  const VerificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final status = Provider.of<RoleProvider>(context).currentUser?.verificationStatus ?? 'pending';

    Color bgColor;
    IconData icon;
    String text;

    switch (status) {
      case 'submitted':
        bgColor = AppColors.touristBlue.withOpacity(0.95);
        icon = Icons.hourglass_empty;
        text = 'Your documents are currently under review by our team.';
        break;
      case 'draft':
        bgColor = AppColors.accent.withOpacity(0.95);
        icon = Icons.upload_file;
        text = 'Resume your verification. Please finish uploading your documents.';
        break;
      case 'rejected':
        bgColor = AppColors.error.withOpacity(0.95);
        icon = Icons.error_outline;
        text = 'Your verification was rejected. Please review and update your documents.';
        break;
      case 'pending':
      default:
        bgColor = AppColors.warning.withOpacity(0.95);
        icon = Icons.info_outline;
        text = 'Your account is incomplete. Please submit verification documents.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: bgColor),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7), size: 18),
        ],
      ),
    );
  }
}

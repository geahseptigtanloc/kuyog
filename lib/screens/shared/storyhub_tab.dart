import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../models/post.dart';
import '../../providers/story_provider.dart';
import '../../widgets/kuyog_app_bar.dart';
import '../../widgets/core/kuyog_card.dart';
import '../../widgets/core/kuyog_badge.dart';
import '../../widgets/core/kuyog_empty_state.dart';
import '../../widgets/core/kuyog_section_header.dart';
import 'story_detail_screen.dart';

class StoryhubTab extends StatefulWidget {
  final String? tagFilter;
  const StoryhubTab({super.key, this.tagFilter});
  @override
  State<StoryhubTab> createState() => _StoryhubTabState();
}

class _StoryhubTabState extends State<StoryhubTab> {
  int _selectedTab = 0;
  final _tabs = ['Top', 'Hot', 'New'];
  String? _activeTag;

  @override
  void initState() {
    super.initState();
    _activeTag = widget.tagFilter;
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final posts = _activeTag != null
        ? storyProvider.posts
            .where((p) => p.hashtags.contains(_activeTag))
            .toList()
        : storyProvider.posts;
    final loading = storyProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'StoryHub'),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (_activeTag != null)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
            child: KuyogCard(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              radius: AppRadius.lg,
              child: Row(
                children: [
                  const Icon(Icons.tag, size: 16, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('Showing: $_activeTag Stories',
                        style: AppTheme.body(
                            size: 13, color: AppColors.textPrimary)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        size: 16, color: AppColors.textSecondary),
                    onPressed: () => setState(() => _activeTag = null),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        // Pill Tabs
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: 12),
          child: Row(
            children: List.generate(
              _tabs.length,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i != _tabs.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == i
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _selectedTab == i ? AppColors.primary : AppColors.divider,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[i],
                          style: AppTheme.body(
                            size: 14,
                            weight: FontWeight.w600,
                            color: _selectedTab == i
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: const KuyogSectionHeader(
            title: 'Latest Stories',
            subtitle: 'Discover featured travel moments from the community',
            padding: EdgeInsets.zero,
          ),
        ),
        if (_availableTags(posts).isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
                children: _availableTags(posts)
                    .take(10)
                    .map((tag) => GestureDetector(
                          onTap: () => setState(() => _activeTag = tag),
                          child: KuyogBadge(
                            label: tag,
                            color: AppColors.primary,
                            labelColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                        ))
                    .toList(),
            ),
          ),
        Expanded(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : RefreshIndicator(
                  onRefresh: () => storyProvider.refreshPosts(),
                  color: AppColors.primary,
                  child: _buildFeed(_getFilteredPosts(posts)),
                ),
        ),
      ]),
    );
  }

  List<Post> _getFilteredPosts(List<Post> posts) {
    List<Post> filtered = List.from(posts);
    switch (_selectedTab) {
      case 1: // HOT (most comments)
        return filtered..sort((a, b) => b.comments.compareTo(a.comments));
      case 2: // NEW
        return filtered..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      default: // TOP (upvotes)
        return filtered..sort((a, b) => b.upvotes.compareTo(a.upvotes));
    }
  }

  Widget _buildFeed(List<Post> posts) {
    if (posts.isEmpty) {
      return KuyogEmptyState(
        icon: Icons.auto_stories,
        title: 'No stories found',
        message: 'Try refreshing or choose a different tag to explore more stories.',
        actionLabel: 'Refresh',
        onAction: () => context.read<StoryProvider>().refreshPosts(),
      );
    }
    return ListView.builder(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.xs, AppSpacing.xl, 100),
      itemCount: posts.length,
      itemBuilder: (context, i) => _postCard(posts[i]),
    );
  }

  Widget _postCard(Post post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: KuyogCard(
        radius: AppRadius.lg,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StoryDetailScreen(post: post))),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(post.userAvatar)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(post.userName,
                          style: AppTheme.body(
                              size: 15,
                              weight: FontWeight.w600,
                              color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildRoleChip(post.userRole),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(post.location,
                          style: AppTheme.body(
                              size: 12, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(post.timeAgo,
                        style: AppTheme.body(
                            size: 12, color: AppColors.textLight)),
                  ]),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz,
                  color: AppColors.textSecondary, size: 20),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ]),
          if (post.hashtags.contains('#MindanaoCrawl'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: const KuyogBadge(
                label: 'Crawl Story',
                color: AppColors.primary,
                icon: Icons.verified,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(post.content,
              style: AppTheme.body(
                  size: 14, color: AppColors.textPrimary, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          if (post.content.length > 120)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text('Read more',
                  style: AppTheme.body(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
          if (post.hashtags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: post.hashtags.map((h) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary, width: 1.2),
                      ),
                      child: Text(h,
                          style: AppTheme.body(
                              size: 12,
                              weight: FontWeight.w600,
                              color: AppColors.primary)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          if (post.images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _buildImageGrid(post.images),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(children: [
            _engagementItem(
              icon: post.isUpvoted
                  ? Icons.arrow_upward
                  : Icons.arrow_upward_outlined,
              label: '${post.upvotes}',
              active: post.isUpvoted,
              onTap: () => context.read<StoryProvider>().upvotePost(post.id),
            ),
            const SizedBox(width: AppSpacing.xl),
            _engagementItem(
              icon: Icons.chat_bubble_outline,
              label: '${post.comments}',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StoryDetailScreen(post: post))),
            ),
            const Spacer(),
            InkWell(
              onTap: () =>
                  context.read<StoryProvider>().toggleBookmark(post.id),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Icon(
                  post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 20,
                  color: post.isBookmarked
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: const Icon(Icons.share_outlined,
                    size: 20, color: AppColors.textSecondary),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    final isGuide = role.toLowerCase() == 'guide';
    final chipColor = isGuide ? const Color(0xFF1E3A5F) : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(_formatRole(role),
          style: AppTheme.body(
              size: 11, weight: FontWeight.w600, color: Colors.white)),
    );
  }

  Widget _engagementItem(
      {required IconData icon,
      required String label,
      bool active = false,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon,
              size: 18,
              color: active ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: AppTheme.body(
                  size: 13,
                  weight: FontWeight.w600,
                  color: active ? AppColors.primary : AppColors.textSecondary)),
        ]),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: images[0],
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (c, u) => Container(height: 200, color: AppColors.divider),
          errorWidget: (c, u, e) => Container(
              height: 200,
              color: AppColors.primary.withAlpha(13),
              child: const Icon(Icons.image, size: 40, color: AppColors.primary)),
        ),
      );
    }

    if (images.length == 2) {
      return SizedBox(
        height: 160,
        child: Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: images[0],
                height: 160,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider),
                errorWidget: (c, u, e) =>
                    Container(color: AppColors.primary.withAlpha(13)),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: images[1],
                height: 160,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider),
                errorWidget: (c, u, e) =>
                    Container(color: AppColors.primary.withAlpha(13)),
              ),
            ),
          ),
        ]),
      );
    }

    final displayImages = images.length > 3 ? images.sublist(0, 3) : images;
    return SizedBox(
      height: 160,
      child: Row(children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: displayImages[0],
              height: 160,
              fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.divider),
              errorWidget: (c, u, e) => Container(color: AppColors.primary.withAlpha(13)),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 1,
          child: Column(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: displayImages[1],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppColors.divider),
                  errorWidget: (c, u, e) =>
                      Container(color: AppColors.primary.withAlpha(13)),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8)),
                child: Stack(children: [
                  CachedNetworkImage(
                    imageUrl: displayImages[2],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.divider),
                    errorWidget: (c, u, e) =>
                        Container(color: AppColors.primary.withAlpha(13)),
                  ),
                  if (images.length > 3)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(128),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text('+${images.length - 3}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Color _roleChipColor(String role) {
    final r = role.toLowerCase();
    if (r == 'guide') return AppColors.guideGreen;
    if (r == 'merchant') return AppColors.merchantAmber;
    return AppColors.touristBlue;
  }

  List<String> _availableTags(List<Post> posts) {
    final tags = <String>{};
    for (final post in posts) {
      tags.addAll(post.hashtags);
    }
    return tags.toList();
  }

  String _formatRole(String role) {
    final r = role.toLowerCase().trim();
    if (r == 'guide') return 'Guide';
    if (r == 'merchant') return 'Merchant';
    if (r == 'admin') return 'Admin';
    if (r == 'super_admin' || r == 'superadmin') return 'Super Admin';
    return 'Tourist';
  }
}


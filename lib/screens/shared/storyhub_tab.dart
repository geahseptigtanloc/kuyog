import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../models/post.dart';
import '../../providers/story_provider.dart';
import '../../widgets/kuyog_app_bar.dart';
import 'story_detail_screen.dart';

class StoryhubTab extends StatefulWidget {
  const StoryhubTab({super.key});
  @override
  State<StoryhubTab> createState() => _StoryhubTabState();
}

class _StoryhubTabState extends State<StoryhubTab> {
  int _selectedTab = 0;
  final _tabs = ['TOP', 'HOT', 'NEW'];

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final posts = storyProvider.posts;
    final loading = storyProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KuyogAppBar(title: 'StoryHub'),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Pill Tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_tabs.length, (i) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedTab == i ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: _selectedTab == i ? AppColors.primary : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        _tabs[i],
                        style: AppTheme.label(size: 13, color: _selectedTab == i ? Colors.white : AppColors.textSecondary),
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
          // Feed
          Expanded(
            child: loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _buildFeed(_getFilteredPosts(posts)),
          ),
        ]),
    );
  }

  List<Post> _getFilteredPosts(List<Post> posts) {
    switch (_selectedTab) {
      case 1: return posts.reversed.toList();
      case 2: return posts;
      default: return posts..sort((a, b) => b.upvotes.compareTo(a.upvotes));
    }
  }

  Widget _buildFeed(List<Post> posts) {
    if (posts.isEmpty) return const Center(child: Text('No posts yet'));
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: posts.length,
      itemBuilder: (context, i) => _postCard(posts[i]),
    );
  }

  Widget _postCard(Post post) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryDetailScreen(post: post))),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header row
          Row(children: [
            CircleAvatar(radius: 20, backgroundImage: CachedNetworkImageProvider(post.userAvatar)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(post.userName, style: AppTheme.label(size: 14)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: _roleChipColor(post.userRole).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(post.userRole, style: AppTheme.label(size: 9, color: _roleChipColor(post.userRole))),
                ),
              ]),
              Row(children: [
                const Icon(Icons.location_on, size: 11, color: AppColors.textLight),
                const SizedBox(width: 2),
                Expanded(child: Text('${post.location} · ${post.timeAgo}',
                  style: AppTheme.body(size: 11, color: AppColors.textLight), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ])),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.more_horiz, color: AppColors.textLight, size: 20)),
            ),
          ]),
          const SizedBox(height: 12),
          // Post text
          Text(post.content, style: AppTheme.body(size: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
          if (post.content.length > 120)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Read more', style: AppTheme.label(size: 13, color: AppColors.primary)),
            ),
          // Hashtags
          if (post.hashtags.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 26,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: post.hashtags.map((h) => Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Text(h, style: AppTheme.body(size: 11, color: AppColors.primary)),
                )).toList(),
              ),
            ),
          ],
          // Images
          if (post.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildImageGrid(post.images),
          ],
          // Engagement row
          const SizedBox(height: 12),
          Row(children: [
            InkWell(
              onTap: () => context.read<StoryProvider>().upvotePost(post.id),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.arrow_upward, size: 18, color: post.upvotes > 100 ? AppColors.primary : AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${post.upvotes}', style: AppTheme.body(size: 12, color: post.upvotes > 100 ? AppColors.primary : AppColors.textSecondary)),
                ]),
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${post.comments}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                ]),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.read<StoryProvider>().toggleBookmark(post.id),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 20, color: post.isBookmarked ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.share_outlined, size: 20, color: AppColors.textSecondary),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: CachedNetworkImage(
          imageUrl: images[0], height: 240, width: double.infinity, fit: BoxFit.cover,
          placeholder: (c, u) => Container(height: 240, color: AppColors.divider),
          errorWidget: (c, u, e) => Container(height: 240, color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.image, size: 40, color: AppColors.primary)),
        ),
      );
    }
    if (images.length == 2) {
      return SizedBox(
        height: 180,
        child: Row(children: [
          Expanded(child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.md)),
            child: CachedNetworkImage(imageUrl: images[0], height: 180, fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.divider),
              errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
          )),
          const SizedBox(width: 4),
          Expanded(child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(AppRadius.md)),
            child: CachedNetworkImage(imageUrl: images[1], height: 180, fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.divider),
              errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
          )),
        ]),
      );
    }
    // 3+ photos: 1 large top + 2 small bottom
    return Column(children: [
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sm)),
        child: CachedNetworkImage(imageUrl: images[0], height: 140, width: double.infinity, fit: BoxFit.cover,
          placeholder: (c, u) => Container(height: 140, color: AppColors.divider),
          errorWidget: (c, u, e) => Container(height: 140, color: AppColors.primary.withOpacity(0.1))),
      ),
      const SizedBox(height: 4),
      SizedBox(
        height: 80,
        child: Row(children: [
          Expanded(child: ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppRadius.sm)),
            child: CachedNetworkImage(imageUrl: images[1], height: 80, fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.divider),
              errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
          )),
          const SizedBox(width: 4),
          Expanded(child: Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(AppRadius.sm)),
              child: CachedNetworkImage(imageUrl: images.length > 2 ? images[2] : images[1], height: 80, width: double.infinity, fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: AppColors.divider),
                errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
            ),
            if (images.length > 3)
              Positioned.fill(child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: const BorderRadius.only(bottomRight: Radius.circular(AppRadius.sm))),
                child: Center(child: Text('+${images.length - 3}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
              )),
          ])),
        ]),
      ),
    ]);
  }

  Color _roleChipColor(String role) {
    switch (role) {
      case 'Guide': return AppColors.guideGreen;
      case 'Merchant': return AppColors.merchantAmber;
      default: return AppColors.touristBlue;
    }
  }
}

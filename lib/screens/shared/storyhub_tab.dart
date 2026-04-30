import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/post.dart';

class StoryhubTab extends StatefulWidget {
  const StoryhubTab({super.key});
  @override
  State<StoryhubTab> createState() => _StoryhubTabState();
}

class _StoryhubTabState extends State<StoryhubTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Post> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final p = await MockData.getPosts();
    if (mounted) setState(() { _posts = p; _loading = false; });
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              Text('StoryHub', style: AppTheme.headline(size: 24)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showCreatePost(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: AppColors.primary, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.search, color: AppColors.textSecondary),
              const SizedBox(width: 16),
              const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
            ]),
          ),
          const SizedBox(height: 16),
          _buildStoriesRow(),
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textLight,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: AppTheme.label(size: 14),
            tabs: const [Tab(text: 'TOP'), Tab(text: 'HOT'), Tab(text: 'NEW')],
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : TabBarView(
                    controller: _tabController,
                    children: [_buildFeed(_posts), _buildFeed(_posts.reversed.toList()), _buildFeed(_posts)],
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildStoriesRow() {
    final stories = [
      ('Add Story', '', true),
      ('Rico M.', 'https://picsum.photos/seed/rico/100/100', false),
      ('Amina L.', 'https://picsum.photos/seed/amina/100/100', false),
      ('Mt. Apo', 'https://picsum.photos/seed/apo/100/100', false),
      ('Durian', 'https://picsum.photos/seed/durian/100/100', false),
      ('Siargao', 'https://picsum.photos/seed/siargao/100/100', false),
    ];
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: stories.length,
        itemBuilder: (context, i) {
          final s = stories[i];
          final isAdd = s.$3;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(children: [
              Stack(clipBehavior: Clip.none, children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isAdd ? null : const LinearGradient(colors: [AppColors.accent, AppColors.primary]),
                    border: isAdd ? Border.all(color: AppColors.divider, width: 2) : null,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.background,
                    backgroundImage: isAdd ? null : CachedNetworkImageProvider(s.$2),
                    child: isAdd ? const Icon(Icons.person, color: AppColors.textLight) : null,
                  ),
                ),
                if (isAdd)
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.add, size: 14, color: Colors.white),
                    ),
                  ),
              ]),
              const SizedBox(height: 6),
              Text(s.$1, style: AppTheme.label(size: 11)),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildFeed(List<Post> posts) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (c, i) => _postCard(posts[i]),
    );
  }

  Widget _postCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 20, backgroundImage: CachedNetworkImageProvider(post.userAvatar)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(post.userName, style: AppTheme.label(size: 14)),
            Row(children: [
              const Icon(Icons.location_on, size: 12, color: AppColors.textLight),
              const SizedBox(width: 2),
              Text(post.location, style: AppTheme.body(size: 11, color: AppColors.textLight)),
              Text(' · ${post.timeAgo}', style: AppTheme.body(size: 11, color: AppColors.textLight)),
            ]),
          ])),
          const Icon(Icons.more_horiz, color: AppColors.textLight),
        ]),
        const SizedBox(height: 12),
        Text(post.content, style: AppTheme.body(size: 14), maxLines: 4, overflow: TextOverflow.ellipsis),
        if (post.hashtags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(spacing: 6, children: post.hashtags.map((h) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Text(h, style: AppTheme.body(size: 11, color: AppColors.primary)),
          )).toList()),
        ],
        if (post.images.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildImageGrid(post.images),
        ],
        const SizedBox(height: 12),
        Row(children: [
          _actionBtn(Icons.arrow_upward, '${post.upvotes}'),
          const SizedBox(width: 20),
          _actionBtn(Icons.chat_bubble_outline, '${post.comments}'),
          const Spacer(),
          Icon(post.isBookmarked ? Icons.bookmark : Icons.bookmark_border, size: 20, color: post.isBookmarked ? AppColors.primary : AppColors.textLight),
          const SizedBox(width: 16),
          const Icon(Icons.share_outlined, size: 20, color: AppColors.textLight),
        ]),
      ]),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: CachedNetworkImage(imageUrl: images[0], height: 200, width: double.infinity, fit: BoxFit.cover,
          placeholder: (c, u) => Container(height: 200, color: AppColors.divider),
          errorWidget: (c, u, e) => Container(height: 200, color: AppColors.primary.withOpacity(0.1))),
      );
    }
    return SizedBox(
      height: 160,
      child: Row(children: [
        Expanded(child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.md)),
          child: CachedNetworkImage(imageUrl: images[0], height: 160, fit: BoxFit.cover,
            placeholder: (c, u) => Container(color: AppColors.divider),
            errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
        )),
        const SizedBox(width: 4),
        Expanded(child: Column(children: [
          Expanded(child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(AppRadius.md)),
            child: CachedNetworkImage(imageUrl: images.length > 1 ? images[1] : images[0], width: double.infinity, fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppColors.divider),
              errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
          )),
          if (images.length > 2) ...[
            const SizedBox(height: 4),
            Expanded(child: Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(AppRadius.md)),
                child: CachedNetworkImage(imageUrl: images[2], width: double.infinity, fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppColors.divider),
                  errorWidget: (c, u, e) => Container(color: AppColors.primary.withOpacity(0.1))),
              ),
              if (images.length > 3)
                Positioned.fill(child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: const BorderRadius.only(bottomRight: Radius.circular(AppRadius.md))),
                  child: Center(child: Text('+${images.length - 3}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                )),
            ])),
          ],
        ])),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Text(label, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
    ]);
  }

  void _showCreatePost(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Create Post', style: AppTheme.headline(size: 18)),
          const SizedBox(height: 16),
          TextField(maxLines: 4, decoration: InputDecoration(hintText: 'Share your Mindanao experience...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)))),
          const SizedBox(height: 12),
          Row(children: [
            _chipAction(Icons.photo, 'Photo'),
            const SizedBox(width: 8),
            _chipAction(Icons.location_on, 'Location'),
            const SizedBox(width: 8),
            _chipAction(Icons.tag, 'Hashtag'),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Post'))),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _chipAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(label, style: AppTheme.label(size: 12, color: AppColors.primary)),
      ]),
    );
  }
}

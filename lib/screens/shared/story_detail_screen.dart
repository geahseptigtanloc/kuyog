import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../models/post.dart';
import '../../providers/story_provider.dart';

class StoryDetailScreen extends StatefulWidget {
  final Post post;
  const StoryDetailScreen({super.key, required this.post});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() { _commentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // Need to watch the provider to get the updated post stats if upvoted here
    final storyProvider = context.watch<StoryProvider>();
    final currentPost = storyProvider.posts.firstWhere((p) => p.id == widget.post.id, orElse: () => widget.post);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Post from ${currentPost.userName}', style: AppTheme.headline(size: 16)),
      ),
      body: Column(children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(backgroundImage: NetworkImage(currentPost.userAvatar)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(currentPost.userName, style: AppTheme.label(size: 15)),
                      Text('${currentPost.timeAgo} • ${currentPost.location}', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                    ])),
                    const Icon(Icons.more_horiz, color: AppColors.textLight),
                  ]),
                  const SizedBox(height: 16),
                  Text(currentPost.content, style: AppTheme.body(size: 15)),
                  const SizedBox(height: 12),
                  if (currentPost.hashtags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: currentPost.hashtags.map((h) => Text(h, style: AppTheme.body(size: 14, color: AppColors.primary))).toList(),
                    ),
                  const SizedBox(height: 16),
                  if (currentPost.images.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: CachedNetworkImage(imageUrl: currentPost.images.first, width: double.infinity, height: 250, fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 16),
                  Row(children: [
                    GestureDetector(
                      onTap: () => storyProvider.upvotePost(currentPost.id),
                      child: _actionBtn(Icons.arrow_upward, '${currentPost.upvotes}'),
                    ),
                    const SizedBox(width: 20),
                    _actionBtn(Icons.chat_bubble_outline, '${currentPost.comments}'),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => storyProvider.toggleBookmark(currentPost.id),
                      child: Icon(currentPost.isBookmarked ? Icons.bookmark : Icons.bookmark_border, size: 20, color: currentPost.isBookmarked ? AppColors.primary : AppColors.textLight),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.share_outlined, size: 20, color: AppColors.textLight),
                  ]),
                ]),
              ),
              const SizedBox(height: 8),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Comments', style: AppTheme.headline(size: 16)),
                  const SizedBox(height: 16),
                  _commentTile('Anna B.', 'Beautiful shot! Where exactly is this in Davao?', '2h ago'),
                  _commentTile('Rico M.', 'Nice to see you exploring my hometown. Let me know if you need recommendations!', '5h ago'),
                ]),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8, top: 8, left: 16, right: 16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
          child: Row(children: [
            const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://picsum.photos/seed/user/100/100')),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentCtrl,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.pill), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () {
                if (_commentCtrl.text.isNotEmpty) {
                  _commentCtrl.clear();
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comment posted!')));
                }
              },
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(count, style: AppTheme.label(size: 13, color: AppColors.primary)),
      ]),
    );
  }

  Widget _commentTile(String name, String comment, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(radius: 16, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(name[0], style: AppTheme.label(size: 14, color: AppColors.primary))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(name, style: AppTheme.label(size: 14)),
            const SizedBox(width: 8),
            Text(time, style: AppTheme.body(size: 11, color: AppColors.textLight)),
          ]),
          const SizedBox(height: 4),
          Text(comment, style: AppTheme.body(size: 13)),
        ])),
      ]),
    );
  }
}

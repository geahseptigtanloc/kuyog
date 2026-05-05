import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../models/post.dart';
import '../../providers/story_provider.dart';
import '../../providers/role_provider.dart';
import '../../data/services/story_service.dart';

class StoryDetailScreen extends StatefulWidget {
  final Post post;
  const StoryDetailScreen({super.key, required this.post});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final _commentCtrl = TextEditingController();
  final _storyService = StoryService();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoadingComments = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    if (widget.post.id.startsWith('temp_') || widget.post.id.startsWith('p')) {
      setState(() => _isLoadingComments = false);
      return;
    }
    
    try {
      final comments = await _storyService.getComments(widget.post.id);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading comments: $e');
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

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
                      Row(children: [
                        Text(currentPost.userName, style: AppTheme.label(size: 15)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: _roleChipColor(currentPost.userRole).withAlpha(26),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(_formatRole(currentPost.userRole), style: AppTheme.label(size: 10, weight: FontWeight.w800, color: _roleChipColor(currentPost.userRole))),
                        ),
                      ]),
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
                      child: _actionBtn(
                        currentPost.isUpvoted ? Icons.arrow_upward : Icons.arrow_upward_outlined, 
                        '${currentPost.upvotes}',
                        active: currentPost.isUpvoted
                      ),
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
                  if (_isLoadingComments)
                    const Center(child: CircularProgressIndicator())
                  else if (_comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('No comments yet. Be the first to reply!')),
                    )
                  else
                    ..._comments.map((c) => _commentTile(
                      c['profiles']?['name'] ?? 'Unknown', 
                      c['comment_text'] ?? '', 
                      _formatTime(c['created_at']),
                      c['profiles']?['avatarUrl'],
                    )),
                ]),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8, top: 8, left: 16, right: 16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.bottomNav),
          child: Row(children: [
            CircleAvatar(
              radius: 18, 
              backgroundImage: context.watch<RoleProvider>().currentUser?.avatarUrl.isNotEmpty == true 
                  ? NetworkImage(context.watch<RoleProvider>().currentUser!.avatarUrl) 
                  : null,
              child: context.watch<RoleProvider>().currentUser?.avatarUrl.isEmpty == true ? const Icon(Icons.person) : null,
            ),
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
              onPressed: () async {
                if (_commentCtrl.text.isNotEmpty) {
                  final text = _commentCtrl.text;
                  _commentCtrl.clear();
                  FocusScope.of(context).unfocus();
                  
                  await storyProvider.addComment(currentPost.id, text);
                  _loadComments(); // Refresh comments
                }
              },
            ),
          ]),
        ),
      ]),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return 'now';
    final date = DateTime.parse(dateStr);
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Widget _actionBtn(IconData icon, String count, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.primary.withAlpha(13), 
        borderRadius: BorderRadius.circular(AppRadius.pill)
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: active ? Colors.white : AppColors.primary),
        const SizedBox(width: 6),
        Text(count, style: AppTheme.label(size: 13, color: active ? Colors.white : AppColors.primary)),
      ]),
    );
  }

  Widget _commentTile(String name, String comment, String time, String? avatarUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(
          radius: 16, 
          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          backgroundColor: AppColors.primary.withAlpha(26), 
          child: (avatarUrl == null || avatarUrl.isEmpty) ? Text(name.isNotEmpty ? name[0] : '?', style: AppTheme.label(size: 14, color: AppColors.primary)) : null,
        ),
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

  Color _roleChipColor(String role) {
    final r = role.toLowerCase();
    if (r == 'guide') return AppColors.guideGreen;
    if (r == 'merchant') return AppColors.merchantAmber;
    return AppColors.touristBlue;
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


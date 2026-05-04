import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../data/mock_data.dart';
import '../data/services/story_service.dart';

class StoryProvider extends ChangeNotifier {
  final _storyService = StoryService();
  List<Post> _posts = [];
  bool _isLoading = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  StoryProvider() {
    _init();
  }

  Future<void> _init() async {
    await refreshPosts();
  }

  Future<void> refreshPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final realPosts = await _storyService.getPosts();
      final mockPosts = await MockData.getPosts();
      
      // Filter mock posts to not duplicate IDs if we start using real IDs that match
      // For now, just mix them. Real posts first.
      _posts = [...realPosts, ...mockPosts];
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      // Fallback to mock data if error
      _posts = await MockData.getPosts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(String content, {List<String> images = const [], List<String> hashtags = const [], String? location}) async {
    try {
      final newPost = await _storyService.createPost(
        content: content,
        photos: images,
        hashtags: hashtags,
        locationLabel: location,
      );
      _posts.insert(0, newPost);
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating post: $e');
      // Local fallback for UI testing
      final localPost = Post(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        authorId: 'temp',
        userName: 'You',
        userAvatar: 'https://picsum.photos/seed/user/100/100',
        userRole: 'Tourist',
        location: location ?? 'Davao City',
        content: content,
        images: images,
        hashtags: hashtags.isNotEmpty ? hashtags : ['#kuyog'],
        upvotes: 0,
        comments: 0,
        createdAt: DateTime.now(),
        isBookmarked: false,
      );
      _posts.insert(0, localPost);
      notifyListeners();
    }
  }

  void toggleBookmark(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(isBookmarked: !_posts[index].isBookmarked);
      notifyListeners();
    }
  }

  Future<void> upvotePost(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final p = _posts[index];
    final wasUpvoted = p.isUpvoted;
    
    // Optimistic UI update
    _posts[index] = p.copyWith(
      isUpvoted: !wasUpvoted,
      upvotes: wasUpvoted ? p.upvotes - 1 : p.upvotes + 1,
    );
    notifyListeners();

    try {
      if (postId.startsWith('temp_') || postId.startsWith('p')) {
        // Mock post upvote logic (p1, p2 etc are mock IDs)
        return; 
      }
      await _storyService.upvotePost(postId);
    } catch (e) {
      debugPrint('Error upvoting: $e');
      // Revert on error
      _posts[index] = p;
      notifyListeners();
    }
  }

  Future<void> addComment(String postId, String text) async {
    try {
      if (!postId.startsWith('temp_') && !postId.startsWith('p')) {
        await _storyService.addComment(postId, text);
      }
      
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(comments: _posts[index].comments + 1);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }
}

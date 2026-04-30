import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../data/mock_data.dart';

class StoryProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  StoryProvider() {
    _init();
  }

  Future<void> _init() async {
    _posts = await MockData.getPosts();
    _isLoading = false;
    notifyListeners();
  }

  void addPost(String content, List<String> images) {
    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userName: 'Current User',
      userAvatar: 'https://picsum.photos/seed/user/100/100',
      userRole: 'Tourist',
      location: 'Davao City',
      timeAgo: 'Just now',
      content: content,
      images: images,
      hashtags: ['#kuyog', '#mindanao'],
      upvotes: 0,
      comments: 0,
      isBookmarked: false,
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  void toggleBookmark(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final p = _posts[index];
      _posts[index] = Post(
        id: p.id, userName: p.userName, userAvatar: p.userAvatar,
        userRole: p.userRole,
        location: p.location, timeAgo: p.timeAgo, content: p.content, images: p.images,
        hashtags: p.hashtags, upvotes: p.upvotes, comments: p.comments,
        isBookmarked: !p.isBookmarked,
      );
      notifyListeners();
    }
  }

  void upvotePost(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final p = _posts[index];
      _posts[index] = Post(
        id: p.id, userName: p.userName, userAvatar: p.userAvatar,
        userRole: p.userRole,
        location: p.location, timeAgo: p.timeAgo, content: p.content, images: p.images,
        hashtags: p.hashtags, upvotes: p.upvotes + 1, comments: p.comments,
        isBookmarked: p.isBookmarked,
      );
      notifyListeners();
    }
  }
}

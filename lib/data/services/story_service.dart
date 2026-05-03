import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/client.dart';
import '../../models/post.dart';

class StoryService {
  SupabaseClient get _client => AppSupabase.client;

  Future<List<Post>> getPosts() async {
    final response = await _client
        .from('story_posts')
        .select('*, profiles(name, avatarUrl, role)')
        .order('created_at', ascending: false);

    final List<dynamic> data = response;
    
    // Check for user's upvotes if logged in
    final userId = _client.auth.currentUser?.id;
    List<String> userUpvotedPostIds = [];
    
    if (userId != null) {
      final upvotesResponse = await _client
          .from('post_interactions')
          .select('post_id')
          .eq('user_id', userId)
          .eq('type', 'upvote');
      
      userUpvotedPostIds = List<String>.from(
        (upvotesResponse as List).map((u) => u['post_id'].toString())
      );
    }

    return data.map((json) {
      final isUpvoted = userUpvotedPostIds.contains(json['id'].toString());
      return Post.fromJson({...json, 'isUpvoted': isUpvoted});
    }).toList();
  }

  Future<Post> createPost({
    required String content,
    List<String> photos = const [],
    List<String> hashtags = const [],
    String? locationLabel,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _client.from('story_posts').insert({
      'author_id': userId,
      'content': content,
      'photos': photos,
      'hashtags': hashtags,
      'location_label': locationLabel ?? 'Davao City',
    }).select('*, profiles(name, avatarUrl, role)').single();

    return Post.fromJson(response);
  }

  Future<void> upvotePost(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // Check if already upvoted
    final existing = await _client
        .from('post_interactions')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .eq('type', 'upvote')
        .maybeSingle();

    if (existing != null) {
      // Remove upvote
      await _client
          .from('post_interactions')
          .delete()
          .eq('id', existing['id']);
      
      // Decrement counter
      await _client.rpc('decrement_post_upvotes', params: {'post_id': postId});
    } else {
      // Add upvote
      await _client.from('post_interactions').insert({
        'post_id': postId,
        'user_id': userId,
        'type': 'upvote',
      });
      
      // Increment counter
      await _client.rpc('increment_post_upvotes', params: {'post_id': postId});
    }
  }

  Future<void> addComment(String postId, String text) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    await _client.from('post_interactions').insert({
      'post_id': postId,
      'user_id': userId,
      'type': 'comment',
      'comment_text': text,
    });

    // Increment comment count
    await _client.rpc('increment_post_comments', params: {'post_id': postId});
  }

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    final response = await _client
        .from('post_interactions')
        .select('*, profiles(name, avatarUrl)')
        .eq('post_id', postId)
        .eq('type', 'comment')
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String> uploadPostPhoto(String path, List<int> bytes) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.split('/').last}';
    final storagePath = 'posts/$fileName';

    await _client.storage.from('storyhub').uploadBinary(
      storagePath,
      Uint8List.fromList(bytes),
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    return _client.storage.from('storyhub').getPublicUrl(storagePath);
  }
}

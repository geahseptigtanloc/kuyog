import '../../core/supabase/client.dart';
import '../../models/user.dart';

class ProfileService {
  final _client = AppSupabase.client;
  static const String _tableName = 'profiles';

  /// Get the current user's profile
  Future<User?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return User.fromJson(response);
  }

  /// Create or update a profile
  Future<User> upsertProfile(User user) async {
    final response = await _client
        .from(_tableName)
        .upsert(user.toJson())
        .select()
        .single();
    return User.fromJson(response);
  }

  /// Update specific fields of a profile
  Future<User> updateProfile(String id, Map<String, dynamic> updates) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return User.fromJson(response);
  }

  /// Get profiles by role (e.g., all guides)
  Future<List<User>> getProfilesByRole(String role) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('role', role);
    
    return (response as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
}

import '../../core/supabase/client.dart';
import '../../models/itinerary.dart';

class ItineraryService {
  final _client = AppSupabase.client;
  static const String _tableName = 'itineraries';

  /// Create a new itinerary
  Future<Itinerary> createItinerary(Itinerary itinerary) async {
    final response = await _client
        .from(_tableName)
        .insert(itinerary.toJson())
        .select()
        .single();
    return Itinerary.fromJson(response);
  }

  /// Get all itineraries for a user
  Future<List<Itinerary>> getMyItineraries() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('creatorId', userId) // Assuming 'creatorId' column exists
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => Itinerary.fromJson(json))
        .toList();
  }

  /// Get public itineraries (browse)
  Future<List<Itinerary>> getPublicItineraries() async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('status', 'Active') // Only show active/public ones
        .order('rating', ascending: false);
    
    return (response as List)
        .map((json) => Itinerary.fromJson(json))
        .toList();
  }

  /// Update an itinerary
  Future<Itinerary> updateItinerary(String id, Map<String, dynamic> updates) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return Itinerary.fromJson(response);
  }

  /// Delete an itinerary
  Future<void> deleteItinerary(String id) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', id);
  }
}

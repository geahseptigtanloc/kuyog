import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/client.dart';

class AdminService {
  SupabaseClient get _client => AppSupabase.client;

  /// Fetch all non-draft guide verifications
  Future<List<Map<String, dynamic>>> getPendingGuideVerifications() async {
    final response = await _client
        .from('guide_verifications')
        .select('*, profiles!guide_verifications_guide_id_fkey(id, name, location)')
        .neq('status', 'draft')
        .order('submitted_at', ascending: false);
    
    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch all non-draft merchant verifications
  Future<List<Map<String, dynamic>>> getPendingMerchantVerifications() async {
    final response = await _client
        .from('merchant_verifications')
        .select('*, merchant_profiles(id, businessName, address, profile_id, profiles(name))')
        .neq('status', 'draft')
        .order('submitted_at', ascending: false);
        
    return List<Map<String, dynamic>>.from(response);
  }

  /// Approve or Reject a guide verification
  Future<void> updateGuideVerificationStatus(String guideId, String status) async {
    await _client
        .from('guide_verifications')
        .update({'status': status})
        .eq('guide_id', guideId);
  }

  /// Approve or Reject a merchant verification
  Future<void> updateMerchantVerificationStatus(String merchantId, String status) async {
    await _client
        .from('merchant_verifications')
        .update({'status': status})
        .eq('merchant_id', merchantId);
  }
}

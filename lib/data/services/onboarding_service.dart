import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/client.dart';

class OnboardingService {
  SupabaseClient get _client => AppSupabase.client;

  /// Save tourist preferences
  Future<void> saveTouristPreferences({
    required String userId,
    List<String>? interests,
    String? travelStyle,
    String? countryOfOrigin,
    String? budgetRange,
    List<String>? preferredLanguages,
  }) async {
    final data = {
      'profile_id': userId,
      if (interests != null) 'interests': interests,
      if (travelStyle != null) 'travel_style': travelStyle,
      if (countryOfOrigin != null) 'country_of_origin': countryOfOrigin,
      if (budgetRange != null) 'budget_range': budgetRange,
      if (preferredLanguages != null) 'languages_preferred': preferredLanguages,
    };

    await _client.from('tourist_preferences').upsert(data, onConflict: 'profile_id');
  }

  /// Save guide profile information
  Future<void> saveGuideProfile({
    required String userId,
    String? bio,
    int? yearsExperience,
    String? location,
    String? communityArea,
    List<String>? languages,
    List<String>? specialties,
  }) async {
    // Update main profile for bio and languages and location
    final profileUpdate = {
      if (bio != null) 'bio': bio,
      if (languages != null) 'languages': languages,
      if (location != null) 'location': location,
    };

    if (profileUpdate.isNotEmpty) {
      await _client.from('profiles').update(profileUpdate).eq('id', userId);
    }

    // Update guide-specific profile
    final guideData = {
      'profile_id': userId,
      if (specialties != null) 'specialties': specialties,
      if (yearsExperience != null) 'yearsExperience': yearsExperience,
      if (communityArea != null) 'communityArea': communityArea,
    };

    await _client.from('guide_profiles').upsert(guideData, onConflict: 'profile_id');
  }

  /// Upload a file to the verifications bucket
  Future<String> uploadVerificationFile({
    required String userId,
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final path = '$userId/$fileName';
    await _client.storage.from('verifications').uploadBinary(
          path,
          Uint8List.fromList(fileBytes),
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('verifications').getPublicUrl(path);
  }

  /// Submit guide verification status with document URLs
  Future<void> submitGuideVerification({
    required String userId,
    String? cvUrl,
    String? idFrontUrl,
    List<String>? portfolioUrls,
  }) async {
    final data = {
      'guide_id': userId,
      'status': 'submitted',
      if (cvUrl != null) 'cv_url': cvUrl,
      if (idFrontUrl != null) 'id_front_url': idFrontUrl,
      if (portfolioUrls != null) 'portfolio_urls': portfolioUrls,
      'submitted_at': DateTime.now().toIso8601String(),
    };

    await _client.from('guide_verifications').upsert(data, onConflict: 'guide_id');
  }

  /// Save merchant profile information
  Future<void> saveMerchantProfile({
    required String userId,
    required String businessName,
    required String businessType,
    required String address,
  }) async {
    final data = {
      'profile_id': userId,
      'businessName': businessName,
      'businessType': businessType,
      'address': address,
    };

    await _client.from('merchant_profiles').upsert(data, onConflict: 'profile_id');
  }

  /// Mark user as onboarded
  Future<void> markOnboarded(String userId) async {
    await _client.from('profiles').update({
      'is_onboarded': true,
    }).eq('id', userId);
  }
}

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
    String status = 'submitted',
    String? cvUrl,
    String? selfieUrl,
    String? dotCertUrl,
    String? barangayClearanceUrl,
    String? birthCertUrl,
    String? nbiClearanceUrl,
    String? applicationFormUrl,
    List<String>? portfolioUrls,
    String? idUrl,
  }) async {
    final data = {
      'guide_id': userId,
      'status': status,
      if (cvUrl != null) 'cv_url': cvUrl,
      if (selfieUrl != null) 'selfie_url': selfieUrl,
      if (dotCertUrl != null) 'dot_cert_url': dotCertUrl,
      if (barangayClearanceUrl != null) 'barangay_clearance_url': barangayClearanceUrl,
      if (birthCertUrl != null) 'birth_cert_url': birthCertUrl,
      if (nbiClearanceUrl != null) 'nbi_clearance_url': nbiClearanceUrl,
      if (applicationFormUrl != null) 'application_form_url': applicationFormUrl,
      if (portfolioUrls != null) 'portfolio_urls': portfolioUrls,
      if (idUrl != null) 'id_url': idUrl,
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

  /// Submit merchant verification status
  Future<void> submitMerchantVerification({
    required String userId,
    String status = 'submitted',
    String? permitUrl,
    String? lguEndorsementUrl,
    String? dotAccreditationUrl,
  }) async {
    final data = {
      'merchant_id': userId,
      'status': status,
      if (permitUrl != null) 'permit_url': permitUrl,
      if (lguEndorsementUrl != null) 'lgu_endorsement_url': lguEndorsementUrl,
      if (dotAccreditationUrl != null) 'dot_accreditation_url': dotAccreditationUrl,
      'submitted_at': DateTime.now().toIso8601String(),
    };

    await _client.from('merchant_verifications').upsert(data, onConflict: 'merchant_id');
  }

  /// Mark user as onboarded
  Future<void> markOnboarded(String userId) async {
    await _client.from('profiles').update({
      'is_onboarded': true,
    }).eq('id', userId);
  }

  /// Fetch existing verification documents
  Future<Map<String, dynamic>?> getVerificationDocs(String userId, String role) async {
    final table = role == 'merchant' ? 'merchant_verifications' : 'guide_verifications';
    final idField = role == 'merchant' ? 'merchant_id' : 'guide_id';
    
    return await _client.from(table).select().eq(idField, userId).maybeSingle();
  }
}

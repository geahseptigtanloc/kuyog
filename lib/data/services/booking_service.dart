import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/client.dart';
import '../../models/tour_operator.dart';

class BookingService {
  SupabaseClient get _client => AppSupabase.client;

  /// Fetch all tour packages from Supabase
  Future<List<TourPackage>> getTourPackages() async {
    final response = await _client
        .from('jsu_packages')
        .select()
        .order('createdAt', ascending: false);
    
    return (response as List).map((json) => TourPackage.fromJson(json)).toList();
  }

  /// Create a new booking transaction
  Future<String> createBooking({
    required String packageId,
    required String touristId,
    String? operatorId,
    required DateTime tourDate,
    required int paxCount,
    required double totalAmount,
    required double serviceFee,
    required String paymentMethod,
    List<Map<String, dynamic>>? selectedAddOns,
  }) async {
    // Generate a reference code
    final refCode = 'KYG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final data = {
      'packageid': packageId,
      'touristid': touristId,
      if (operatorId != null && operatorId.isNotEmpty) 'operatorid': operatorId,
      'tourdate': tourDate.toIso8601String(),
      'paxcount': paxCount,
      'totalamount': totalAmount,
      'servicefee': serviceFee,
      'paymentmethod': paymentMethod,
      'selectedaddons': selectedAddOns,
      'referencecode': refCode,
      'status': 'confirmed',
    };

    final response = await _client
        .from('jsu_bookings')
        .insert(data)
        .select('referencecode')
        .single();

    return response['referencecode'] as String;
  }

  /// Fetch bookings for the current tourist
  Future<List<Map<String, dynamic>>> getTouristBookings(String touristId) async {
    final response = await _client
        .from('jsu_bookings')
        .select('*, jsu_packages(*), operator:operatorid(name, avatarUrl)')
        .eq('touristid', touristId)
        .order('tourdate', ascending: false);
    
    return List<Map<String, dynamic>>.from(response);
  }
}

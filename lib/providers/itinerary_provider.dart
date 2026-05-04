import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/itinerary.dart';
import '../data/mock_data.dart';

class ItineraryProvider extends ChangeNotifier {
  List<Itinerary> _itineraries = [];
  bool _isLoading = true;
  String _filterStatus = 'All';

  List<Itinerary> get itineraries => _itineraries;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  List<Itinerary> get filteredItineraries {
    if (_filterStatus == 'All') return _itineraries;
    return _itineraries.where((i) => i.status == _filterStatus).toList();
  }

  int get activeCount => _itineraries.where((i) => i.status == 'Active').length;
  int get completedCount => _itineraries.where((i) => i.status == 'Completed').length;
  int get draftCount => _itineraries.where((i) => i.status == 'Draft').length;

  ItineraryProvider() {
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      
      if (userId != null) {
        final res = await supabase
            .from('itineraries')
            .select()
            .eq('touristId', userId)
            .order('created_at', ascending: false);

        final List<Itinerary> fetchedItineraries = (res as List).map((json) => Itinerary.fromJson(json)).toList();
        
        if (fetchedItineraries.isNotEmpty) {
           _itineraries = fetchedItineraries;
        } else {
           _itineraries = await MockData.getItineraries();
        }
      } else {
        _itineraries = await MockData.getItineraries();
      }
    } catch (e) {
      debugPrint('Error loading itineraries: $e');
      _itineraries = await MockData.getItineraries();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadItineraries();
  }

  void setFilter(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void addItinerary(Itinerary itinerary) {
    _itineraries.insert(0, itinerary);
    notifyListeners();
  }

  Future<void> deleteItinerary(String id) async {
    try {
      if (!id.startsWith('mock_')) {
        await Supabase.instance.client.from('itineraries').delete().eq('id', id);
      }
    } catch (e) {
      debugPrint('Error deleting itinerary: $e');
    }
    _itineraries.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void duplicateItinerary(String id) {
    final idx = _itineraries.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final orig = _itineraries[idx];
      final copy = Itinerary(
        id: 'it_${DateTime.now().millisecondsSinceEpoch}',
        title: '${orig.title} (Copy)',
        destination: orig.destination,
        imageUrl: orig.imageUrl,
        stopsCount: orig.stopsCount,
        status: 'Draft',
        days: orig.days,
        totalCost: orig.totalCost,
        estimatedCost: orig.estimatedCost,
        guestCount: orig.guestCount,
        creationMode: orig.creationMode,
        region: orig.region,
        durationDays: orig.durationDays,
      );
      _itineraries.insert(idx + 1, copy);
      notifyListeners();
    }
  }
}

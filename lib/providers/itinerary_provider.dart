import 'package:flutter/material.dart';
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
    _itineraries = await MockData.getItineraries();
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void addItinerary(Itinerary itinerary) {
    _itineraries.insert(0, itinerary);
    notifyListeners();
  }

  void deleteItinerary(String id) {
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

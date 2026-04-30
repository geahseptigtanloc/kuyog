import 'package:flutter/material.dart';
import '../models/match_request.dart';
import '../data/mock_data.dart';

class MatchProvider extends ChangeNotifier {
  List<MatchRequest> _requests = [];
  bool _isLoading = true;
  final Set<String> _sentRequests = {}; // guide IDs with pending requests

  List<MatchRequest> get requests => _requests;
  List<MatchRequest> get pendingRequests => _requests.where((r) => r.status == 'pending').toList();
  List<MatchRequest> get acceptedRequests => _requests.where((r) => r.status == 'accepted').toList();
  List<MatchRequest> get declinedRequests => _requests.where((r) => r.status == 'declined').toList();
  bool get isLoading => _isLoading;
  Set<String> get sentRequests => _sentRequests;

  MatchProvider() {
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    _requests = await MockData.getMatchRequests();
    _isLoading = false;
    notifyListeners();
  }

  void sendMatchRequest(String guideId) {
    _sentRequests.add(guideId);
    notifyListeners();
  }

  bool hasRequestedMatch(String guideId) {
    return _sentRequests.contains(guideId);
  }

  void acceptRequest(String requestId) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _requests[idx];
      _requests[idx] = MatchRequest(
        id: req.id,
        touristName: req.touristName,
        touristAvatar: req.touristAvatar,
        touristLocation: req.touristLocation,
        travelPreferences: req.travelPreferences,
        destinationsOfInterest: req.destinationsOfInterest,
        travelDates: req.travelDates,
        matchScore: req.matchScore,
        status: 'accepted',
        timeAgo: req.timeAgo,
      );
      notifyListeners();
    }
  }

  void declineRequest(String requestId, String? reason) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _requests[idx];
      _requests[idx] = MatchRequest(
        id: req.id,
        touristName: req.touristName,
        touristAvatar: req.touristAvatar,
        touristLocation: req.touristLocation,
        travelPreferences: req.travelPreferences,
        destinationsOfInterest: req.destinationsOfInterest,
        travelDates: req.travelDates,
        matchScore: req.matchScore,
        status: 'declined',
        declineReason: reason,
        timeAgo: req.timeAgo,
      );
      notifyListeners();
    }
  }
}

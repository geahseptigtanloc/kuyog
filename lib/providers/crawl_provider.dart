import 'package:flutter/material.dart';

class CrawlProvider extends ChangeNotifier {
  final Set<String> _collectedStamps = {'s1', 's2', 's3'};
  String _activeEventId = 'e1';

  Set<String> get collectedStamps => _collectedStamps;
  String get activeEventId => _activeEventId;
  int get stampCount => _collectedStamps.length;

  bool isStampCollected(String spotId) => _collectedStamps.contains(spotId);

  void collectStamp(String spotId) {
    _collectedStamps.add(spotId);
    notifyListeners();
  }

  void setActiveEvent(String eventId) {
    _activeEventId = eventId;
    notifyListeners();
  }

  bool get canRedeemRewards => _collectedStamps.length >= 8;
}

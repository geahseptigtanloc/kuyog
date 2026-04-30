import 'package:flutter/material.dart';

class CrawlProvider extends ChangeNotifier {
  final Set<String> _selectedRegions = {};
  final Map<String, Set<String>> _collectedStamps = {};
  bool _hasSelectedRegions = false;

  Set<String> get selectedRegions => _selectedRegions;
  bool get hasSelectedRegions => _hasSelectedRegions;

  bool isRegionSelected(String regionId) => _selectedRegions.contains(regionId);

  void toggleRegion(String regionId) {
    if (_selectedRegions.contains(regionId)) {
      _selectedRegions.remove(regionId);
    } else {
      _selectedRegions.add(regionId);
    }
    notifyListeners();
  }

  void startCrawling() {
    _hasSelectedRegions = _selectedRegions.isNotEmpty;
    notifyListeners();
  }

  void collectStamp(String regionId, String stampId) {
    _collectedStamps.putIfAbsent(regionId, () => {});
    _collectedStamps[regionId]!.add(stampId);
    notifyListeners();
  }

  bool isStampCollected(String regionId, String stampId) {
    return _collectedStamps[regionId]?.contains(stampId) ?? false;
  }

  int collectedStampsCount(String regionId) {
    return _collectedStamps[regionId]?.length ?? 0;
  }

  // Total stamp count across all regions (backward compat)
  int get stampCount {
    int total = 0;
    for (final stamps in _collectedStamps.values) {
      total += stamps.length;
    }
    return total;
  }

  // Single-arg collect (for backward compat with old crawl screens)
  void collectStampSimple(String stampId) {
    collectStamp('default', stampId);
  }
}

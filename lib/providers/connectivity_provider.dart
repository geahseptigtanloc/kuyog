import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _showBanner = false;

  bool get isOnline => _isOnline;
  bool get showBanner => _showBanner;

  void toggleOffline() {
    _isOnline = !_isOnline;
    _showBanner = !_isOnline;
    notifyListeners();
    if (_isOnline) {
      Future.delayed(const Duration(seconds: 2), () {
        _showBanner = false;
        notifyListeners();
      });
    }
  }

  void setOnline(bool online) {
    _isOnline = online;
    _showBanner = !online;
    notifyListeners();
  }
}

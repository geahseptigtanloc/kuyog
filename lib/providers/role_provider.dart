import 'package:flutter/material.dart';

enum UserRole { tourist, guide, merchant, admin, superAdmin }

class RoleProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.tourist;
  String _userName = 'Maria';

  UserRole get currentRole => _currentRole;
  String get userName => _userName;

  void switchRole(UserRole role) {
    _currentRole = role;
    switch (role) {
      case UserRole.tourist:
        _userName = 'Maria';
      case UserRole.guide:
        _userName = 'Juan';
      case UserRole.merchant:
        _userName = 'Fatima';
      case UserRole.admin:
        _userName = 'Admin';
      case UserRole.superAdmin:
        _userName = 'Super Admin';
    }
    notifyListeners();
  }

  String get roleDisplayName {
    switch (_currentRole) {
      case UserRole.tourist:
        return 'Tourist';
      case UserRole.guide:
        return 'Tour Guide';
      case UserRole.merchant:
        return 'Merchant';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  String get greeting {
    switch (_currentRole) {
      case UserRole.tourist:
        return 'Kuyog ta, $_userName!';
      case UserRole.guide:
        return 'Kumusta, $_userName!';
      case UserRole.merchant:
        return 'Maayong adlaw, $_userName!';
      case UserRole.admin:
        return 'Welcome, $_userName';
      case UserRole.superAdmin:
        return 'Welcome, $_userName';
    }
  }
}

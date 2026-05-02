import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../data/services/profile_service.dart';
import '../models/user.dart';

enum UserRole { tourist, guide, merchant, admin, superAdmin }

class RoleProvider extends ChangeNotifier {
  final _profileService = ProfileService();
  User? _currentUser;
  bool _isLoading = false;

  RoleProvider() {
    // Listen for auth changes to clear state automatically
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        clear();
      }
    });
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  
  UserRole get currentRole {
    if (_currentUser == null) return UserRole.tourist;
    final r = _currentUser!.role.toLowerCase().trim();
    if (r == 'guide') return UserRole.guide;
    if (r == 'merchant') return UserRole.merchant;
    if (r == 'admin') return UserRole.admin;
    if (r == 'super_admin' || r == 'superadmin') return UserRole.superAdmin;
    return UserRole.tourist;
  }

  String get userName => _currentUser?.name ?? 'User';

  String get roleDisplayName {
    switch (currentRole) {
      case UserRole.tourist: return 'Tourist';
      case UserRole.guide: return 'Tour Guide';
      case UserRole.merchant: return 'Merchant';
      case UserRole.admin: return 'Admin';
      case UserRole.superAdmin: return 'Super Admin';
    }
  }

  String get greeting {
    switch (currentRole) {
      case UserRole.tourist: return 'Kuyog ta, $userName!';
      case UserRole.guide: return 'Kumusta, $userName!';
      case UserRole.merchant: return 'Maayong adlaw, $userName!';
      default: return 'Welcome, $userName';
    }
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // 1. Give Supabase a moment to finalize the session
      await Future.delayed(const Duration(milliseconds: 500));
      
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user != null) {
        final email = user.email?.toLowerCase() ?? '';
        
        // 🌟 HARDCODED BYPASS: Check for dummy admin accounts
        if (email == 'admin@kuyog.com') {
          _currentUser = User(
            id: user.id,
            name: 'Kuyog Admin',
            email: 'admin@kuyog.com',
            role: 'admin',
            avatarUrl: '',
            joinedDate: DateTime.now(),
          );
        } else if (email == 'superadmin@kuyog.com') {
          _currentUser = User(
            id: user.id,
            name: 'Kuyog Super Admin',
            email: 'superadmin@kuyog.com',
            role: 'super_admin',
            avatarUrl: '',
            joinedDate: DateTime.now(),
          );
        } else {
          // Normal DB fetch for other roles
          _currentUser = await _profileService.getCurrentProfile();
        }
        debugPrint('RoleProvider: Profile hydrated for $email. Role is: ${_currentUser?.role}');
      } else {
        debugPrint('RoleProvider: No authenticated user found during init.');
      }
    } catch (e) {
      debugPrint('RoleProvider: Initialization error: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// 🌟 MANUAL OVERRIDE: For hardcoded admin bypass
  void setMockUser(String email) {
    final cleanEmail = email.toLowerCase().trim();
    if (cleanEmail == 'admin@kuyog.com') {
      _currentUser = User(
        id: 'mock-admin-id',
        name: 'Kuyog Admin',
        email: 'admin@kuyog.com',
        role: 'admin',
        avatarUrl: '',
        joinedDate: DateTime.now(),
      );
    } else if (cleanEmail == 'superadmin@kuyog.com') {
      _currentUser = User(
        id: 'mock-superadmin-id',
        name: 'Kuyog Super Admin',
        email: 'superadmin@kuyog.com',
        role: 'super_admin',
        avatarUrl: '',
        joinedDate: DateTime.now(),
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    notifyListeners();
  }

  /// Logs the user out and clears local state
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      clear();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  /// Updates the user role in the database
  Future<void> switchRole(UserRole role) async {
    if (_currentUser == null) return;

    String roleString;
    switch (role) {
      case UserRole.guide: roleString = 'guide'; break;
      case UserRole.merchant: roleString = 'merchant'; break;
      case UserRole.admin: roleString = 'admin'; break;
      case UserRole.superAdmin: roleString = 'super_admin'; break;
      default: roleString = 'tourist';
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Update the database
      await _profileService.updateProfile(_currentUser!.id, {'role': roleString});
      
      // Refresh local state
      await initialize();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error switching role: $e');
    }
  }
}

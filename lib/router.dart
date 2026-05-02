import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_signup_screen.dart';
import 'screens/auth/google_oauth_mock.dart';
import 'screens/auth/password_entry_screen.dart';
import 'screens/auth/loading_screen.dart';
import 'screens/auth/country_selection_screen.dart';
import 'screens/auth/tour_preferences_screen.dart';
import 'screens/auth/guide/guide_setup_screen.dart';
import 'screens/auth/guide/professional_profile_screen.dart';
import 'screens/auth/guide/cv_upload_screen.dart';
import 'screens/auth/guide/add_experience_screen.dart';
import 'screens/auth/guide/id_verification_screen.dart';
import 'screens/app_shell.dart';
import 'data/services/auth_service.dart';
import 'providers/role_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

// Helper class to listen to Auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// No global _auth here to avoid early initialization crash

final router = GoRouter(
  initialLocation: '/splash',
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  redirect: (context, state) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.uri.path.startsWith('/auth') || state.uri.path == '/splash' || state.uri.path == '/onboarding';

    // Allow access if we have a session OR a mock user (Admin bypass)
    if (session == null && roleProvider.currentUser == null && !isLoggingIn) {
      return '/splash';
    }

    final role = roleProvider.currentRole;
    final path = state.uri.path;

    // 1. If we have a session but haven't loaded the profile yet, stay on splash/loading
    if (session != null && roleProvider.isLoading && path != '/splash' && !path.startsWith('/auth')) {
      return null; // Stay put, don't redirect yet
    }

    // 2. RBAC: Protect Guide routes
    if (path.startsWith('/guide') && role != UserRole.guide) {
      return '/home';
    }
    
    // 3. RBAC: Protect Merchant routes
    if (path.startsWith('/merchant') && role != UserRole.merchant) {
      return '/home';
    }

    // 4. RBAC: Protect Admin routes
    if (path.startsWith('/admin') && role != UserRole.admin && role != UserRole.superAdmin) {
      return '/home';
    }

    return null; // No redirection needed
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(
        onComplete: () async {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            // HYDRATE: Fetch profile for existing session
            await Provider.of<RoleProvider>(context, listen: false).initialize();
            if (context.mounted) context.go('/home');
          } else {
            context.go('/onboarding');
          }
        },
      ),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(
        onRoleSelected: (role) => context.go('/auth', extra: {'role': role}),
      ),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final role = extra?['role'] ?? 'tourist';
        return LoginSignupScreen(
          onNext: (email) => context.go('/auth/google', extra: {'email': email, 'role': role}),
        );
      },
      routes: [
        GoRoute(
          path: 'google',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return GoogleOauthMockScreen(
              onAccountSelected: () => context.go('/auth/password', extra: extra),
            );
          },
        ),
        GoRoute(
          path: 'password',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final email = extra?['email'] ?? '';
            final role = extra?['role'] ?? 'tourist';
            return PasswordEntryScreen(
              email: email.trim(),
              role: role,
              onNext: (email, password, role) async {
                final auth = AuthService();
                final cleanEmail = email.trim();
                final cleanPassword = password.trim();
                
                try {
                  // 🌟 HARDCODED BYPASS CHECK
                  if (cleanEmail == 'admin@kuyog.com' || cleanEmail == 'superadmin@kuyog.com') {
                    if (cleanPassword == 'kuyog123') {
                      if (context.mounted) {
                        Provider.of<RoleProvider>(context, listen: false).setMockUser(cleanEmail);
                        context.go('/home');
                        return;
                      }
                    } else {
                      throw const AuthException('Invalid login credentials', statusCode: '400');
                    }
                  }

                  // 1. Attempt to Sign In (Standard Flow)
                  await auth.signIn(email: cleanEmail, password: cleanPassword);
                  
                  // HYDRATE: Fetch profile immediately after login
                  if (context.mounted) {
                    await Provider.of<RoleProvider>(context, listen: false).initialize();
                    context.go('/home');
                  }
                } on AuthException catch (e) {
                  // 2. If user not found (and ONLY if not found), attempt to Sign Up
                  // Note: Supabase sometimes returns 'Invalid login credentials' for both.
                  // We'll assume if it's a 400 and we're in the unified flow, we can try signup
                  // BUT we'll catch the 'User already exists' error from signup if it fails.
                  if (e.message.contains('Invalid login credentials') || e.statusCode == '400') {
                    try {
                      await auth.signUp(
                        email: cleanEmail, 
                        password: cleanPassword, 
                        name: cleanEmail.split('@')[0], 
                        role: role
                      );
                      if (context.mounted) context.go('/auth/loading');
                    } catch (signUpError) {
                      String errorMsg = signUpError.toString();
                      if (errorMsg.contains('already registered')) {
                        errorMsg = 'Incorrect password for this account.';
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMsg))
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.message}'))
                      );
                    }
                  }
                }
              },
            );
          },
        ),
        GoRoute(
          path: 'loading',
          builder: (context, state) => LoadingScreen(
            onComplete: () async {
              // HYDRATE: Fetch the profile before going home
              await Provider.of<RoleProvider>(context, listen: false).initialize();
              if (context.mounted) context.go('/home');
            },
          ),
        ),
        GoRoute(
          path: 'country',
          builder: (context, state) => CountrySelectionScreen(
            onNext: () => context.go('/auth/preferences'),
          ),
        ),
        GoRoute(
          path: 'preferences',
          builder: (context, state) => TourPreferencesScreen(
            onContinue: () => context.go('/home'),
          ),
        ),
        GoRoute(
          path: 'guide-setup',
          builder: (context, state) => GuideSetupScreen(
            onNext: () => context.go('/auth/professional-profile'),
          ),
        ),
        GoRoute(
          path: 'professional-profile',
          builder: (context, state) => ProfessionalProfileScreen(
            onNext: () => context.go('/auth/cv-upload'),
          ),
        ),
        GoRoute(
          path: 'cv-upload',
          builder: (context, state) => CvUploadScreen(
            onNext: () => context.go('/auth/add-experience'),
          ),
        ),
        GoRoute(
          path: 'add-experience',
          builder: (context, state) => AddExperienceScreen(
            onNext: () => context.go('/auth/id-verification'),
          ),
        ),
        GoRoute(
          path: 'id-verification',
          builder: (context, state) => IdVerificationScreen(
            onNext: () => context.go('/auth/guide-preferences'),
          ),
        ),
        GoRoute(
          path: 'guide-preferences',
          builder: (context, state) => TourPreferencesScreen(
            title: 'Tour Specialty',
            subtitle: 'Share your travel specialty, and we\'ll match you with interested tourists.',
            onContinue: () => context.go('/home'),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AppShell(),
    ),
    // Keep old routes for backward compatibility
    GoRoute(
      path: '/tourist-home',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/guide-home',
      redirect: (context, state) => '/home',
    ),
  ],
);

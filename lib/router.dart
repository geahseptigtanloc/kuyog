import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_flow_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/loading_screen.dart';
import 'screens/auth/travel_profile_screen.dart';
import 'screens/auth/tour_preferences_screen.dart';
import 'screens/auth/guide/guide_setup_screen.dart';
import 'screens/auth/guide/professional_profile_screen.dart';
import 'screens/auth/guide/cv_upload_screen.dart';
import 'screens/auth/guide/add_experience_screen.dart';
import 'screens/auth/guide/id_verification_screen.dart';
import 'screens/auth/merchant_setup_screen.dart';
import 'screens/app_shell.dart';
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
  // refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  redirect: (context, state) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final session = Supabase.instance.client.auth.currentSession;
    
    // 🔥 BYPASS AUTH FOR FRONTEND TESTING 🔥
    return null;

    final isLoggingIn = state.uri.path.startsWith('/auth') || state.uri.path == '/splash' || state.uri.path == '/onboarding';


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
      path: '/',
      redirect: (context, state) => '/splash',
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(
        onComplete: () async {
          // 🔥 BYPASS AUTH FOR FRONTEND TESTING 🔥
          // final session = Supabase.instance.client.auth.currentSession;
          // if (session != null) {
          //   await Provider.of<RoleProvider>(context, listen: false).initialize();
          //   if (context.mounted) context.go('/home');
          // } else {
            context.go('/onboarding');
          // }
        },
      ),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingFlowScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final role = extra?['role'] ?? 'tourist';
        return SignupScreen(
          role: role,
        );
      },
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final role = extra?['role'] ?? 'tourist';
            return LoginScreen(
              role: role,
            );
          },
        ),
        GoRoute(
          path: 'loading',
          builder: (context, state) => LoadingScreen(
            onComplete: () async {
              final roleProvider = Provider.of<RoleProvider>(context, listen: false);
              await roleProvider.initialize();
              
              if (!context.mounted) return;

              final user = roleProvider.currentUser;
              if (user == null) {
                context.go('/auth');
                return;
              }

              // Check if onboarded
              if (user.isOnboarded) {
                context.go('/home');
                return;
              }

              // Route to role-specific onboarding
              switch (roleProvider.currentRole) {
                case UserRole.tourist:
                  context.go('/auth/travel-profile');
                  break;
                case UserRole.guide:
                  context.go('/auth/guide-setup');
                  break;
                case UserRole.merchant:
                  context.go('/auth/merchant-setup');
                  break;
                default:
                  context.go('/home');
              }
            },
          ),
        ),
        GoRoute(
          path: 'travel-profile',
          builder: (context, state) => TravelProfileScreen(
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
        GoRoute(
          path: 'merchant-setup',
          builder: (context, state) => MerchantSetupScreen(
            onNext: () => context.go('/home'),
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

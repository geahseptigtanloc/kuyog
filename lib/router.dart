import 'package:go_router/go_router.dart';

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

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(
        onComplete: () => context.go('/onboarding'),
      ),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(
        onTouristSelected: () => context.go('/auth'),
        onGuideSelected: () => context.go('/auth'),
        onMerchantSelected: () => context.go('/auth'),
      ),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => LoginSignupScreen(
        onNext: () => context.go('/auth/google'),
      ),
      routes: [
        GoRoute(
          path: 'google',
          builder: (context, state) => GoogleOauthMockScreen(
            onAccountSelected: () => context.go('/auth/password'),
          ),
        ),
        GoRoute(
          path: 'password',
          builder: (context, state) => PasswordEntryScreen(
            onNext: () => context.go('/auth/loading'),
          ),
        ),
        GoRoute(
          path: 'loading',
          builder: (context, state) => LoadingScreen(
            onComplete: () => context.go('/auth/country'),
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

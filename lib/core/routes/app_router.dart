import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/set_new_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/security_privacy_screen.dart';
import '../../features/roadmaps/presentation/screens/roadmaps_screen.dart';
import '../../features/setup/presentation/screens/step1_terms_screen.dart';
import '../../features/setup/presentation/screens/step2_tracks_screen.dart';
import '../../features/setup/presentation/screens/step3_profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildPageRoute(
          const SplashScreen(),
          settings: settings,
        );

      case AppRoutes.onboarding:
        return _buildPageRoute(
          const OnboardingScreen(),
          settings: settings,
        );

      case AppRoutes.auth:
        final args = settings.arguments as Map<String, dynamic>?;
        final initialIsSignIn = args?['initialIsSignIn'] as bool? ?? true;
        return _buildPageRoute(
          AuthScreen(initialIsSignIn: initialIsSignIn),
          settings: settings,
        );

      case AppRoutes.forgotPassword:
        return _buildPageRoute(
          const ForgotPasswordScreen(),
          settings: settings,
        );

      case AppRoutes.setNewPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          SetNewPasswordScreen(
            email: args?['email'] as String?,
            token: args?['token'] as String?,
          ),
          settings: settings,
        );

      case AppRoutes.setupTerms:
        return _buildPageRoute(
          const Step1TermsScreen(),
          settings: settings,
        );

      case AppRoutes.setupTracks:
        return _buildPageRoute(
          const Step2TracksScreen(),
          settings: settings,
        );

      case AppRoutes.setupProfile:
        return _buildPageRoute(
          const Step3ProfileScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        return _buildPageRoute(
          const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.profile:
        return _buildPageRoute(
          const ProfileScreen(),
          settings: settings,
        );

      case AppRoutes.roadmaps:
        return _buildPageRoute(
          const RoadmapsScreen(),
          settings: settings,
        );

      case AppRoutes.securityPrivacy:
        return _buildPageRoute(
          const SecurityPrivacyScreen(),
          settings: settings,
        );

      default:
        return _buildPageRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }

  static PageRouteBuilder<T> _buildPageRoute<T>(
    Widget page, {
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

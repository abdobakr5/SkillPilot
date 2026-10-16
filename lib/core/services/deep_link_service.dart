import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Map<String, String?>? pendingResetCredentials;

  void init() {
    // 1. Listen to incoming links while app is in foreground or background
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri),
      onError: (err) {
        debugPrint('DeepLink stream error: $err');
      },
    );

    // 2. Handle cold start initial link
    _checkInitialUri();
  }

  Future<void> _checkInitialUri() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('DeepLink initial link error: $e');
    }
  }

  void _handleUri(Uri uri) {
    debugPrint('Received DeepLink: $uri');

    // Expected reset link patterns:
    // - https://skillpilot-silk.vercel.app/reset-password?email=...&token=...
    // - skillpilot://reset-password?email=...&token=...
    // - http://130.110.99.157:8080/api/Auth/reset-password?email=...&token=...
    // - http://localhost:5173/reset-password?email=...&token=...
    final path = uri.path.toLowerCase();
    final host = uri.host.toLowerCase();
    final isResetPassword =
        host == 'reset-password' || path.contains('reset-password');

    if (isResetPassword) {
      final email = uri.queryParameters['email'];
      final rawToken = uri.queryParameters['token'];
      final token = rawToken?.replaceAll(' ', '+');

      pendingResetCredentials = {
        'email': email,
        'token': token,
      };

      _navigateToResetPassword(email, token);
    }
  }

  void _navigateToResetPassword(String? email, String? token) {
    void navigate() {
      pendingResetCredentials = null;
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.setNewPassword,
        (route) => false,
        arguments: {
          'email': email,
          'token': token,
        },
      );
    }

    if (navigatorKey.currentState != null) {
      navigate();
    } else {
      // Defer navigation until MaterialApp navigator is mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigate();
      });
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}

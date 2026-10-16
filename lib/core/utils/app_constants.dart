class AppConstants {
  AppConstants._();

  // App Metadata
  static const String appVersion = '1.0.0';

  // Animation & UI Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Layout Paddings & Radius
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;

  // Cache & Storage Keys
  static const String cachedThemeMode = 'CACHED_THEME_MODE';
  static const String cachedLocale = 'CACHED_LOCALE';
  static const String isFirstTimeLaunch = 'IS_FIRST_TIME_LAUNCH';

  // OAuth Configurations
  static const String gitHubClientId = String.fromEnvironment(
    'GITHUB_CLIENT_ID',
    defaultValue: 'Ov23liyDNCMmISlXmNIw',
  );
  static const String gitHubRedirectUri = 'skillpilot://oauth-callback';
  static const String googleAndroidClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_CLIENT_ID',
    defaultValue:
        '187957579519-199bhetle4jpsteaod6qoil0i0crp7l7.apps.googleusercontent.com',
  );
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '187957579519-fgj1cvpq77b88orsbvgtfju2p97j3of2.apps.googleusercontent.com',
  );
}

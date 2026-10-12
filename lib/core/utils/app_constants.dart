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
}

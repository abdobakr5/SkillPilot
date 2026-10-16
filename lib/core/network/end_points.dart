class EndPoints {
  EndPoints._();

  /// API Base URL
  /// Injected via: flutter run --dart-define=BASE_URL=http://...
  /// Or read locally from .env (ignored by git)
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://130.110.99.157:8080',
  );

  /// Network timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ----------------------------------------------------
  // Auth Endpoints
  // ----------------------------------------------------
  static const String register = '/api/Auth/register';
  static const String login = '/api/Auth/login';
  static const String googleLogin = '/api/Auth/google';
  static const String gitHubLogin = '/api/Auth/github';
  static const String confirmEmail = '/api/Auth/confirm-email';
  static const String forgotPassword = '/api/Auth/forgot-password';
  static const String resetPassword = '/api/Auth/reset-password';
  static const String refreshToken = '/api/Auth/refresh-token';

  // ----------------------------------------------------
  // Onboarding Endpoints
  // ----------------------------------------------------
  static const String onboardingTerms = '/api/Onboarding/terms';
  static const String onboardingStatus = '/api/Onboarding/status';
  static const String onboardingTermsAccept = '/api/Onboarding/terms/accept';
  static const String onboardingTracks = '/api/Onboarding/tracks';
  static const String onboardingTracksSelect = '/api/Onboarding/tracks/select';
  static const String onboardingProfile = '/api/Onboarding/profile';
  static const String onboardingCvExtract = '/api/Onboarding/cv/extract';

  // ----------------------------------------------------
  // Repositories Endpoints
  // ----------------------------------------------------
  static const String repositories = '/api/Repositories';
  static const String repositoriesSync = '/api/Repositories/sync';
  static String repositoryFeatured(String id) => '/api/Repositories/$id/featured';

  // ----------------------------------------------------
  // Health
  // ----------------------------------------------------
  static const String healthReady = '/api/health/ready';
}

class ApiKeys {
  ApiKeys._();

  // Headers
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer ';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';

  // Result envelope keys (Clean Architecture Result Envelope)
  static const String statusCode = 'statusCode';
  static const String succeeded = 'succeeded';
  static const String message = 'message';
  static const String error = 'error';
  static const String errors = 'errors';
  static const String data = 'data';

  // Auth payload & response fields
  static const String email = 'email';
  static const String password = 'password';
  static const String userName = 'userName';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String token = 'token';
  static const String userId = 'userId';
  static const String idToken = 'idToken';
  static const String code = 'code';
  static const String redirectUri = 'redirectUri';
  static const String newPassword = 'newPassword';

  // Token Response fields
  static const String accessToken = 'accessToken';
  static const String accessTokenExpiresInMinutes = 'accessTokenExpiresInMinutes';
  static const String refreshToken = 'refreshToken';
  static const String refreshTokenExpiresOnUtc = 'refreshTokenExpiresOnUtc';

  // Onboarding fields
  static const String termsVersion = 'termsVersion';
  static const String accepted = 'accepted';
  static const String trackType = 'trackType';
  static const String track = 'track';
  static const String file = 'File';
}

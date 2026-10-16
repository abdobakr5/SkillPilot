import '../../domain/entities/auth_token_entity.dart';

class AuthResponseModel extends AuthTokenEntity {
  const AuthResponseModel({
    required super.accessToken,
    super.expiresInMinutes,
    super.refreshToken,
    super.refreshTokenExpiresOnUtc,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      expiresInMinutes: json['accessTokenExpiresInMinutes'] as int?,
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpiresOnUtc: json['refreshTokenExpiresOnUtc'] as String?,
      user: UserEntity(
        userName: json['userName'] as String?,
        email: json['email'] as String?,
        gitHubUsername: json['gitHubUsername'] as String?,
        hasAcceptedTerms: json['hasAcceptedTerms'] as bool? ?? false,
        onboardingStep: json['onboardingStep'] as int?,
        isOnboardingCompleted: json['isOnboardingCompleted'] as bool? ?? false,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'accessTokenExpiresInMinutes': expiresInMinutes,
      'refreshToken': refreshToken,
      'refreshTokenExpiresOnUtc': refreshTokenExpiresOnUtc,
      'userName': user.userName,
      'email': user.email,
      'gitHubUsername': user.gitHubUsername,
      'hasAcceptedTerms': user.hasAcceptedTerms,
      'onboardingStep': user.onboardingStep,
      'isOnboardingCompleted': user.isOnboardingCompleted,
    };
  }
}

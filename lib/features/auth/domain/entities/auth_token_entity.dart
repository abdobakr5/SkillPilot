import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userName;
  final String? email;
  final String? gitHubUsername;
  final bool hasAcceptedTerms;
  final int? onboardingStep;
  final bool isOnboardingCompleted;

  const UserEntity({
    this.userName,
    this.email,
    this.gitHubUsername,
    this.hasAcceptedTerms = false,
    this.onboardingStep,
    this.isOnboardingCompleted = false,
  });

  @override
  List<Object?> get props => [
        userName,
        email,
        gitHubUsername,
        hasAcceptedTerms,
        onboardingStep,
        isOnboardingCompleted,
      ];
}

class AuthTokenEntity extends Equatable {
  final String accessToken;
  final int? expiresInMinutes;
  final String? refreshToken;
  final String? refreshTokenExpiresOnUtc;
  final UserEntity user;

  const AuthTokenEntity({
    required this.accessToken,
    this.expiresInMinutes,
    this.refreshToken,
    this.refreshTokenExpiresOnUtc,
    required this.user,
  });

  @override
  List<Object?> get props => [
        accessToken,
        expiresInMinutes,
        refreshToken,
        refreshTokenExpiresOnUtc,
        user,
      ];
}

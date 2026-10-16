import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
    String? userName,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  Future<bool> validateResetToken({
    required String email,
    required String token,
  });

  Future<void> confirmEmail({
    required String userId,
    required String token,
  });

  Future<AuthResponseModel> loginWithGoogle({
    String? idToken,
    String? accessToken,
  });

  Future<AuthResponseModel> loginWithGitHub({
    required String code,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      data: {
        ApiKeys.email: email,
        ApiKeys.password: password,
      },
    );

    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;

    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    String? userName,
  }) async {
    await apiConsumer.post(
      EndPoints.register,
      data: {
        ApiKeys.email: email,
        ApiKeys.password: password,
        if (userName != null && userName.isNotEmpty) ApiKeys.userName: userName,
      },
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await apiConsumer.post(
      EndPoints.forgotPassword,
      data: {
        ApiKeys.email: email,
      },
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final sanitizedToken = token.trim().replaceAll(' ', '+');
    await apiConsumer.post(
      EndPoints.resetPassword,
      data: {
        ApiKeys.email: email.trim(),
        ApiKeys.token: sanitizedToken,
        ApiKeys.newPassword: newPassword,
      },
    );
  }

  @override
  Future<bool> validateResetToken({
    required String email,
    required String token,
  }) async {
    final sanitizedToken = token.trim().replaceAll(' ', '+');
    final response = await apiConsumer.get(
      EndPoints.resetPassword,
      queryParameters: {
        ApiKeys.email: email.trim(),
        ApiKeys.token: sanitizedToken,
      },
    );
    return response != null;
  }

  @override
  Future<void> confirmEmail({
    required String userId,
    required String token,
  }) async {
    await apiConsumer.post(
      EndPoints.confirmEmail,
      data: {
        ApiKeys.userId: userId,
        ApiKeys.token: token,
      },
    );
  }

  @override
  Future<AuthResponseModel> loginWithGoogle({
    String? idToken,
    String? accessToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.googleLogin,
      data: {
        ApiKeys.idToken: ?idToken,
        ApiKeys.accessToken: ?accessToken,
      },
    );

    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;

    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<AuthResponseModel> loginWithGitHub({
    required String code,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.gitHubLogin,
      data: {
        ApiKeys.code: code,
      },
    );

    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;

    return AuthResponseModel.fromJson(data);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/databases/secure_storage_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../datasources/auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<Either<Failure, Unit>> register({
    required String email,
    required String password,
    String? userName,
  });

  Future<Either<Failure, Unit>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, bool>> validateResetToken({
    required String email,
    required String token,
  });

  Future<Either<Failure, AuthTokenEntity>> loginWithGoogle({
    String? idToken,
    String? accessToken,
  });

  Future<Either<Failure, AuthTokenEntity>> loginWithGitHub({
    required String code,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageHelper secureStorageHelper;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Persist tokens securely
      await secureStorageHelper.saveUserEmail(email);
      if (rememberMe && result.refreshToken != null) {
        await secureStorageHelper.saveTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken!,
        );
      } else {
        await secureStorageHelper.write(
          key: SecureStorageHelper.keyAccessToken,
          value: result.accessToken,
        );
      }

      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String email,
    required String password,
    String? userName,
  }) async {
    try {
      await remoteDataSource.register(
        email: email,
        password: password,
        userName: userName,
      );
      return const Right(unit);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(unit);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateResetToken({
    required String email,
    required String token,
  }) async {
    try {
      final isValid = await remoteDataSource.validateResetToken(
        email: email,
        token: token,
      );
      return Right(isValid);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity>> loginWithGoogle({
    String? idToken,
    String? accessToken,
  }) async {
    try {
      final result = await remoteDataSource.loginWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );

      if (result.refreshToken != null) {
        await secureStorageHelper.saveTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken!,
        );
      } else {
        await secureStorageHelper.write(
          key: SecureStorageHelper.keyAccessToken,
          value: result.accessToken,
        );
      }

      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity>> loginWithGitHub({
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.loginWithGitHub(
        code: code,
      );

      if (result.refreshToken != null) {
        await secureStorageHelper.saveTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken!,
        );
      } else {
        await secureStorageHelper.write(
          key: SecureStorageHelper.keyAccessToken,
          value: result.accessToken,
        );
      }

      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure.fromUnauthorizedException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromNetworkException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

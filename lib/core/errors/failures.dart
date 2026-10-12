import 'package:equatable/equatable.dart';
import 'error_model.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);

  factory ServerFailure.fromServerException(ServerException exception) {
    return ServerFailure(
      exception.errorModel.errorMessage,
      exception.errorModel.statusCode,
    );
  }

  factory ServerFailure.fromErrorModel(ErrorModel errorModel) {
    return ServerFailure(
      errorModel.errorMessage,
      errorModel.statusCode,
    );
  }
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure occurred']);

  factory CacheFailure.fromCacheException(CacheException exception) {
    return CacheFailure(exception.message);
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);

  factory NetworkFailure.fromNetworkException(NetworkException exception) {
    return NetworkFailure(exception.message);
  }
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired, please log in again.']);

  factory UnauthorizedFailure.fromUnauthorizedException(UnauthorizedException exception) {
    return UnauthorizedFailure(exception.message);
  }
}

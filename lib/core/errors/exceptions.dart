import 'error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  const ServerException({required this.errorModel});

  @override
  String toString() => 'ServerException: ${errorModel.errorMessage}';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache failure occurred'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No Internet Connection'});

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Unauthorized request'});

  @override
  String toString() => 'UnauthorizedException: $message';
}

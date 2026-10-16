import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/error_model.dart';
import '../errors/exceptions.dart';
import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio});

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await dio.post(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await dio.put(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await dio.patch(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  /// Translates DioException into domain/data layer typed exceptions
  Never _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.transformTimeout:
        throw const NetworkException(message: 'Connection timeout with the server');

      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          final statusCode = response.statusCode;
          final responseData = response.data;

          if (responseData is Map<String, dynamic>) {
            final errorModel = ErrorModel.fromJson(responseData);
            if (statusCode == HttpStatus.unauthorized) {
              throw UnauthorizedException(
                message: errorModel.errorMessage,
              );
            }
            throw ServerException(
              errorModel: errorModel,
            );
          } else if (statusCode == HttpStatus.unauthorized) {
            throw const UnauthorizedException(
              message: 'Unauthorized access. Please login again.',
            );
          } else if (responseData is String && responseData.isNotEmpty) {
            throw ServerException(
              errorModel: ErrorModel(
                statusCode: statusCode,
                errorMessage: responseData,
              ),
            );
          } else {
            throw ServerException(
              errorModel: ErrorModel(
                statusCode: statusCode,
                errorMessage: response.statusMessage ?? 'Server returned error $statusCode',
              ),
            );
          }
        }
        throw ServerException(
          errorModel: ErrorModel(
            statusCode: error.response?.statusCode,
            errorMessage: 'Received invalid status code from server',
          ),
        );

      case DioExceptionType.cancel:
        throw ServerException(
          errorModel: const ErrorModel(
            errorMessage: 'Request to API server was cancelled',
          ),
        );

      case DioExceptionType.badCertificate:
        throw ServerException(
          errorModel: const ErrorModel(
            errorMessage: 'Bad SSL certificate',
          ),
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw const NetworkException(message: 'No Internet Connection');
        }
        throw ServerException(
          errorModel: ErrorModel(
            errorMessage: error.message ?? 'An unexpected network error occurred',
          ),
        );
    }
  }
}

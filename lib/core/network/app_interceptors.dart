import 'package:dio/dio.dart';
import '../databases/secure_storage_helper.dart';
import 'end_points.dart';

class AppInterceptors extends QueuedInterceptor {
  final SecureStorageHelper secureStorageHelper;
  final Dio dio;

  AppInterceptors({
    required this.secureStorageHelper,
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Inject Bearer token if available and request does not already contain an Authorization header
    final token = await secureStorageHelper.getAccessToken();
    if (token != null &&
        token.isNotEmpty &&
        !options.headers.containsKey(ApiKeys.authorization)) {
      options.headers[ApiKeys.authorization] = '${ApiKeys.bearer}$token';
    }

    options.headers['Accept'] ??= 'application/json';
    options.headers['Content-Type'] ??= 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 Unauthorized and not already retried or coming from the refresh-token endpoint itself
    if (err.response?.statusCode == 401) {
      final isAuthEndpoint = err.requestOptions.path.contains(EndPoints.login) ||
          err.requestOptions.path.contains(EndPoints.refreshToken);

      if (!isAuthEndpoint) {
        final refreshToken = await secureStorageHelper.getRefreshToken();

        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            // Attempt to refresh token using a separate Dio client instance to prevent recursive interceptor loop
            final refreshDio = Dio(
              BaseOptions(
                baseUrl: dio.options.baseUrl,
                connectTimeout: EndPoints.connectTimeout,
                receiveTimeout: EndPoints.receiveTimeout,
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            );

            final response = await refreshDio.post(
              EndPoints.refreshToken,
              data: {
                ApiKeys.refreshToken: refreshToken,
              },
            );

            if (response.statusCode == 200 && response.data != null) {
              final data = response.data;
              final newAccessToken = data[ApiKeys.accessToken] as String? ??
                  data['data']?[ApiKeys.accessToken] as String? ??
                  data[ApiKeys.token] as String?;
              final newRefreshToken = data[ApiKeys.refreshToken] as String? ??
                  data['data']?[ApiKeys.refreshToken] as String? ??
                  refreshToken;

              if (newAccessToken != null) {
                // Update credentials in secure storage
                await secureStorageHelper.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );

                // Update original request with new token and retry
                final originalRequest = err.requestOptions;
                originalRequest.headers[ApiKeys.authorization] =
                    '${ApiKeys.bearer}$newAccessToken';

                final retryResponse = await dio.fetch(originalRequest);
                return handler.resolve(retryResponse);
              }
            }
          } catch (_) {
            // Refresh failed: clear credentials
            await secureStorageHelper.clearTokens();
          }
        } else {
          // No refresh token available: clear credentials
          await secureStorageHelper.clearTokens();
        }
      }
    }

    return handler.next(err);
  }
}

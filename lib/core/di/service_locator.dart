import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../databases/cache_helper.dart';
import '../databases/secure_storage_helper.dart';
import '../network/api_consumer.dart';
import '../network/app_interceptors.dart';
import '../network/dio_consumer.dart';
import '../network/end_points.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/oauth_service.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/setup/data/datasources/profile_remote_data_source.dart';
import '../services/deep_link_service.dart';

final sl = GetIt.instance;

/// Initializes all core service locator dependencies.
/// Call this method before runApp() in main.dart.
Future<void> initServiceLocator() async {
  // ----------------------------------------------------
  // Core Databases & Caching
  // ----------------------------------------------------
  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(),
  );

  // CacheHelper uses static methods backed by SharedPreferences,
  // but registering a factory/singleton instance allows injecting it if desired.
  sl.registerLazySingleton<CacheHelper>(
    () => CacheHelper(),
  );

  // DeepLink Service for handling universal links and custom schemes
  sl.registerLazySingleton<DeepLinkService>(
    () => DeepLinkService(),
  );

  // ----------------------------------------------------
  // Core Network
  // ----------------------------------------------------
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: EndPoints.connectTimeout,
        receiveTimeout: EndPoints.receiveTimeout,
        sendTimeout: EndPoints.sendTimeout,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      sl<AppInterceptors>(),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    ]);

    return dio;
  });

  sl.registerLazySingleton<AppInterceptors>(
    () => AppInterceptors(
      secureStorageHelper: sl<SecureStorageHelper>(),
      dio: Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          connectTimeout: EndPoints.connectTimeout,
          receiveTimeout: EndPoints.receiveTimeout,
        ),
      ),
    ),
  );

  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: sl<Dio>()),
  );

  // ----------------------------------------------------
  // Feature Registrations (Hook for future feature modules)
  // ----------------------------------------------------
  _initFeatures();
}

void _initFeatures() {
  // ----------------------------------------------------
  // Auth Feature Registrations
  // ----------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorageHelper: sl<SecureStorageHelper>(),
    ),
  );

  sl.registerLazySingleton<OAuthService>(
    () => OAuthService(),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(authRepository: sl<AuthRepository>()),
  );

  // ----------------------------------------------------
  // Profile & Onboarding Feature Registrations
  // ----------------------------------------------------
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );
}

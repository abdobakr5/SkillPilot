import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  SecureStorageHelper({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  static const String keyAccessToken = 'ACCESS_TOKEN';
  static const String keyRefreshToken = 'REFRESH_TOKEN';
  static const String keyUserId = 'USER_ID';

  /// Write a key-value pair securely
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secure key
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Delete a secure key
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Delete all stored credentials
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if a secure key exists
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }

  // Token management convenience helpers
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      write(key: keyAccessToken, value: accessToken),
      write(key: keyRefreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() async {
    return await read(key: keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await read(key: keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      delete(key: keyAccessToken),
      delete(key: keyRefreshToken),
    ]);
  }
}

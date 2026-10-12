import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  /// Initializes SharedPreferences instance.
  /// Must be called before accessing cache methods (e.g. in `main()`).
  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  /// Check whether the cache contains a given key
  static bool containsKey(String key) {
    return _sharedPreferences?.containsKey(key) ?? false;
  }

  /// Generic getter for cached values
  static dynamic getData({required String key}) {
    return _sharedPreferences?.get(key);
  }

  /// Specific typed getters
  static String? getString({required String key}) {
    return _sharedPreferences?.getString(key);
  }

  static bool? getBool({required String key}) {
    return _sharedPreferences?.getBool(key);
  }

  static int? getInt({required String key}) {
    return _sharedPreferences?.getInt(key);
  }

  static double? getDouble({required String key}) {
    return _sharedPreferences?.getDouble(key);
  }

  static List<String>? getStringList({required String key}) {
    return _sharedPreferences?.getStringList(key);
  }

  /// Saves any supported primitive value to SharedPreferences
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (_sharedPreferences == null) {
      await init();
    }

    if (value is String) {
      return await _sharedPreferences!.setString(key, value);
    }
    if (value is int) {
      return await _sharedPreferences!.setInt(key, value);
    }
    if (value is bool) {
      return await _sharedPreferences!.setBool(key, value);
    }
    if (value is double) {
      return await _sharedPreferences!.setDouble(key, value);
    }
    if (value is List<String>) {
      return await _sharedPreferences!.setStringList(key, value);
    }

    throw ArgumentError(
      'Unsupported type for SharedPreferences: ${value.runtimeType}',
    );
  }

  /// Removes data for the specified key
  static Future<bool> removeData({required String key}) async {
    if (_sharedPreferences == null) {
      await init();
    }
    return await _sharedPreferences!.remove(key);
  }

  /// Clears all stored preferences
  static Future<bool> clearData() async {
    if (_sharedPreferences == null) {
      await init();
    }
    return await _sharedPreferences!.clear();
  }
}

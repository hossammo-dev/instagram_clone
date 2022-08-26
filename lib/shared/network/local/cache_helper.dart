import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _shared;

  static Future<void> init() async => _shared = await SharedPreferences.getInstance();

  static Future<bool> save({required String key, required dynamic data}) async {
    // ignore: unnecessary_type_check
    if (key is String) return await _shared.setString(key, data);
    if (key is bool) return await _shared.setBool(key, data);
    if (key is double) return await _shared.setDouble(key, data);
    return await _shared.setInt(key, data);
  }

  static dynamic get(String key) => _shared.get(key);

  static Future<bool> remove(String key) async => await _shared.remove(key);
}

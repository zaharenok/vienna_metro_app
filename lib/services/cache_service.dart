import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const int _cacheExpirationSeconds = 25;

  static Future<void> saveCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(key, jsonEncode(cacheData));
  }

  static Future<Map<String, dynamic>?> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheString = prefs.getString(key);
    
    if (cacheString == null) return null;

    try {
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      final ageSeconds = (now - timestamp) / 1000;
      
      if (ageSeconds > _cacheExpirationSeconds) {
        await prefs.remove(key);
        return null;
      }

      return {
        'data': cacheData['data'],
        'age': ageSeconds.round(),
      };
    } catch (e) {
      await prefs.remove(key);
      return null;
    }
  }

  static Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const Duration defaultTtl = Duration(minutes: 5);

  static Future<void> save(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
    await prefs.setInt('${key}_ts', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<dynamic> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }
}
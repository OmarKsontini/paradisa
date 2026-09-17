import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _baseUrlKey = 'api_base_url';
  static const String defaultBaseUrl = 'http://100.88.191.8:8000';

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey) ?? defaultBaseUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    // strip a trailing slash so "$baseUrl/subjects" never ends up as "//subjects"
    final cleaned = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    await prefs.setString(_baseUrlKey, cleaned);
  }
}
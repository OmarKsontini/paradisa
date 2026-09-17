import 'package:http/http.dart' as http;
import 'api_service.dart';

class ConnectivityService {
  static Future<bool> isOnline() async {
    try {
      final res = await http
          .get(Uri.parse('${ApiService.baseUrl}/subjects'))
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200 || res.statusCode == 404;
    } catch (_) {
      return false;
    }
  }
}
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String? accessToken;
  static const String _tokenKey = 'access-token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    accessToken = token;
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    accessToken = null;
  }

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;
}
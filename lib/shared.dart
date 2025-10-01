import 'package:attendance_app_training/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveLoginState() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setBool(Constants.isUserLoggedIn, true);
// }

// Future<void> logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove(Constants.isUserLoggedIn);
// }

Future<void> saveLoginState(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(Constants.kAccessToken, accessToken);
  await prefs.setString(Constants.kRefreshToken, refreshToken);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(Constants.kAccessToken);
  await prefs.remove(Constants.kRefreshToken);
}

Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Constants.kAccessToken);
}

Future<String?> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Constants.kRefreshToken);
}

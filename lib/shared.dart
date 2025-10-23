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

Future<void> saveLoginState(
  String accessToken,
  String refreshToken,
  bool isSuperAdmin,
) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(Constants.kAccessToken, accessToken);
  await prefs.setString(Constants.kRefreshToken, refreshToken);
  await prefs.setBool(Constants.kIsSuperAdmin, isSuperAdmin);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(Constants.kAccessToken);
  await prefs.remove(Constants.kRefreshToken);
  await prefs.remove(Constants.kIsSuperAdmin);
}

Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Constants.kAccessToken);
}

Future<String?> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Constants.kRefreshToken);
}

Future<bool> getIsSuperAdmin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(Constants.kIsSuperAdmin) ?? false;
}

import 'package:attendance_app_training/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(Constants.isUserLoggedIn, true);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(Constants.isUserLoggedIn);
}

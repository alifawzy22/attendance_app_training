import 'package:attendance_app_training/login_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginState(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('username', username);
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("isLoggedIn");
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginView()),
  );
}

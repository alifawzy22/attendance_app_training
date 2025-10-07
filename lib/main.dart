import 'dart:io';

import 'package:attendance_app_training/data_user_info.dart';
import 'package:attendance_app_training/home_view.dart';
import 'package:attendance_app_training/login_view.dart';
import 'package:flutter/material.dart';
import 'shared.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await getAccessToken();
  final bool isLoggedIn = token != null && token.isNotEmpty;
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Alexandria'),
      title: "حضور التدريب",
      home: isLoggedIn ? const HomeView() : const LoginView(),
    );
  }
}

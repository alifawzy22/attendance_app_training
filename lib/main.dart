import 'package:flutter/material.dart';

import 'login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "حضور التدريب", home: LoginView());
  }
}

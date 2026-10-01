import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SenaiCheckInApp());
}

class SenaiCheckInApp extends StatelessWidget {
  const SenaiCheckInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAI Ponto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF005CAA)),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

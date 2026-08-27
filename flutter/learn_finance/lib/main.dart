import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const LearnFinanceApp());
}

class LearnFinanceApp extends StatelessWidget {
  const LearnFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnFinance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorSchemeSeed: const Color(0xFF10B981),
      ),
      home: const LandingScreen(),
    );
  }
}

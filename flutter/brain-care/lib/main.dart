import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'logic/brain_care_controller.dart';
import 'presentation/screens/home_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrainCareApp());
}

class BrainCareApp extends StatefulWidget {
  const BrainCareApp({super.key});

  @override
  State<BrainCareApp> createState() => _BrainCareAppState();
}

class _BrainCareAppState extends State<BrainCareApp> {
  late BrainCareController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BrainCareController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainCare — Neuroplasticity & Cognitive Reserve',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: HomeDashboardScreen(controller: _controller),
    );
  }
}

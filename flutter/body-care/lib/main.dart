import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'data/services/local_storage_service.dart';
import 'data/repositories/health_repository.dart';
import 'logic/health_dashboard_controller.dart';
import 'logic/movement_timer_controller.dart';
import 'presentation/screens/home_dashboard_screen.dart';
import 'presentation/screens/risk_profile_screen.dart';
import 'presentation/screens/habits_screen.dart';
import 'presentation/screens/environment_screen.dart';
import 'presentation/screens/movement_timer_screen.dart';
import 'presentation/screens/screening_vault_screen.dart';
import 'presentation/screens/skin_map_screen.dart';
import 'presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorageService.init();
  final repository = HealthRepository(storageService: storage);
  final healthController = HealthDashboardController(repository);
  final movementController = MovementTimerController();

  runApp(BodyCareApp(
    healthController: healthController,
    movementController: movementController,
  ));
}

class BodyCareApp extends StatelessWidget {
  final HealthDashboardController healthController;
  final MovementTimerController movementController;

  const BodyCareApp({
    super.key,
    required this.healthController,
    required this.movementController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: healthController,
      builder: (context, _) {
        return MaterialApp(
          title: 'BodyCare: Longevity & Preventative Health',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: healthController.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: MainNavScaffold(
            healthController: healthController,
            movementController: movementController,
          ),
        );
      },
    );
  }
}

class MainNavScaffold extends StatefulWidget {
  final HealthDashboardController healthController;
  final MovementTimerController movementController;

  const MainNavScaffold({
    super.key,
    required this.healthController,
    required this.movementController,
  });

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final hc = widget.healthController;
    final tc = widget.movementController;

    final screens = [
      HomeDashboardScreen(
        controller: hc,
        onNavigateTab: (index) => _onTabTapped(index),
      ),
      HabitsScreen(controller: hc),
      EnvironmentScreen(controller: hc),
      ScreeningVaultScreen(controller: hc),
      MovementTimerScreen(timerController: tc, healthController: hc),
      SkinMapScreen(controller: hc),
      RiskProfileScreen(controller: hc),
      SettingsScreen(controller: hc),
    ];

    String screenTitle;
    switch (_currentIndex) {
      case 0:
        screenTitle = 'BodyCare Longevity';
        break;
      case 1:
        screenTitle = 'Preventative Habits';
        break;
      case 2:
        screenTitle = 'UV & Environment';
        break;
      case 3:
        screenTitle = 'Screening Vault';
        break;
      case 4:
        screenTitle = 'Movement & Posture';
        break;
      case 5:
        screenTitle = 'Mole & Skin Map';
        break;
      case 6:
        screenTitle = 'Risk & Biomarkers';
        break;
      case 7:
        screenTitle = 'Settings & Evidence';
        break;
      default:
        screenTitle = 'BodyCare';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primaryLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              screenTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentIndex == 6 ? Icons.shield_rounded : Icons.shield_outlined,
              color: _currentIndex == 6 ? AppColors.primaryLight : null,
            ),
            tooltip: 'Personal Risk & Baseline',
            onPressed: () => _onTabTapped(6),
          ),
          IconButton(
            icon: Icon(
              _currentIndex == 7 ? Icons.settings_rounded : Icons.settings_outlined,
              color: _currentIndex == 7 ? AppColors.primaryLight : null,
            ),
            tooltip: 'Settings & Evidence',
            onPressed: () => _onTabTapped(7),
          ),
        ],
      ),
      body: SafeArea(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 5 ? 0 : _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondaryDark,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_rounded),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_rounded),
            label: 'UV & Sun',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'Movement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_rounded),
            label: 'Skin Map',
          ),
        ],
      ),
    );
  }
}

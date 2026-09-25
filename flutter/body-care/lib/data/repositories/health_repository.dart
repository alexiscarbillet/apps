import '../models/user_profile_model.dart';
import '../models/habit_log_model.dart';
import '../models/uv_data_model.dart';
import '../models/screening_model.dart';
import '../models/mole_record_model.dart';
import '../services/local_storage_service.dart';
import '../services/uv_api_service.dart';

class HealthRepository {
  final LocalStorageService storageService;
  final UvApiService _uvApiService;

  HealthRepository({
    required this.storageService,
    UvApiService? uvApiService,
  }) : _uvApiService = uvApiService ?? UvApiService();

  // --- USER PROFILE & RISK DASHBOARD ---
  UserProfile getUserProfile() => storageService.loadUserProfile();
  Future<void> saveUserProfile(UserProfile profile) => storageService.saveUserProfile(profile);

  // --- HABIT LOGS ---
  Map<String, DailyHabitLog> getHabitLogs() => storageService.loadHabitLogs();

  DailyHabitLog getTodayHabitLog() {
    final now = DateTime.now();
    final key = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final map = storageService.loadHabitLogs();
    return map[key] ?? DailyHabitLog(dateKey: key);
  }

  Future<void> saveTodayHabitLog(DailyHabitLog log) => storageService.saveHabitLog(log);

  // --- UV ENVIRONMENT ---
  UvEnvironmentData getCachedUvData() => storageService.loadUvData();

  Future<UvEnvironmentData> refreshUvData({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    final fresh = await _uvApiService.fetchUvData(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
    );
    await storageService.saveUvData(fresh);
    return fresh;
  }

  Future<void> updateSunscreenApplied(DateTime timestamp) async {
    final current = getCachedUvData();
    final updated = current.copyWith(sunscreenAppliedAt: timestamp);
    await storageService.saveUvData(updated);

    // Also update today's habit log for UV protection
    final today = getTodayHabitLog();
    await saveTodayHabitLog(today.copyWith(sunscreenApplied: true));
  }

  // --- MEDICAL SCREENINGS ---
  List<MedicalScreening> getScreenings() => storageService.loadScreenings();
  Future<void> saveScreenings(List<MedicalScreening> screenings) => storageService.saveScreenings(screenings);

  // --- MOLE RECORDS ---
  List<MoleRecord> getMoleRecords() => storageService.loadMoleRecords();
  Future<void> saveMoleRecords(List<MoleRecord> moles) => storageService.saveMoleRecords(moles);

  // --- SETTINGS ---
  bool isDarkTheme() => storageService.isDarkTheme();
  Future<void> setDarkTheme(bool isDark) => storageService.setDarkTheme(isDark);

  int getSedentaryIntervalMinutes() => storageService.getSedentaryIntervalMinutes();
  Future<void> setSedentaryIntervalMinutes(int minutes) =>
      storageService.setSedentaryIntervalMinutes(minutes);

  Future<void> resetAllData() => storageService.resetToDefaults();
}

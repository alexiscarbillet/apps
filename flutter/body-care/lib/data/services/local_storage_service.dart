import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import '../models/habit_log_model.dart';
import '../models/uv_data_model.dart';
import '../models/screening_model.dart';
import '../models/mole_record_model.dart';

class LocalStorageService {
  static const String _keyProfile = 'body_care_user_profile';
  static const String _keyHabitLogs = 'body_care_habit_logs';
  static const String _keyUvData = 'body_care_uv_data';
  static const String _keyScreenings = 'body_care_screenings';
  static const String _keyMoleRecords = 'body_care_mole_records';
  static const String _keyDarkTheme = 'body_care_dark_theme';
  static const String _keySedentaryGoal = 'body_care_sedentary_goal';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // --- USER PROFILE & RISK DASHBOARD ---
  UserProfile loadUserProfile() {
    final raw = _prefs.getString(_keyProfile);
    if (raw == null) {
      final defaultProf = UserProfile.defaultProfile();
      saveUserProfile(defaultProf);
      return defaultProf;
    }
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UserProfile.defaultProfile();
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  // --- HABIT LOGS ---
  Map<String, DailyHabitLog> loadHabitLogs() {
    final raw = _prefs.getString(_keyHabitLogs);
    if (raw == null) {
      // Seed past 7 days of realistic habit logs for rich initial visual charts
      final initialLogs = _seedInitialHabitLogs();
      saveAllHabitLogs(initialLogs);
      return initialLogs;
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final map = <String, DailyHabitLog>{};
      decoded.forEach((key, value) {
        map[key] = DailyHabitLog.fromJson(value as Map<String, dynamic>);
      });
      return map;
    } catch (_) {
      return _seedInitialHabitLogs();
    }
  }

  Future<void> saveHabitLog(DailyHabitLog log) async {
    final current = loadHabitLogs();
    current[log.dateKey] = log;
    await saveAllHabitLogs(current);
  }

  Future<void> saveAllHabitLogs(Map<String, DailyHabitLog> logs) async {
    final map = <String, dynamic>{};
    logs.forEach((key, value) => map[key] = value.toJson());
    await _prefs.setString(_keyHabitLogs, jsonEncode(map));
  }

  // --- UV ENVIRONMENT DATA ---
  UvEnvironmentData loadUvData() {
    final raw = _prefs.getString(_keyUvData);
    if (raw == null) return UvEnvironmentData.mockDefault();
    try {
      return UvEnvironmentData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UvEnvironmentData.mockDefault();
    }
  }

  Future<void> saveUvData(UvEnvironmentData data) async {
    await _prefs.setString(_keyUvData, jsonEncode(data.toJson()));
  }

  // --- MEDICAL SCREENINGS ---
  List<MedicalScreening> loadScreenings() {
    final raw = _prefs.getString(_keyScreenings);
    if (raw == null) {
      final defaults = MedicalScreening.defaultScreenings();
      saveScreenings(defaults);
      return defaults;
    }
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => MedicalScreening.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return MedicalScreening.defaultScreenings();
    }
  }

  Future<void> saveScreenings(List<MedicalScreening> screenings) async {
    final list = screenings.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyScreenings, jsonEncode(list));
  }

  // --- MOLE & SKIN MAP ---
  List<MoleRecord> loadMoleRecords() {
    final raw = _prefs.getString(_keyMoleRecords);
    if (raw == null) {
      final defaults = MoleRecord.defaultMoleRecords();
      saveMoleRecords(defaults);
      return defaults;
    }
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => MoleRecord.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return MoleRecord.defaultMoleRecords();
    }
  }

  Future<void> saveMoleRecords(List<MoleRecord> moles) async {
    final list = moles.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyMoleRecords, jsonEncode(list));
  }

  // --- PREFERENCES ---
  bool isDarkTheme() => _prefs.getBool(_keyDarkTheme) ?? true;
  Future<void> setDarkTheme(bool isDark) async => await _prefs.setBool(_keyDarkTheme, isDark);

  int getSedentaryIntervalMinutes() => _prefs.getInt(_keySedentaryGoal) ?? 45;
  Future<void> setSedentaryIntervalMinutes(int minutes) async =>
      await _prefs.setInt(_keySedentaryGoal, minutes);

  Future<void> resetToDefaults() async {
    await _prefs.clear();
  }

  Map<String, DailyHabitLog> _seedInitialHabitLogs() {
    final now = DateTime.now();
    final map = <String, DailyHabitLog>{};
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (i == 0) {
        // Today
        map[key] = DailyHabitLog(
          dateKey: key,
          leafyGreensServings: 2,
          noUpfMeals: 2,
          alcoholUnits: 0.0,
          waterGlasses: 6,
          standingBreaks: 4,
          sunscreenApplied: true,
          resistanceTrained: true,
          notes: 'Great energy today. Zone 2 session completed.',
        );
      } else {
        // Past days with varying adherence
        map[key] = DailyHabitLog(
          dateKey: key,
          leafyGreensServings: (i % 2 == 0) ? 3 : 2,
          noUpfMeals: 3,
          alcoholUnits: (i == 5) ? 1.0 : 0.0,
          waterGlasses: 7 + (i % 2),
          standingBreaks: 5 + (i % 2),
          sunscreenApplied: true,
          resistanceTrained: i % 2 == 1,
          notes: 'Focusing on preventative habits.',
        );
      }
    }
    return map;
  }
}

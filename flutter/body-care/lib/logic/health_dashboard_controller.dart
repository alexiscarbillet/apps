import 'package:flutter/material.dart';
import '../data/models/user_profile_model.dart';
import '../data/models/habit_log_model.dart';
import '../data/models/uv_data_model.dart';
import '../data/models/screening_model.dart';
import '../data/models/mole_record_model.dart';
import '../data/repositories/health_repository.dart';

class HealthDashboardController extends ChangeNotifier {
  final HealthRepository _repository;

  HealthDashboardController(this._repository) {
    loadAllData();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isDarkTheme = true;
  bool get isDarkTheme => _isDarkTheme;

  UserProfile _userProfile = UserProfile.defaultProfile();
  UserProfile get userProfile => _userProfile;

  DailyHabitLog _todayLog = const DailyHabitLog(dateKey: '');
  DailyHabitLog get todayLog => _todayLog;

  Map<String, DailyHabitLog> _habitHistory = {};
  Map<String, DailyHabitLog> get habitHistory => _habitHistory;

  UvEnvironmentData _uvData = UvEnvironmentData.mockDefault();
  UvEnvironmentData get uvData => _uvData;

  List<MedicalScreening> _screenings = [];
  List<MedicalScreening> get screenings => _screenings;

  List<MoleRecord> _moleRecords = [];
  List<MoleRecord> get moleRecords => _moleRecords;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    _isDarkTheme = _repository.isDarkTheme();
    _userProfile = _repository.getUserProfile();
    _todayLog = _repository.getTodayHabitLog();
    _habitHistory = _repository.getHabitLogs();
    _uvData = _repository.getCachedUvData();
    _screenings = _repository.getScreenings();
    _moleRecords = _repository.getMoleRecords();

    _isLoading = false;
    notifyListeners();

    // Proactively fetch live UV data in the background
    refreshUvData();
  }

  // --- LONGEVITY METRICS & SCORING ---
  /// Composite Longevity Score combining Daily Habits (50%), UV adherence (15%), Screenings compliance (20%), and Movement (15%)
  double get longevityScore {
    double score = 0.0;

    // 1. Habit Adherence (50 pts max)
    score += (_todayLog.adherenceScore / 100.0) * 50.0;

    // 2. Screening Timeliness (25 pts max)
    final overdueCount = _screenings.where((s) => s.isOverdue).length;
    if (_screenings.isNotEmpty) {
      final ratio = (_screenings.length - overdueCount) / _screenings.length;
      score += ratio * 25.0;
    } else {
      score += 25.0;
    }

    // 3. Preventative Mole/Skin Self-Check (15 pts max)
    final recentlyChecked = _moleRecords.where((m) =>
        DateTime.now().difference(m.lastCheckedDate).inDays <= 90).length;
    if (_moleRecords.isNotEmpty) {
      score += (recentlyChecked / _moleRecords.length) * 15.0;
    } else {
      score += 15.0;
    }

    // 4. UV Safety Adherence (10 pts max)
    if (_todayLog.sunscreenApplied || _uvData.currentUv < 3.0) {
      score += 10.0;
    }

    return score.clamp(0.0, 100.0);
  }

  List<DailyHabitLog> get last7DaysLogs {
    final now = DateTime.now();
    final list = <DailyHabitLog>[];
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      list.add(_habitHistory[key] ?? DailyHabitLog(dateKey: key));
    }
    return list;
  }

  int get currentStreakDays {
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final d = now.subtract(Duration(days: i));
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      final log = _habitHistory[key];
      if (log != null && log.adherenceScore >= 50.0) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  // --- HABIT MODIFIERS ---
  Future<void> incrementLeafyGreens() async {
    _todayLog = _todayLog.copyWith(leafyGreensServings: _todayLog.leafyGreensServings + 1);
    await _saveTodayLog();
  }

  Future<void> decrementLeafyGreens() async {
    if (_todayLog.leafyGreensServings > 0) {
      _todayLog = _todayLog.copyWith(leafyGreensServings: _todayLog.leafyGreensServings - 1);
      await _saveTodayLog();
    }
  }

  Future<void> incrementNoUpfMeals() async {
    _todayLog = _todayLog.copyWith(noUpfMeals: _todayLog.noUpfMeals + 1);
    await _saveTodayLog();
  }

  Future<void> decrementNoUpfMeals() async {
    if (_todayLog.noUpfMeals > 0) {
      _todayLog = _todayLog.copyWith(noUpfMeals: _todayLog.noUpfMeals - 1);
      await _saveTodayLog();
    }
  }

  Future<void> setAlcoholUnits(double units) async {
    _todayLog = _todayLog.copyWith(alcoholUnits: units);
    await _saveTodayLog();
  }

  Future<void> incrementWater() async {
    _todayLog = _todayLog.copyWith(waterGlasses: _todayLog.waterGlasses + 1);
    await _saveTodayLog();
  }

  Future<void> decrementWater() async {
    if (_todayLog.waterGlasses > 0) {
      _todayLog = _todayLog.copyWith(waterGlasses: _todayLog.waterGlasses - 1);
      await _saveTodayLog();
    }
  }

  Future<void> incrementStandingBreaks() async {
    _todayLog = _todayLog.copyWith(standingBreaks: _todayLog.standingBreaks + 1);
    await _saveTodayLog();
  }

  Future<void> toggleResistanceTrained() async {
    _todayLog = _todayLog.copyWith(resistanceTrained: !_todayLog.resistanceTrained);
    await _saveTodayLog();
  }

  Future<void> updateNotes(String notes) async {
    _todayLog = _todayLog.copyWith(notes: notes);
    await _saveTodayLog();
  }

  Future<void> logSunscreenApplication() async {
    final now = DateTime.now();
    await _repository.updateSunscreenApplied(now);
    _uvData = _repository.getCachedUvData();
    _todayLog = _repository.getTodayHabitLog();
    _habitHistory = _repository.getHabitLogs();
    notifyListeners();
  }

  Future<void> _saveTodayLog() async {
    await _repository.saveTodayHabitLog(_todayLog);
    _habitHistory[_todayLog.dateKey] = _todayLog;
    notifyListeners();
  }

  // --- UV REFRESH ---
  Future<void> refreshUvData() async {
    try {
      final updated = await _repository.refreshUvData(
        latitude: _uvData.latitude,
        longitude: _uvData.longitude,
        locationName: _uvData.locationName,
      );
      _uvData = updated;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> updateLocation({
    required String name,
    required double latitude,
    required double longitude,
  }) async {
    _uvData = _uvData.copyWith(
      locationName: name,
      latitude: latitude,
      longitude: longitude,
    );
    await _repository.refreshUvData(
      latitude: latitude,
      longitude: longitude,
      locationName: name,
    );
    _uvData = _repository.getCachedUvData();
    notifyListeners();
  }

  // --- USER PROFILE & "WHY" UPDATES ---
  Future<void> updatePersonalWhy(String newWhy) async {
    _userProfile = _userProfile.copyWith(personalWhy: newWhy);
    await _repository.saveUserProfile(_userProfile);
    notifyListeners();
  }

  Future<void> updateUserProfile(UserProfile updated) async {
    _userProfile = updated;
    await _repository.saveUserProfile(_userProfile);
    notifyListeners();
  }

  Future<void> addRiskFactor(RiskFactor rf) async {
    final updatedList = List<RiskFactor>.from(_userProfile.riskFactors)..add(rf);
    _userProfile = _userProfile.copyWith(riskFactors: updatedList);
    await _repository.saveUserProfile(_userProfile);
    notifyListeners();
  }

  Future<void> removeRiskFactor(String id) async {
    final updatedList = _userProfile.riskFactors.where((rf) => rf.id != id).toList();
    _userProfile = _userProfile.copyWith(riskFactors: updatedList);
    await _repository.saveUserProfile(_userProfile);
    notifyListeners();
  }

  Future<void> addLabMarker(LabMarker marker) async {
    final updatedList = List<LabMarker>.from(_userProfile.baselineLabs)..add(marker);
    _userProfile = _userProfile.copyWith(baselineLabs: updatedList);
    await _repository.saveUserProfile(_userProfile);
    notifyListeners();
  }

  // --- MEDICAL SCREENINGS ---
  Future<void> addScreening(MedicalScreening screening) async {
    _screenings.add(screening);
    await _repository.saveScreenings(_screenings);
    notifyListeners();
  }

  Future<void> updateScreening(MedicalScreening updated) async {
    final index = _screenings.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _screenings[index] = updated;
      await _repository.saveScreenings(_screenings);
      notifyListeners();
    }
  }

  Future<void> markScreeningCompleted(String id, DateTime date) async {
    final index = _screenings.indexWhere((s) => s.id == id);
    if (index != -1) {
      final s = _screenings[index];
      final nextDue = date.add(Duration(days: s.frequencyMonths * 30));
      _screenings[index] = s.copyWith(
        status: ScreeningStatus.completed,
        lastCompletedDate: date,
        nextDueDate: nextDue,
      );
      await _repository.saveScreenings(_screenings);
      notifyListeners();
    }
  }

  // --- MOLE & SKIN MAP ---
  Future<void> addMoleRecord(MoleRecord mole) async {
    _moleRecords.add(mole);
    await _repository.saveMoleRecords(_moleRecords);
    notifyListeners();
  }

  Future<void> updateMoleRecord(MoleRecord mole) async {
    final index = _moleRecords.indexWhere((m) => m.id == mole.id);
    if (index != -1) {
      _moleRecords[index] = mole;
      await _repository.saveMoleRecords(_moleRecords);
      notifyListeners();
    }
  }

  Future<void> deleteMoleRecord(String id) async {
    _moleRecords.removeWhere((m) => m.id == id);
    await _repository.saveMoleRecords(_moleRecords);
    notifyListeners();
  }

  // --- THEME ---
  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _repository.setDarkTheme(_isDarkTheme);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _repository.resetAllData();
    await loadAllData();
  }
}

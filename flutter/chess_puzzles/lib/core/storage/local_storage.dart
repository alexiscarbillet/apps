import 'package:shared_preferences/shared_preferences.dart';
import '../theme/board_themes.dart';

class LocalStorage {
  static const _keySolvedPuzzles = 'solved_puzzles';
  static const _keyDailyDate = 'daily_date';
  static const _keyDailyCompletedIndices = 'daily_completed_indices';
  static const _keyDailyStreak = 'daily_streak';
  static const _keyLongestStreak = 'longest_streak';
  static const _keyLastDailyCompletedDate = 'last_daily_completed_date';
  static const _keyPuzzleRushHighScore = 'puzzle_rush_high_score';
  static const _keyBoardTheme = 'board_theme';
  static const _keySoundEnabled = 'sound_enabled';
  static const _keyHapticsEnabled = 'haptics_enabled';
  static const _keyShowCoordinates = 'show_coordinates';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Solved Puzzles
  static Set<String> getSolvedPuzzles() {
    final list = _prefs?.getStringList(_keySolvedPuzzles) ?? [];
    return list.toSet();
  }

  static Future<void> markPuzzleSolved(String puzzleId) async {
    final solved = getSolvedPuzzles()..add(puzzleId);
    await _prefs?.setStringList(_keySolvedPuzzles, solved.toList());
  }

  static bool isPuzzleSolved(String puzzleId) {
    return getSolvedPuzzles().contains(puzzleId);
  }

  // Daily 5 Puzzles
  static String getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static List<int> getDailyCompletedIndices() {
    final savedDate = _prefs?.getString(_keyDailyDate);
    final today = getTodayKey();
    if (savedDate != today) {
      return [];
    }
    final list = _prefs?.getStringList(_keyDailyCompletedIndices) ?? [];
    return list.map(int.parse).toList();
  }

  static Future<void> markDailyPuzzleCompleted(int index) async {
    final today = getTodayKey();
    final savedDate = _prefs?.getString(_keyDailyDate);
    List<int> currentIndices = [];
    if (savedDate == today) {
      currentIndices = getDailyCompletedIndices();
    }
    if (!currentIndices.contains(index)) {
      currentIndices.add(index);
    }

    await _prefs?.setString(_keyDailyDate, today);
    await _prefs?.setStringList(
        _keyDailyCompletedIndices, currentIndices.map((i) => i.toString()).toList());

    // If all 5 completed today, update streak
    if (currentIndices.length >= 5) {
      await _checkAndUpdateDailyStreak();
    }
  }

  static Future<void> _checkAndUpdateDailyStreak() async {
    final today = getTodayKey();
    final lastDate = _prefs?.getString(_keyLastDailyCompletedDate);
    if (lastDate == today) return; // Already rewarded today

    int currentStreak = _prefs?.getInt(_keyDailyStreak) ?? 0;
    int longestStreak = _prefs?.getInt(_keyLongestStreak) ?? 0;

    if (lastDate != null) {
      final last = DateTime.tryParse(lastDate);
      final now = DateTime.now();
      if (last != null) {
        final diff = DateTime(now.year, now.month, now.day)
            .difference(DateTime(last.year, last.month, last.day))
            .inDays;
        if (diff == 1) {
          currentStreak++;
        } else if (diff > 1) {
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    await _prefs?.setInt(_keyDailyStreak, currentStreak);
    await _prefs?.setInt(_keyLongestStreak, longestStreak);
    await _prefs?.setString(_keyLastDailyCompletedDate, today);
  }

  static int getDailyStreak() => _prefs?.getInt(_keyDailyStreak) ?? 0;
  static int getLongestStreak() => _prefs?.getInt(_keyLongestStreak) ?? 0;
  static bool isDailyCompletedToday() {
    final lastDate = _prefs?.getString(_keyLastDailyCompletedDate);
    return lastDate == getTodayKey() && getDailyCompletedIndices().length >= 5;
  }

  // Puzzle Rush
  static int getPuzzleRushHighScore() => _prefs?.getInt(_keyPuzzleRushHighScore) ?? 0;

  static Future<bool> savePuzzleRushScore(int score) async {
    final high = getPuzzleRushHighScore();
    if (score > high) {
      await _prefs?.setInt(_keyPuzzleRushHighScore, score);
      return true;
    }
    return false;
  }

  // Settings
  static BoardThemeType getBoardTheme() {
    final index = _prefs?.getInt(_keyBoardTheme) ?? 0;
    if (index >= 0 && index < BoardThemeType.values.length) {
      return BoardThemeType.values[index];
    }
    return BoardThemeType.walnut;
  }

  static Future<void> setBoardTheme(BoardThemeType theme) async {
    await _prefs?.setInt(_keyBoardTheme, theme.index);
  }

  static bool getSoundEnabled() => _prefs?.getBool(_keySoundEnabled) ?? true;
  static Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  static bool getHapticsEnabled() => _prefs?.getBool(_keyHapticsEnabled) ?? true;
  static Future<void> setHapticsEnabled(bool enabled) async {
    await _prefs?.setBool(_keyHapticsEnabled, enabled);
  }

  static bool getShowCoordinates() => _prefs?.getBool(_keyShowCoordinates) ?? true;
  static Future<void> setShowCoordinates(bool enabled) async {
    await _prefs?.setBool(_keyShowCoordinates, enabled);
  }
}

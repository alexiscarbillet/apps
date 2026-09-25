import 'package:flutter/foundation.dart';
import '../data/models/puzzle_model.dart';
import '../data/puzzle_database.dart';
import '../core/storage/local_storage.dart';

class DailyPuzzleController extends ChangeNotifier {
  late List<ChessPuzzle> _dailyPuzzles;
  int _currentIndex = 0;
  List<int> _completedIndices = [];

  DailyPuzzleController() {
    loadTodayPuzzles();
  }

  List<ChessPuzzle> get dailyPuzzles => _dailyPuzzles;
  int get currentIndex => _currentIndex;
  List<int> get completedIndices => _completedIndices;
  ChessPuzzle get currentPuzzle => _dailyPuzzles[_currentIndex];
  bool get isAllCompleted => _completedIndices.length >= 5;
  int get completedCount => _completedIndices.length;

  void loadTodayPuzzles() {
    _dailyPuzzles = PuzzleDatabase.getDaily5Puzzles(DateTime.now());
    _completedIndices = LocalStorage.getDailyCompletedIndices();

    // Select first unsolved puzzle
    _currentIndex = 0;
    for (int i = 0; i < _dailyPuzzles.length; i++) {
      if (!_completedIndices.contains(i)) {
        _currentIndex = i;
        break;
      }
    }
    notifyListeners();
  }

  void selectPuzzleIndex(int index) {
    if (index >= 0 && index < _dailyPuzzles.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<void> markCurrentCompleted() async {
    if (!_completedIndices.contains(_currentIndex)) {
      _completedIndices.add(_currentIndex);
      await LocalStorage.markDailyPuzzleCompleted(_currentIndex);
      notifyListeners();
    }
  }

  void nextPuzzle() {
    if (_currentIndex < _dailyPuzzles.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousPuzzle() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }
}

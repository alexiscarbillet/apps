import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/puzzle_model.dart';
import '../data/random_puzzle_generator.dart';
import '../core/storage/local_storage.dart';
import 'puzzle_controller.dart';

enum PuzzleRushMode { survival3Strikes, blitz3Minutes }

class PuzzleRushController extends ChangeNotifier {
  final PuzzleRushMode mode;
  List<ChessPuzzle> _queue = [];
  int _currentIndex = 0;
  int _score = 0;
  int _strikes = 0;
  final int _maxStrikes = 3;
  int _timeRemainingSeconds = 180;
  bool _isGameOver = false;
  bool _isNewHighScore = false;
  Timer? _timer;
  late PuzzleController _currentPuzzleController;

  PuzzleRushController({this.mode = PuzzleRushMode.survival3Strikes}) {
    startNewGame();
  }

  int get score => _score;
  int get strikes => _strikes;
  int get maxStrikes => _maxStrikes;
  int get timeRemainingSeconds => _timeRemainingSeconds;
  bool get isGameOver => _isGameOver;
  bool get isNewHighScore => _isNewHighScore;
  PuzzleController get currentPuzzleController => _currentPuzzleController;
  ChessPuzzle? get currentPuzzle => _queue.isNotEmpty ? _queue[_currentIndex] : null;

  void startNewGame() {
    _score = 0;
    _strikes = 0;
    _isGameOver = false;
    _isNewHighScore = false;
    _currentIndex = 0;
    _timeRemainingSeconds = 180;
    _queue = RandomPuzzleGenerator.generatePuzzleRushQueue();

    if (_queue.isNotEmpty) {
      _currentPuzzleController = PuzzleController(_queue[0]);
      _currentPuzzleController.addListener(_onPuzzleStateChanged);
    }

    if (mode == PuzzleRushMode.blitz3Minutes) {
      _startTimer();
    }

    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeRemainingSeconds > 0) {
        _timeRemainingSeconds--;
        notifyListeners();
      } else {
        _endGame();
      }
    });
  }

  void _onPuzzleStateChanged() {
    if (_isGameOver) return;

    if (_currentPuzzleController.status == PuzzleSolveStatus.solved) {
      // Solved! Advance score
      _score++;
      _nextPuzzle();
    } else if (_currentPuzzleController.status == PuzzleSolveStatus.wrongMove) {
      // Mistake / Strike
      _strikes++;
      notifyListeners();
      if (_strikes >= _maxStrikes) {
        _endGame();
      }
    }
  }

  void _nextPuzzle() {
    _currentIndex++;
    if (_currentIndex >= _queue.length) {
      _queue.addAll(RandomPuzzleGenerator.generatePuzzleRushQueue());
    }

    _currentPuzzleController.removeListener(_onPuzzleStateChanged);
    _currentPuzzleController = PuzzleController(_queue[_currentIndex]);
    _currentPuzzleController.addListener(_onPuzzleStateChanged);
    notifyListeners();
  }

  void skipPuzzle() {
    if (_isGameOver) return;
    _strikes++;
    if (_strikes >= _maxStrikes) {
      _endGame();
    } else {
      _nextPuzzle();
    }
    notifyListeners();
  }

  Future<void> _endGame() async {
    _isGameOver = true;
    _timer?.cancel();
    _isNewHighScore = await LocalStorage.savePuzzleRushScore(_score);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _currentPuzzleController.removeListener(_onPuzzleStateChanged);
    super.dispose();
  }
}

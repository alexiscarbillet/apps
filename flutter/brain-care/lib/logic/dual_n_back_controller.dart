import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class DualNBackTrial {
  final int positionIndex; // 0 to 8 on 3x3 grid
  final String letter; // e.g., 'C', 'K', 'L', 'Q', 'R', 'T'
  final String colorName;

  const DualNBackTrial({
    required this.positionIndex,
    required this.letter,
    required this.colorName,
  });
}

class DualNBackController extends ChangeNotifier {
  int _nLevel = 2;
  int _totalTrials = 20;
  int _currentTrialIndex = -1;
  bool _isPlaying = false;
  bool _isFinished = false;

  final List<DualNBackTrial> _history = [];
  Timer? _trialTimer;

  bool _userPositionMatchClaimed = false;
  bool _userAudioMatchClaimed = false;

  int _positionHits = 0;
  int _positionFalseAlarms = 0;
  int _positionMisses = 0;

  int _audioHits = 0;
  int _audioFalseAlarms = 0;
  int _audioMisses = 0;

  static const List<String> letters = ['A', 'C', 'H', 'K', 'L', 'O', 'Q', 'R', 'T'];
  static const List<String> colors = ['Cyan', 'Violet', 'Emerald', 'Amber', 'Coral'];

  int get nLevel => _nLevel;
  int get totalTrials => _totalTrials;
  int get currentTrialIndex => _currentTrialIndex;
  bool get isPlaying => _isPlaying;
  bool get isFinished => _isFinished;
  DualNBackTrial? get currentTrial =>
      (_currentTrialIndex >= 0 && _currentTrialIndex < _history.length)
          ? _history[_currentTrialIndex]
          : null;

  bool get userPositionMatchClaimed => _userPositionMatchClaimed;
  bool get userAudioMatchClaimed => _userAudioMatchClaimed;

  double get accuracyScore {
    final totalSignals = (_history.length - _nLevel).clamp(1, 999);
    final posScore = ((_positionHits - _positionFalseAlarms) / totalSignals * 100)
        .clamp(0.0, 100.0);
    final audScore = ((_audioHits - _audioFalseAlarms) / totalSignals * 100)
        .clamp(0.0, 100.0);
    return double.parse(((posScore + audScore) / 2).toStringAsFixed(1));
  }

  void setNLevel(int n) {
    if (_isPlaying) return;
    _nLevel = n.clamp(1, 4);
    notifyListeners();
  }

  void startSession() {
    _isPlaying = true;
    _isFinished = false;
    _currentTrialIndex = -1;
    _history.clear();
    _positionHits = 0;
    _positionFalseAlarms = 0;
    _positionMisses = 0;
    _audioHits = 0;
    _audioFalseAlarms = 0;
    _audioMisses = 0;

    _generateTrialsSequence();
    _nextTrial();
  }

  void _generateTrialsSequence() {
    final rand = Random();
    for (int i = 0; i < _totalTrials; i++) {
      // 30% chance to match N-back for position
      int pos;
      if (i >= _nLevel && rand.nextDouble() < 0.35) {
        pos = _history[i - _nLevel].positionIndex;
      } else {
        pos = rand.nextInt(9);
      }

      // 30% chance to match N-back for letter
      String let;
      if (i >= _nLevel && rand.nextDouble() < 0.35) {
        let = _history[i - _nLevel].letter;
      } else {
        let = letters[rand.nextInt(letters.length)];
      }

      final col = colors[rand.nextInt(colors.length)];
      _history.add(DualNBackTrial(
        positionIndex: pos,
        letter: let,
        colorName: col,
      ));
    }
  }

  void _nextTrial() {
    _trialTimer?.cancel();
    _evaluatePreviousTrial();

    _currentTrialIndex++;
    if (_currentTrialIndex >= _totalTrials) {
      _finishSession();
      return;
    }

    _userPositionMatchClaimed = false;
    _userAudioMatchClaimed = false;
    notifyListeners();

    // 2.5 seconds per trial
    _trialTimer = Timer(const Duration(milliseconds: 2600), () {
      _nextTrial();
    });
  }

  void _evaluatePreviousTrial() {
    if (_currentTrialIndex < _nLevel || _currentTrialIndex >= _history.length) {
      return;
    }

    final current = _history[_currentTrialIndex];
    final nBack = _history[_currentTrialIndex - _nLevel];

    final isPositionMatch = current.positionIndex == nBack.positionIndex;
    final isAudioMatch = current.letter == nBack.letter;

    // Evaluate Position
    if (isPositionMatch) {
      if (_userPositionMatchClaimed) {
        _positionHits++;
      } else {
        _positionMisses++;
      }
    } else {
      if (_userPositionMatchClaimed) {
        _positionFalseAlarms++;
      }
    }

    // Evaluate Audio
    if (isAudioMatch) {
      if (_userAudioMatchClaimed) {
        _audioHits++;
      } else {
        _audioMisses++;
      }
    } else {
      if (_userAudioMatchClaimed) {
        _audioFalseAlarms++;
      }
    }
  }

  void claimPositionMatch() {
    if (!_isPlaying || _userPositionMatchClaimed) return;
    _userPositionMatchClaimed = true;
    notifyListeners();
  }

  void claimAudioMatch() {
    if (!_isPlaying || _userAudioMatchClaimed) return;
    _userAudioMatchClaimed = true;
    notifyListeners();
  }

  void _finishSession() {
    _trialTimer?.cancel();
    _isPlaying = false;
    _isFinished = true;
    notifyListeners();
  }

  void stop() {
    _trialTimer?.cancel();
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _trialTimer?.cancel();
    super.dispose();
  }
}

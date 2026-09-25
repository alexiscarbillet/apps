import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum SortingRule {
  color, // Match target color
  shape, // Match target shape (Circle, Square, Triangle, Star)
  parity, // Even vs Odd count
}

class TaskSwitchingCard {
  final String shape; // 'Circle', 'Square', 'Triangle', 'Star'
  final Color color;
  final String colorName;
  final int count; // 1, 2, 3, 4

  const TaskSwitchingCard({
    required this.shape,
    required this.color,
    required this.colorName,
    required this.count,
  });
}

class TaskSwitchingController extends ChangeNotifier {
  SortingRule _activeRule = SortingRule.color;
  int _score = 0;
  int _streak = 0;
  int _roundsPlayed = 0;
  final int _maxRounds = 18;
  bool _isPlaying = false;
  bool _isFinished = false;

  TaskSwitchingCard? _currentStimulus;
  List<TaskSwitchingCard> _targetBuckets = [];
  DateTime? _roundStartTime;
  final List<int> _reactionTimesMs = [];

  static const List<String> availableShapes = ['Circle', 'Square', 'Triangle', 'Star'];
  static const Map<String, Color> availableColors = {
    'Cyan': AppColors.electricCyan,
    'Violet': AppColors.vividViolet,
    'Emerald': AppColors.emeraldSynapse,
    'Amber': AppColors.amberGold,
  };

  SortingRule get activeRule => _activeRule;
  int get score => _score;
  int get streak => _streak;
  int get roundsPlayed => _roundsPlayed;
  int get maxRounds => _maxRounds;
  bool get isPlaying => _isPlaying;
  bool get isFinished => _isFinished;
  TaskSwitchingCard? get currentStimulus => _currentStimulus;
  List<TaskSwitchingCard> get targetBuckets => _targetBuckets;

  double get averageLatencyMs => _reactionTimesMs.isEmpty
      ? 0
      : _reactionTimesMs.reduce((a, b) => a + b) / _reactionTimesMs.length;

  double get accuracyPercent =>
      _roundsPlayed == 0 ? 0 : (_score / _roundsPlayed * 100);

  void startSession() {
    _score = 0;
    _streak = 0;
    _roundsPlayed = 0;
    _reactionTimesMs.clear();
    _isPlaying = true;
    _isFinished = false;

    _setupTargetBuckets();
    _nextRound();
  }

  void _setupTargetBuckets() {
    // 4 standard reference targets
    _targetBuckets = [
      const TaskSwitchingCard(
        shape: 'Circle',
        color: AppColors.electricCyan,
        colorName: 'Cyan',
        count: 1,
      ),
      const TaskSwitchingCard(
        shape: 'Square',
        color: AppColors.vividViolet,
        colorName: 'Violet',
        count: 2,
      ),
      const TaskSwitchingCard(
        shape: 'Triangle',
        color: AppColors.emeraldSynapse,
        colorName: 'Emerald',
        count: 3,
      ),
      const TaskSwitchingCard(
        shape: 'Star',
        color: AppColors.amberGold,
        colorName: 'Amber',
        count: 4,
      ),
    ];
  }

  void _nextRound() {
    if (_roundsPlayed >= _maxRounds) {
      _finish();
      return;
    }

    final rand = Random();
    // Dynamic rule shift every 2-3 rounds
    if (_roundsPlayed % 3 == 0 || rand.nextDouble() < 0.4) {
      final available = SortingRule.values.where((r) => r != _activeRule).toList();
      _activeRule = available[rand.nextInt(available.length)];
    }

    // Generate random stimulus
    final shape = availableShapes[rand.nextInt(availableShapes.length)];
    final colorEntry = availableColors.entries.toList()[rand.nextInt(availableColors.length)];
    final count = rand.nextInt(4) + 1;

    _currentStimulus = TaskSwitchingCard(
      shape: shape,
      color: colorEntry.value,
      colorName: colorEntry.key,
      count: count,
    );

    _roundStartTime = DateTime.now();
    notifyListeners();
  }

  bool chooseBucket(int bucketIndex) {
    if (!_isPlaying || _currentStimulus == null || bucketIndex >= _targetBuckets.length) {
      return false;
    }

    final now = DateTime.now();
    if (_roundStartTime != null) {
      _reactionTimesMs.add(now.difference(_roundStartTime!).inMilliseconds);
    }

    final selected = _targetBuckets[bucketIndex];
    bool isCorrect = false;

    switch (_activeRule) {
      case SortingRule.color:
        isCorrect = selected.colorName == _currentStimulus!.colorName;
        break;
      case SortingRule.shape:
        isCorrect = selected.shape == _currentStimulus!.shape;
        break;
      case SortingRule.parity:
        // Even vs Odd count match
        isCorrect = (selected.count % 2) == (_currentStimulus!.count % 2);
        break;
    }

    _roundsPlayed++;
    if (isCorrect) {
      _score++;
      _streak++;
    } else {
      _streak = 0;
    }

    _nextRound();
    return isCorrect;
  }

  void _finish() {
    _isPlaying = false;
    _isFinished = true;
    notifyListeners();
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class DynamicStoryConstraint {
  final String title;
  final String description;
  final bool Function(String text)? validator;

  const DynamicStoryConstraint({
    required this.title,
    required this.description,
    this.validator,
  });
}

class StoryStudioController extends ChangeNotifier {
  bool _isActive = false;
  bool _isFinished = false;
  int _secondsRemaining = 120;
  Timer? _sessionTimer;
  Timer? _injectionTimer;

  String _currentPrompt = '';
  String _activeConstraint = 'Avoid using words containing the letter "E" (Lipogram)';
  final List<String> _injectedObjects = [];
  final List<String> _constraintsLog = [];
  String _storyDraft = '';

  static const List<String> prompts = [
    'You wake up in a quiet cabin where every clock runs backwards...',
    'A lighthouse keeper notices an unusual green beacon shining from underwater...',
    'An archivist discovers a book that writes itself as people walk past...',
    'A traveler buys an antique compass that only points toward memories...',
  ];

  static const List<String> randomInjections = [
    'A brass pocket watch',
    'A rusty key with wings',
    'A glowing blue mushroom',
    'A silver folding umbrella',
    'A mechanical humming humming-bird',
    'An ancient papyrus map',
    'A miniature prism crystal',
    'A cup of black obsidian tea',
  ];

  static const List<String> dynamicRules = [
    'Lipogram: Avoid words with the letter "E"',
    'Tonal Shift: Make the next paragraph intensely suspenseful',
    'Sensory Shift: Describe the sound and tactile temperature of the scene',
    'Syntax Constraint: Write your next 3 sentences using exactly 7 words each',
    'Tonal Shift: Bring in a sense of cosmic awe and wonder',
  ];

  bool get isActive => _isActive;
  bool get isFinished => _isFinished;
  int get secondsRemaining => _secondsRemaining;
  String get currentPrompt => _currentPrompt;
  String get activeConstraint => _activeConstraint;
  List<String> get injectedObjects => _injectedObjects;
  List<String> get constraintsLog => _constraintsLog;
  String get storyDraft => _storyDraft;

  int get wordCount => _storyDraft.trim().isEmpty
      ? 0
      : _storyDraft.trim().split(RegExp(r'\s+')).length;

  int get lipogramViolationCount {
    if (!_activeConstraint.contains('letter "E"')) return 0;
    final words = _storyDraft.toLowerCase().split(RegExp(r'\s+'));
    return words.where((w) => w.contains('e')).length;
  }

  void startStorySession() {
    _isActive = true;
    _isFinished = false;
    _secondsRemaining = 120; // 2 minutes
    _storyDraft = '';
    _injectedObjects.clear();
    _constraintsLog.clear();

    final rand = Random();
    _currentPrompt = prompts[rand.nextInt(prompts.length)];
    _activeConstraint = dynamicRules[0];
    _constraintsLog.add(_activeConstraint);

    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        finishSession();
      }
    });

    // Inject unexpected object/constraint every 30 seconds
    _injectionTimer?.cancel();
    _injectionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isActive) return;
      _triggerMidSentenceInjection();
    });

    notifyListeners();
  }

  void _triggerMidSentenceInjection() {
    final rand = Random();
    final newObj = randomInjections[rand.nextInt(randomInjections.length)];
    final newRule = dynamicRules[rand.nextInt(dynamicRules.length)];

    if (!_injectedObjects.contains(newObj)) {
      _injectedObjects.add(newObj);
    }
    _activeConstraint = newRule;
    if (!_constraintsLog.contains(newRule)) {
      _constraintsLog.add(newRule);
    }
    notifyListeners();
  }

  void updateDraft(String text) {
    _storyDraft = text;
    notifyListeners();
  }

  void finishSession() {
    _sessionTimer?.cancel();
    _injectionTimer?.cancel();
    _isActive = false;
    _isFinished = true;
    notifyListeners();
  }

  double calculateCreativityScore() {
    double score = 60.0;
    // Reward length
    score += (wordCount * 0.4).clamp(0.0, 25.0);
    // Reward injected objects
    score += (_injectedObjects.length * 5.0).clamp(0.0, 15.0);
    // Deduct for lipogram violations if active
    if (_activeConstraint.contains('letter "E"')) {
      score -= (lipogramViolationCount * 2.0);
    }
    return score.clamp(20.0, 99.0);
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _injectionTimer?.cancel();
    super.dispose();
  }
}

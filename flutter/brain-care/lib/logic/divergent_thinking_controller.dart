import 'package:flutter/foundation.dart';

class RemoteAssociatesTriad {
  final String word1;
  final String word2;
  final String word3;
  final String solution;
  final List<String> acceptableAlternatives;
  final String hint;
  final String explanation;

  const RemoteAssociatesTriad({
    required this.word1,
    required this.word2,
    required this.word3,
    required this.solution,
    required this.acceptableAlternatives,
    required this.hint,
    required this.explanation,
  });
}

class DivergentThinkingController extends ChangeNotifier {
  int _currentIndex = 0;
  int _score = 0;
  bool _isPlaying = false;
  bool _isFinished = false;
  bool _showHint = false;
  bool? _isSolved;
  String _userAnswer = '';

  final List<RemoteAssociatesTriad> _triads = const [
    RemoteAssociatesTriad(
      word1: 'Paperclip',
      word2: 'Cloud',
      word3: 'Filing',
      solution: 'Storage',
      acceptableAlternatives: ['Data', 'Hold', 'Document', 'Memory'],
      hint: 'Think about keeping or retaining information and physical items.',
      explanation:
          'A paperclip holds papers, a cloud holds digital storage/water, and filing is physical storage.',
    ),
    RemoteAssociatesTriad(
      word1: 'Swiss',
      word2: 'Cake',
      word3: 'Cottage',
      solution: 'Cheese',
      acceptableAlternatives: ['Cheeses'],
      hint: 'A dairy product with many regional varieties.',
      explanation:
          'Swiss cheese, cheesecake, and cottage cheese all form common composite terms.',
    ),
    RemoteAssociatesTriad(
      word1: 'River',
      word2: 'Note',
      word3: 'Account',
      solution: 'Bank',
      acceptableAlternatives: ['Banks'],
      hint: 'A place of deposit, or the edge of flowing water.',
      explanation:
          'A river bank, banknote, and bank account all utilize the semantic anchor "Bank".',
    ),
    RemoteAssociatesTriad(
      word1: 'Night',
      word2: 'Wrist',
      word3: 'Stop',
      solution: 'Watch',
      acceptableAlternatives: ['Clock'],
      hint: 'Something you wear or do attentively in the dark.',
      explanation:
          'Night watch, wristwatch, and stopwatch unite around "Watch".',
    ),
    RemoteAssociatesTriad(
      word1: 'Dew',
      word2: 'Comb',
      word3: 'Bee',
      solution: 'Honey',
      acceptableAlternatives: ['Honeydew'],
      hint: 'Golden sweet substance made by industrious pollinators.',
      explanation:
          'Honeydew, honeycomb, and honeybee all link to "Honey".',
    ),
  ];

  int get currentIndex => _currentIndex;
  int get score => _score;
  int get totalTriads => _triads.length;
  bool get isPlaying => _isPlaying;
  bool get isFinished => _isFinished;
  bool get showHint => _showHint;
  bool? get isSolved => _isSolved;
  String get userAnswer => _userAnswer;
  RemoteAssociatesTriad get currentTriad => _triads[_currentIndex];

  double get scorePercent =>
      totalTriads == 0 ? 0 : (_score / totalTriads * 100);

  void startSession() {
    _currentIndex = 0;
    _score = 0;
    _isPlaying = true;
    _isFinished = false;
    _showHint = false;
    _isSolved = null;
    _userAnswer = '';
    notifyListeners();
  }

  void revealHint() {
    _showHint = true;
    notifyListeners();
  }

  void submitAnswer(String answer) {
    if (!_isPlaying || _isSolved != null) return;
    _userAnswer = answer.trim();

    final clean = _userAnswer.toLowerCase();
    final isCorrect = clean == currentTriad.solution.toLowerCase() ||
        currentTriad.acceptableAlternatives
            .any((alt) => alt.toLowerCase() == clean);

    _isSolved = isCorrect;
    if (isCorrect) {
      _score++;
    }
    notifyListeners();
  }

  void nextTriad() {
    if (_currentIndex + 1 < _triads.length) {
      _currentIndex++;
      _showHint = false;
      _isSolved = null;
      _userAnswer = '';
      notifyListeners();
    } else {
      _isPlaying = false;
      _isFinished = true;
      notifyListeners();
    }
  }
}

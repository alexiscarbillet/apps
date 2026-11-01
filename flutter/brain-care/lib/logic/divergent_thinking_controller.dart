import 'package:flutter/foundation.dart';

import 'exercise_selection.dart';

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

  static const List<RemoteAssociatesTriad> triadBank = [
    RemoteAssociatesTriad(
      word1: 'Paperclip',
      word2: 'Cloud',
      word3: 'Filing',
      solution: 'Storage',
      acceptableAlternatives: ['Data', 'Hold', 'Document', 'Memory'],
      hint: 'Think about keeping or retaining information and physical items.',
      explanation: 'A paperclip holds papers, a cloud holds digital storage/water, and filing is physical storage.',
    ),
    RemoteAssociatesTriad(
      word1: 'Swiss',
      word2: 'Cake',
      word3: 'Cottage',
      solution: 'Cheese',
      acceptableAlternatives: ['Cheeses'],
      hint: 'A dairy product with many regional varieties.',
      explanation: 'Swiss cheese, cheesecake, and cottage cheese all form common composite terms.',
    ),
    RemoteAssociatesTriad(
      word1: 'River',
      word2: 'Note',
      word3: 'Account',
      solution: 'Bank',
      acceptableAlternatives: ['Banks'],
      hint: 'A place of deposit, or the edge of flowing water.',
      explanation: 'A river bank, banknote, and bank account all utilize the semantic anchor "Bank".',
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
      explanation: 'Honeydew, honeycomb, and honeybee all link to "Honey".',
    ),
    RemoteAssociatesTriad(
      word1: 'Book',
      word2: 'Tennis',
      word3: 'Night',
      solution: 'Club',
      acceptableAlternatives: [],
      hint: 'A group, venue, or organization people can join.',
      explanation: 'Book club, tennis club, and nightclub all use the same linking word.',
    ),
    RemoteAssociatesTriad(
      word1: 'Tooth',
      word2: 'Hair',
      word3: 'Paint',
      solution: 'Brush',
      acceptableAlternatives: ['Brushes'],
      hint: 'A tool used for cleaning, grooming, or applying color.',
      explanation:
          'Toothbrush, hairbrush, and paintbrush all share the same tool.',
    ),
    RemoteAssociatesTriad(
      word1: 'Foot',
      word2: 'Base',
      word3: 'Basket',
      solution: 'Ball',
      acceptableAlternatives: ['Balls'],
      hint: 'A round object used in three familiar sports.',
      explanation: 'Football, baseball, and basketball all use a ball.',
    ),
    RemoteAssociatesTriad(
      word1: 'Playing',
      word2: 'Credit',
      word3: 'Greeting',
      solution: 'Card',
      acceptableAlternatives: ['Cards'],
      hint: 'A small flat item used in games, payments, or messages.',
      explanation:
          'Playing card, credit card, and greeting card share the anchor word.',
    ),
    RemoteAssociatesTriad(
      word1: 'Tea',
      word2: 'Coffee',
      word3: 'Soup',
      solution: 'Cup',
      acceptableAlternatives: ['Cups'],
      hint: 'A small container for a drink or serving.',
      explanation:
          'Teacup, coffee cup, and a cup of soup all share the same container.',
    ),
    RemoteAssociatesTriad(
      word1: 'Cream',
      word2: 'Skate',
      word3: 'Water',
      solution: 'Ice',
      acceptableAlternatives: [],
      hint: 'A frozen form of water.',
      explanation:
          'Ice cream, ice skate, and ice water all pair with the same word.',
    ),
    RemoteAssociatesTriad(
      word1: 'Show',
      word2: 'Life',
      word3: 'Row',
      solution: 'Boat',
      acceptableAlternatives: ['Boats'],
      hint: 'A vessel that can be used for entertainment, rescue, or rowing.',
      explanation:
          'Showboat, lifeboat, and rowboat all use the same linking word.',
    ),
    RemoteAssociatesTriad(
      word1: 'Man',
      word2: 'Glue',
      word3: 'Star',
      solution: 'Super',
      acceptableAlternatives: [],
      hint: 'A prefix meaning above or beyond the ordinary.',
      explanation:
          'Superman, superglue, and superstar all share the same prefix.',
    ),
    RemoteAssociatesTriad(
      word1: 'Falling',
      word2: 'Movie',
      word3: 'Dust',
      solution: 'Star',
      acceptableAlternatives: ['Stars'],
      hint: 'A bright object in the night sky.',
      explanation:
          'Falling star, movie star, and stardust all share the word star.',
    ),
    RemoteAssociatesTriad(
      word1: 'Maker',
      word2: 'Point',
      word3: 'Stick',
      solution: 'Match',
      acceptableAlternatives: ['Matches'],
      hint: 'A small object that can start a fire.',
      explanation: 'Matchmaker, match point, and matchstick all use match.',
    ),
    RemoteAssociatesTriad(
      word1: 'Safety',
      word2: 'Cushion',
      word3: 'Point',
      solution: 'Pin',
      acceptableAlternatives: ['Pins'],
      hint: 'A small fastener or sharp marker.',
      explanation: 'Safety pin, pincushion, and pinpoint all use pin.',
    ),
    RemoteAssociatesTriad(
      word1: 'High',
      word2: 'House',
      word3: 'District',
      solution: 'School',
      acceptableAlternatives: ['Schools'],
      hint: 'A place for learning.',
      explanation:
          'High school, schoolhouse, and school district all use school.',
    ),
    RemoteAssociatesTriad(
      word1: 'Birthday',
      word2: 'Taper',
      word3: 'Wax',
      solution: 'Candle',
      acceptableAlternatives: ['Candles'],
      hint: 'An object with a wick that gives light when lit.',
      explanation:
          'Birthday candle, taper candle, and candle wax all share candle.',
    ),
    RemoteAssociatesTriad(
      word1: 'Potato',
      word2: 'Tooth',
      word3: 'Heart',
      solution: 'Sweet',
      acceptableAlternatives: [],
      hint: 'A taste, or a kind way to describe someone.',
      explanation: 'Sweet potato, sweet tooth, and sweetheart all use sweet.',
    ),
    RemoteAssociatesTriad(
      word1: 'Down',
      word2: 'Water',
      word3: 'Free',
      solution: 'Fall',
      acceptableAlternatives: ['Falls'],
      hint: 'A season, a cascade, or a loss of balance.',
      explanation: 'Downfall, waterfall, and freefall all use the same word.',
    ),
  ];
  List<RemoteAssociatesTriad> _sessionTriads = [];

  int get currentIndex => _currentIndex;
  int get score => _score;
  int get totalTriads => _sessionTriads.length;
  bool get isPlaying => _isPlaying;
  bool get isFinished => _isFinished;
  bool get showHint => _showHint;
  bool? get isSolved => _isSolved;
  String get userAnswer => _userAnswer;
  RemoteAssociatesTriad get currentTriad => _sessionTriads[_currentIndex];

  double get scorePercent =>
      totalTriads == 0 ? 0 : (_score / totalTriads * 100);
  int get triadBankSize => triadBank.length;

  void startSession() {
    _currentIndex = 0;
    _score = 0;
    _isPlaying = true;
    _isFinished = false;
    _showHint = false;
    _isSolved = null;
    _userAnswer = '';
    _sessionTriads = selectFiveRandom(triadBank);
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
    final isCorrect =
        clean == currentTriad.solution.toLowerCase() ||
        currentTriad.acceptableAlternatives.any(
          (alt) => alt.toLowerCase() == clean,
        );

    _isSolved = isCorrect;
    if (isCorrect) {
      _score++;
    }
    notifyListeners();
  }

  void nextTriad() {
    if (_currentIndex + 1 < _sessionTriads.length) {
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

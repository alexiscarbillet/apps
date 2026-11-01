import 'dart:math';

import 'package:flutter/foundation.dart';

import 'exercise_selection.dart';

class VoxelPoint {
  final int x;
  final int y;
  final int z;
  const VoxelPoint(this.x, this.y, this.z);

  VoxelPoint rotateZ(int quarters) {
    int curX = x;
    int curY = y;
    int curZ = z;
    for (int i = 0; i < (quarters % 4); i++) {
      int temp = curX;
      curX = -curY;
      curY = temp;
    }
    return VoxelPoint(curX, curY, curZ);
  }

  VoxelPoint rotateX(int quarters) {
    int curX = x;
    int curY = y;
    int curZ = z;
    for (int i = 0; i < (quarters % 4); i++) {
      int temp = curY;
      curY = -curZ;
      curZ = temp;
    }
    return VoxelPoint(curX, curY, curZ);
  }

  VoxelPoint rotateY(int quarters) {
    int curX = x;
    int curY = y;
    int curZ = z;
    for (int i = 0; i < (quarters % 4); i++) {
      int temp = curX;
      curX = curZ;
      curZ = -temp;
    }
    return VoxelPoint(curX, curY, curZ);
  }
}

class SpatialPuzzleQuestion {
  final String title;
  final List<VoxelPoint> originalShape;
  final List<List<VoxelPoint>> candidates;
  final int correctIndex;
  final String rationale;

  const SpatialPuzzleQuestion({
    required this.title,
    required this.originalShape,
    required this.candidates,
    required this.correctIndex,
    required this.rationale,
  });
}

class MentalRotationController extends ChangeNotifier {
  int _currentIndex = 0;
  int _score = 0;
  bool _isPlaying = false;
  bool _isFinished = false;
  int? _selectedAnswerIndex;
  bool? _isCurrentAnswerCorrect;

  static const int bankSize = 20;
  static const List<SpatialPuzzleQuestion> _seedQuestions = [
    SpatialPuzzleQuestion(
      title: 'L-Branch 3D Isometric Polycube',
      originalShape: [
        VoxelPoint(0, 0, 0),
        VoxelPoint(1, 0, 0),
        VoxelPoint(2, 0, 0),
        VoxelPoint(2, 1, 0),
        VoxelPoint(2, 1, 1),
      ],
      candidates: [
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(0, 2, 0),
          VoxelPoint(1, 2, 0),
          VoxelPoint(1, 2, 1),
        ],
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(2, 0, 0),
          VoxelPoint(2, -1, 0),
          VoxelPoint(2, -1, -1),
        ],
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(1, 1, 0),
          VoxelPoint(1, 1, 1),
        ],
      ],
      correctIndex: 0,
      rationale: 'Candidate A represents a pure 90° clockwise planar yaw followed by isometric pitch.',
    ),
    SpatialPuzzleQuestion(
      title: 'T-Cubic Helical Step',
      originalShape: [
        VoxelPoint(0, 0, 0),
        VoxelPoint(0, 1, 0),
        VoxelPoint(0, 2, 0),
        VoxelPoint(1, 1, 0),
        VoxelPoint(-1, 1, 0),
        VoxelPoint(0, 2, 1),
      ],
      candidates: [
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(0, 2, 0),
          VoxelPoint(-1, 1, 0),
          VoxelPoint(0, 2, -1),
        ],
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, -1, 0),
          VoxelPoint(0, -2, 0),
          VoxelPoint(-1, -1, 0),
          VoxelPoint(1, -1, 0),
          VoxelPoint(0, -2, -1),
        ],
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(0, 0, 1),
        ],
      ],
      correctIndex: 1,
      rationale: 'Candidate B preserves all 6 voxels in exact topological orientation after a 180° inversion.',
    ),
    SpatialPuzzleQuestion(
      title: 'Staircase Z-Chiral Matrix',
      originalShape: [
        VoxelPoint(0, 0, 0),
        VoxelPoint(1, 0, 0),
        VoxelPoint(1, 1, 0),
        VoxelPoint(1, 1, 1),
        VoxelPoint(2, 1, 1),
      ],
      candidates: [
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(-1, 1, 0),
          VoxelPoint(-1, 1, 1),
          VoxelPoint(-1, 2, 1),
        ],
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(1, 1, 1),
          VoxelPoint(2, 1, 1),
        ],
        [
          VoxelPoint(0, 0, 0),
          VoxelPoint(-1, 0, 0),
          VoxelPoint(-1, 1, 0),
          VoxelPoint(-1, 1, -1),
        ],
      ],
      correctIndex: 0,
      rationale: 'Candidate A maintains chiral chirality across all Cartesian spatial coordinate transformations.',
    ),
  ];
  static final List<SpatialPuzzleQuestion> questionBank = [
    ..._seedQuestions,
    ...List.generate(
      bankSize - _seedQuestions.length,
      (index) => _buildQuestion(index + _seedQuestions.length),
    ),
  ];
  List<SpatialPuzzleQuestion> _sessionQuestions = [];

  int get currentIndex => _currentIndex;
  int get score => _score;
  int get totalQuestions => _sessionQuestions.length;
  int get questionBankSize => questionBank.length;
  bool get isPlaying => _isPlaying;
  bool get isFinished => _isFinished;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool? get isCurrentAnswerCorrect => _isCurrentAnswerCorrect;
  SpatialPuzzleQuestion get currentQuestion => _sessionQuestions[_currentIndex];

  double get scorePercent =>
      totalQuestions == 0 ? 0 : (_score / totalQuestions * 100);

  void startSession() {
    _currentIndex = 0;
    _score = 0;
    _isPlaying = true;
    _isFinished = false;
    _selectedAnswerIndex = null;
    _isCurrentAnswerCorrect = null;
    final random = Random();
    _sessionQuestions = selectFiveRandom(questionBank)
        .map((question) => _randomizeQuestion(question, random))
        .toList();
    notifyListeners();
  }

  static SpatialPuzzleQuestion _buildQuestion(int index) {
    var x = 0;
    var y = 0;
    var z = 0;
    var pattern = index;
    final shape = <VoxelPoint>[const VoxelPoint(0, 0, 0)];
    for (var step = 0; step < 6; step++) {
      switch (pattern % 3) {
        case 0:
          x++;
        case 1:
          y++;
        case 2:
          z++;
      }
      pattern ~/= 3;
      shape.add(VoxelPoint(x, y, z));
    }

    final displaced = List<VoxelPoint>.from(shape);
    final last = displaced.removeLast();
    displaced.add(VoxelPoint(last.x + 2, last.y, last.z));

    return SpatialPuzzleQuestion(
      title: 'Voxel Walk ${index + 1}',
      originalShape: shape,
      candidates: [
        shape.map((point) => point.rotateX(1)).toList(),
        shape.take(shape.length - 1).toList(),
        displaced,
      ],
      correctIndex: 0,
      rationale: 'The rotated option preserves all seven connected cubes. The other options either remove a cube or move one out of the connected shape.',
    );
  }

  SpatialPuzzleQuestion _randomizeQuestion(
    SpatialPuzzleQuestion question,
    Random random,
  ) {
    final rotation = random.nextInt(4);
    final candidates =
        question.candidates
            .asMap()
            .entries
            .map(
              (entry) => MapEntry(
                entry.key,
                entry.value.map((point) => point.rotateZ(rotation)).toList(),
              ),
            )
            .toList()
          ..shuffle(random);

    return SpatialPuzzleQuestion(
      title: question.title,
      originalShape: question.originalShape
          .map((point) => point.rotateZ(rotation))
          .toList(),
      candidates: candidates.map((entry) => entry.value).toList(),
      correctIndex: candidates.indexWhere(
        (entry) => entry.key == question.correctIndex,
      ),
      rationale: question.rationale,
    );
  }

  void selectCandidate(int index) {
    if (!_isPlaying || _selectedAnswerIndex != null) return;
    _selectedAnswerIndex = index;
    final isCorrect = index == currentQuestion.correctIndex;
    _isCurrentAnswerCorrect = isCorrect;
    if (isCorrect) _score++;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex + 1 < _sessionQuestions.length) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      _isCurrentAnswerCorrect = null;
      notifyListeners();
    } else {
      _isPlaying = false;
      _isFinished = true;
      notifyListeners();
    }
  }
}

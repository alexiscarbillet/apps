import 'dart:math';
import 'package:flutter/foundation.dart';

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

  final List<SpatialPuzzleQuestion> _questions = [
    SpatialPuzzleQuestion(
      title: 'L-Branch 3D Isometric Polycube',
      originalShape: const [
        VoxelPoint(0, 0, 0),
        VoxelPoint(1, 0, 0),
        VoxelPoint(2, 0, 0),
        VoxelPoint(2, 1, 0),
        VoxelPoint(2, 1, 1),
      ],
      candidates: [
        // Candidate 0: Rotated around Z by 90 deg + Y by 90 deg (Valid rotation)
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(0, 2, 0),
          VoxelPoint(1, 2, 0),
          VoxelPoint(1, 2, 1),
        ],
        // Candidate 1: Inverted / chiral mirror (Invalid)
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(2, 0, 0),
          VoxelPoint(2, -1, 0),
          VoxelPoint(2, -1, -1),
        ],
        // Candidate 2: Missing arm (Invalid)
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(1, 1, 0),
          VoxelPoint(1, 1, 1),
        ],
      ],
      correctIndex: 0,
      rationale:
          'Candidate A represents a pure 90° clockwise planar yaw followed by isometric pitch.',
    ),
    SpatialPuzzleQuestion(
      title: 'T-Cubic Helical Step',
      originalShape: const [
        VoxelPoint(0, 0, 0),
        VoxelPoint(0, 1, 0),
        VoxelPoint(0, 2, 0),
        VoxelPoint(1, 1, 0),
        VoxelPoint(-1, 1, 0),
        VoxelPoint(0, 2, 1),
      ],
      candidates: [
        // Candidate 0: Mirrored
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(0, 2, 0),
          VoxelPoint(-1, 1, 0),
          VoxelPoint(0, 2, -1),
        ],
        // Candidate 1: 180° Rotated (Valid)
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, -1, 0),
          VoxelPoint(0, -2, 0),
          VoxelPoint(-1, -1, 0),
          VoxelPoint(1, -1, 0),
          VoxelPoint(0, -2, -1),
        ],
        // Candidate 2: Truncated
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(0, 0, 1),
        ],
      ],
      correctIndex: 1,
      rationale:
          'Candidate B preserves all 6 voxels in exact topological orientation after a 180° inversion.',
    ),
    SpatialPuzzleQuestion(
      title: 'Staircase Z-Chiral Matrix',
      originalShape: const [
        VoxelPoint(0, 0, 0),
        VoxelPoint(1, 0, 0),
        VoxelPoint(1, 1, 0),
        VoxelPoint(1, 1, 1),
        VoxelPoint(2, 1, 1),
      ],
      candidates: [
        // Candidate 0: Valid 90° Z rotation
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(0, 1, 0),
          VoxelPoint(-1, 1, 0),
          VoxelPoint(-1, 1, 1),
          VoxelPoint(-1, 2, 1),
        ],
        // Candidate 1: Missing bottom step
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(1, 0, 0),
          VoxelPoint(1, 1, 1),
          VoxelPoint(2, 1, 1),
        ],
        // Candidate 2: Chiral inversion
        const [
          VoxelPoint(0, 0, 0),
          VoxelPoint(-1, 0, 0),
          VoxelPoint(-1, 1, 0),
          VoxelPoint(-1, 1, -1),
        ],
      ],
      correctIndex: 0,
      rationale:
          'Candidate A maintains chiral chirality across all Cartesian spatial coordinate transformations.',
    ),
  ];

  int get currentIndex => _currentIndex;
  int get score => _score;
  int get totalQuestions => _questions.length;
  bool get isPlaying => _isPlaying;
  bool get isFinished => _isFinished;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool? get isCurrentAnswerCorrect => _isCurrentAnswerCorrect;
  SpatialPuzzleQuestion get currentQuestion => _questions[_currentIndex];

  double get scorePercent =>
      totalQuestions == 0 ? 0 : (_score / totalQuestions * 100);

  void startSession() {
    _currentIndex = 0;
    _score = 0;
    _isPlaying = true;
    _isFinished = false;
    _selectedAnswerIndex = null;
    _isCurrentAnswerCorrect = null;
    notifyListeners();
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
    if (_currentIndex + 1 < _questions.length) {
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

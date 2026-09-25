import 'dart:math';
import 'models/puzzle_model.dart';
import 'puzzle_database.dart';

class RandomPuzzleGenerator {
  static final _random = Random();

  /// Gets a random puzzle matching optional rating range and theme
  static ChessPuzzle getRandomPuzzle({
    int minRating = 800,
    int maxRating = 2500,
    PuzzleTheme? theme,
  }) {
    var candidates = PuzzleDatabase.allPuzzles.where((p) {
      if (theme != null && p.theme != theme) return false;
      return p.rating >= minRating && p.rating <= maxRating;
    }).toList();

    if (candidates.isEmpty) {
      candidates = PuzzleDatabase.allPuzzles;
    }

    return candidates[_random.nextInt(candidates.length)];
  }

  /// Generates a queue of puzzles for Puzzle Rush mode with escalating difficulty
  static List<ChessPuzzle> generatePuzzleRushQueue() {
    final List<ChessPuzzle> queue = [];
    final all = List<ChessPuzzle>.from(PuzzleDatabase.allPuzzles);
    all.sort((a, b) => a.rating.compareTo(b.rating));

    // Split into brackets:
    final easy = all.where((p) => p.rating < 1100).toList()..shuffle(_random);
    final medium = all.where((p) => p.rating >= 1100 && p.rating < 1500).toList()..shuffle(_random);
    final hard = all.where((p) => p.rating >= 1500 && p.rating < 1900).toList()..shuffle(_random);
    final master = all.where((p) => p.rating >= 1900).toList()..shuffle(_random);

    queue.addAll(easy);
    queue.addAll(medium);
    queue.addAll(hard);
    queue.addAll(master);

    return queue;
  }
}

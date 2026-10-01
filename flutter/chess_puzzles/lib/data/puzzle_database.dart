import '../../core/chess/chess_models.dart';
import 'models/puzzle_model.dart';
import 'polgar_puzzle_data.dart';

class PuzzleDatabase {
  static const List<ChessPuzzle> allPuzzles = polgarPuzzles;

  static List<ChessPuzzle> getPuzzlesByTheme(PuzzleTheme theme) {
    return allPuzzles.where((p) => p.theme == theme).toList();
  }

  static List<ChessPuzzle> getPuzzlesByDifficulty(PuzzleDifficulty difficulty) {
    return allPuzzles.where((p) => p.difficulty == difficulty).toList();
  }

  static ChessPuzzle? getPuzzleById(String id) {
    try {
      return allPuzzles.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Generate 5 daily puzzles for any given date
  static List<ChessPuzzle> getDaily5Puzzles(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final List<ChessPuzzle> selected = [];

    // Progressive difficulty follows the book's sections.
    final m1 = getPuzzlesByTheme(PuzzleTheme.mateIn1);
    selected.add(m1[seed % m1.length]);

    final m2 = getPuzzlesByTheme(PuzzleTheme.mateIn2);
    selected.add(m2[(seed * 7 + 3) % m2.length]);

    final m3 = getPuzzlesByTheme(PuzzleTheme.mateIn3);
    selected.add(m3[(seed * 13 + 5) % m3.length]);

    final middle = [
      ...getPuzzlesByTheme(PuzzleTheme.miniatureGames),
      ...getPuzzlesByTheme(PuzzleTheme.endgame),
    ];
    selected.add(middle[(seed * 17 + 11) % middle.length]);

    final combinations = getPuzzlesByTheme(PuzzleTheme.polgarCombinations);
    selected.add(combinations[(seed * 23 + 19) % combinations.length]);

    return selected;
  }
}

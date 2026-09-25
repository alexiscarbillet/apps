import '../../core/chess/chess_models.dart';

enum PuzzleTheme {
  mateIn1('Mate in 1', '👑', 'One-move tactical knockout blow'),
  mateIn2('Mate in 2', '⚔️', 'Forced checkmate in 2 moves'),
  fork('Fork & Double Attack', '🍴', 'Attack two enemy pieces simultaneously'),
  pin('Pin & Skewer', '📌', 'Immobilize or exploit aligned pieces'),
  discoveredAttack('Discovered Attack', '⚡', 'Unmask a devastating ambush'),
  endgame('Endgame Mastery', '🏰', 'Precision technique in kings & pawns'),
  masterpiece('Grandmaster Classic', '🌟', 'Historic brilliancy by chess legends');

  final String title;
  final String icon;
  final String description;

  const PuzzleTheme(this.title, this.icon, this.description);
}

enum PuzzleDifficulty {
  beginner('Beginner', 800, 1199),
  intermediate('Intermediate', 1200, 1599),
  advanced('Advanced', 1600, 1999),
  master('Master', 2000, 2600);

  final String label;
  final int minRating;
  final int maxRating;

  const PuzzleDifficulty(this.label, this.minRating, this.maxRating);

  static PuzzleDifficulty fromRating(int rating) {
    if (rating < 1200) return PuzzleDifficulty.beginner;
    if (rating < 1600) return PuzzleDifficulty.intermediate;
    if (rating < 2000) return PuzzleDifficulty.advanced;
    return PuzzleDifficulty.master;
  }
}

class ChessPuzzle {
  final String id;
  final String title;
  final String description;
  final String fen;
  final List<String> moves; // UCI moves e.g. ["e2e4", "e7e5"]
  final PuzzleTheme theme;
  final int rating;
  final String explanation;
  final PieceColor playerColor;

  const ChessPuzzle({
    required this.id,
    required this.title,
    required this.description,
    required this.fen,
    required this.moves,
    required this.theme,
    required this.rating,
    required this.explanation,
    required this.playerColor,
  });

  PuzzleDifficulty get difficulty => PuzzleDifficulty.fromRating(rating);

  int get solutionMoveCount => (moves.length + 1) ~/ 2;
}

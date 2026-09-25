enum PieceType {
  pawn('p'),
  knight('n'),
  bishop('b'),
  rook('r'),
  queen('q'),
  king('k');

  final String symbol;
  const PieceType(this.symbol);

  static PieceType? fromSymbol(String char) {
    switch (char.toLowerCase()) {
      case 'p':
        return PieceType.pawn;
      case 'n':
        return PieceType.knight;
      case 'b':
        return PieceType.bishop;
      case 'r':
        return PieceType.rook;
      case 'q':
        return PieceType.queen;
      case 'k':
        return PieceType.king;
      default:
        return null;
    }
  }

  String get displayName {
    switch (this) {
      case PieceType.pawn:
        return 'Pawn';
      case PieceType.knight:
        return 'Knight';
      case PieceType.bishop:
        return 'Bishop';
      case PieceType.rook:
        return 'Rook';
      case PieceType.queen:
        return 'Queen';
      case PieceType.king:
        return 'King';
    }
  }
}

enum PieceColor {
  white('w'),
  black('b');

  final String code;
  const PieceColor(this.code);

  PieceColor get opposite => this == PieceColor.white ? PieceColor.black : PieceColor.white;
  String get displayName => this == PieceColor.white ? 'White' : 'Black';
}

class ChessPiece {
  final PieceType type;
  final PieceColor color;

  const ChessPiece({required this.type, required this.color});

  String get fenChar {
    return color == PieceColor.white ? type.symbol.toUpperCase() : type.symbol.toLowerCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChessPiece && runtimeType == other.runtimeType && type == other.type && color == other.color;

  @override
  int get hashCode => type.hashCode ^ color.hashCode;

  @override
  String toString() => '$color $type';
}

class Square {
  final int file; // 0..7 -> a..h
  final int rank; // 0..7 -> 1..8 (0 is rank 1, 7 is rank 8)

  const Square(this.file, this.rank)
      : assert(file >= 0 && file <= 7),
        assert(rank >= 0 && rank <= 7);

  static Square? fromAlgebraic(String alg) {
    if (alg.length != 2) return null;
    final file = alg.toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = alg.codeUnitAt(1) - '1'.codeUnitAt(0);
    if (file < 0 || file > 7 || rank < 0 || rank > 7) return null;
    return Square(file, rank);
  }

  String get algebraic {
    final f = String.fromCharCode('a'.codeUnitAt(0) + file);
    final r = (rank + 1).toString();
    return '$f$r';
  }

  bool get isLightSquare => (file + rank) % 2 != 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Square && runtimeType == other.runtimeType && file == other.file && rank == other.rank;

  @override
  int get hashCode => file.hashCode ^ rank.hashCode;

  @override
  String toString() => algebraic;
}

class ChessMove {
  final Square from;
  final Square to;
  final PieceType? promotion;
  final bool isCapture;
  final bool isCastling;
  final bool isEnPassant;
  final String? san;

  const ChessMove({
    required this.from,
    required this.to,
    this.promotion,
    this.isCapture = false,
    this.isCastling = false,
    this.isEnPassant = false,
    this.san,
  });

  String get uci {
    final promo = promotion != null ? promotion!.symbol : '';
    return '${from.algebraic}${to.algebraic}$promo';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChessMove &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to &&
          promotion == other.promotion;

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ (promotion?.hashCode ?? 0);

  @override
  String toString() => san ?? uci;
}

enum GameState {
  inProgress,
  check,
  checkmate,
  stalemate,
  draw;
}

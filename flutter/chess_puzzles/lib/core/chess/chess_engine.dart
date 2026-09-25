import 'chess_models.dart';

class ChessEngine {
  List<List<ChessPiece?>> _board = List.generate(8, (_) => List.filled(8, null));
  PieceColor _turn = PieceColor.white;
  bool _whiteCanCastleKingSide = true;
  bool _whiteCanCastleQueenSide = true;
  bool _blackCanCastleKingSide = true;
  bool _blackCanCastleQueenSide = true;
  Square? _enPassantSquare;
  int _halfmoveClock = 0;
  int _fullmoveNumber = 1;

  final List<_UndoState> _history = [];

  ChessEngine([String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1']) {
    loadFen(fen);
  }

  PieceColor get turn => _turn;
  bool get whiteCanCastleKingSide => _whiteCanCastleKingSide;
  bool get whiteCanCastleQueenSide => _whiteCanCastleQueenSide;
  bool get blackCanCastleKingSide => _blackCanCastleKingSide;
  bool get blackCanCastleQueenSide => _blackCanCastleQueenSide;
  Square? get enPassantSquare => _enPassantSquare;
  int get halfmoveClock => _halfmoveClock;
  int get fullmoveNumber => _fullmoveNumber;

  ChessPiece? getPiece(Square square) => _board[square.rank][square.file];

  ChessPiece? pieceAt(int file, int rank) {
    if (file < 0 || file > 7 || rank < 0 || rank > 7) return null;
    return _board[rank][file];
  }

  void loadFen(String fen) {
    _history.clear();
    _board = List.generate(8, (_) => List.filled(8, null));

    final parts = fen.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return;

    final ranks = parts[0].split('/');
    if (ranks.length == 8) {
      for (int r = 0; r < 8; r++) {
        final rankStr = ranks[7 - r]; // FEN starts from rank 8 (index 7) down to rank 1 (index 0)
        int file = 0;
        for (int i = 0; i < rankStr.length; i++) {
          final char = rankStr[i];
          if (RegExp(r'[1-8]').hasMatch(char)) {
            file += int.parse(char);
          } else {
            final type = PieceType.fromSymbol(char);
            if (type != null && file < 8) {
              final color = char == char.toUpperCase() ? PieceColor.white : PieceColor.black;
              _board[r][file] = ChessPiece(type: type, color: color);
              file++;
            }
          }
        }
      }
    }

    _turn = (parts.length > 1 && parts[1] == 'b') ? PieceColor.black : PieceColor.white;

    final castling = parts.length > 2 ? parts[2] : '-';
    _whiteCanCastleKingSide = castling.contains('K');
    _whiteCanCastleQueenSide = castling.contains('Q');
    _blackCanCastleKingSide = castling.contains('k');
    _blackCanCastleQueenSide = castling.contains('q');

    final epStr = parts.length > 3 ? parts[3] : '-';
    _enPassantSquare = (epStr != '-') ? Square.fromAlgebraic(epStr) : null;

    _halfmoveClock = (parts.length > 4) ? int.tryParse(parts[4]) ?? 0 : 0;
    _fullmoveNumber = (parts.length > 5) ? int.tryParse(parts[5]) ?? 1 : 1;
  }

  String generateFen() {
    final buffer = StringBuffer();
    for (int r = 7; r >= 0; r--) {
      int emptyCount = 0;
      for (int f = 0; f < 8; f++) {
        final piece = _board[r][f];
        if (piece == null) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            buffer.write(emptyCount);
            emptyCount = 0;
          }
          buffer.write(piece.fenChar);
        }
      }
      if (emptyCount > 0) {
        buffer.write(emptyCount);
      }
      if (r > 0) buffer.write('/');
    }

    buffer.write(' ${_turn.code} ');

    final castling = StringBuffer();
    if (_whiteCanCastleKingSide) castling.write('K');
    if (_whiteCanCastleQueenSide) castling.write('Q');
    if (_blackCanCastleKingSide) castling.write('k');
    if (_blackCanCastleQueenSide) castling.write('q');
    buffer.write(castling.isEmpty ? '-' : castling.toString());

    buffer.write(' ${_enPassantSquare != null ? _enPassantSquare!.algebraic : '-'} ');
    buffer.write('$_halfmoveClock $_fullmoveNumber');

    return buffer.toString();
  }

  Square? findKing(PieceColor color) {
    for (int r = 0; r < 8; r++) {
      for (int f = 0; f < 8; f++) {
        final piece = _board[r][f];
        if (piece != null && piece.type == PieceType.king && piece.color == color) {
          return Square(f, r);
        }
      }
    }
    return null;
  }

  bool isSquareAttackedBy(Square square, PieceColor attackerColor) {
    // Check knight attacks
    final knightOffsets = [
      [-2, -1], [-2, 1], [-1, -2], [-1, 2],
      [1, -2], [1, 2], [2, -1], [2, 1]
    ];
    for (final offset in knightOffsets) {
      final f = square.file + offset[0];
      final r = square.rank + offset[1];
      final piece = pieceAt(f, r);
      if (piece != null && piece.color == attackerColor && piece.type == PieceType.knight) {
        return true;
      }
    }

    // Check pawn attacks
    final pawnRank = square.rank - (attackerColor == PieceColor.white ? 1 : -1);
    for (final f in [square.file - 1, square.file + 1]) {
      final piece = pieceAt(f, pawnRank);
      if (piece != null && piece.color == attackerColor && piece.type == PieceType.pawn) {
        return true;
      }
    }

    // Check king attacks
    for (int df = -1; df <= 1; df++) {
      for (int dr = -1; dr <= 1; dr++) {
        if (df == 0 && dr == 0) continue;
        final piece = pieceAt(square.file + df, square.rank + dr);
        if (piece != null && piece.color == attackerColor && piece.type == PieceType.king) {
          return true;
        }
      }
    }

    // Check straight ray attacks (Rook / Queen)
    final straightDirs = [[0, 1], [0, -1], [1, 0], [-1, 0]];
    for (final dir in straightDirs) {
      int f = square.file + dir[0];
      int r = square.rank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final piece = _board[r][f];
        if (piece != null) {
          if (piece.color == attackerColor &&
              (piece.type == PieceType.rook || piece.type == PieceType.queen)) {
            return true;
          }
          break;
        }
        f += dir[0];
        r += dir[1];
      }
    }

    // Check diagonal ray attacks (Bishop / Queen)
    final diagDirs = [[1, 1], [1, -1], [-1, 1], [-1, -1]];
    for (final dir in diagDirs) {
      int f = square.file + dir[0];
      int r = square.rank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final piece = _board[r][f];
        if (piece != null) {
          if (piece.color == attackerColor &&
              (piece.type == PieceType.bishop || piece.type == PieceType.queen)) {
            return true;
          }
          break;
        }
        f += dir[0];
        r += dir[1];
      }
    }

    return false;
  }

  bool isKingInCheck(PieceColor color) {
    final kingSquare = findKing(color);
    if (kingSquare == null) return false;
    return isSquareAttackedBy(kingSquare, color.opposite);
  }

  List<ChessMove> generateLegalMoves() {
    final pseudoMoves = _generatePseudoLegalMoves(_turn);
    final legalMoves = <ChessMove>[];

    for (final move in pseudoMoves) {
      makeMove(move, validateLegality: false);
      final inCheck = isKingInCheck(_turn.opposite);
      undoMove();

      if (!inCheck) {
        legalMoves.add(move);
      }
    }

    return legalMoves;
  }

  List<ChessMove> _generatePseudoLegalMoves(PieceColor color) {
    final moves = <ChessMove>[];

    for (int r = 0; r < 8; r++) {
      for (int f = 0; f < 8; f++) {
        final piece = _board[r][f];
        if (piece == null || piece.color != color) continue;
        final from = Square(f, r);

        switch (piece.type) {
          case PieceType.pawn:
            _generatePawnMoves(from, piece, moves);
            break;
          case PieceType.knight:
            _generateKnightMoves(from, piece, moves);
            break;
          case PieceType.bishop:
            _generateRayMoves(from, piece, [[1, 1], [1, -1], [-1, 1], [-1, -1]], moves);
            break;
          case PieceType.rook:
            _generateRayMoves(from, piece, [[0, 1], [0, -1], [1, 0], [-1, 0]], moves);
            break;
          case PieceType.queen:
            _generateRayMoves(from, piece, [
              [1, 1], [1, -1], [-1, 1], [-1, -1],
              [0, 1], [0, -1], [1, 0], [-1, 0]
            ], moves);
            break;
          case PieceType.king:
            _generateKingMoves(from, piece, moves);
            break;
        }
      }
    }

    return moves;
  }

  void _generatePawnMoves(Square from, ChessPiece piece, List<ChessMove> moves) {
    final forward = piece.color == PieceColor.white ? 1 : -1;
    final startRank = piece.color == PieceColor.white ? 1 : 6;
    final promoRank = piece.color == PieceColor.white ? 7 : 0;

    // Single step forward
    final oneForwardRank = from.rank + forward;
    if (oneForwardRank >= 0 && oneForwardRank < 8 && pieceAt(from.file, oneForwardRank) == null) {
      final to = Square(from.file, oneForwardRank);
      if (oneForwardRank == promoRank) {
        for (final promo in [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight]) {
          moves.add(ChessMove(from: from, to: to, promotion: promo));
        }
      } else {
        moves.add(ChessMove(from: from, to: to));

        // Two steps forward
        final twoForwardRank = from.rank + 2 * forward;
        if (from.rank == startRank && pieceAt(from.file, twoForwardRank) == null) {
          moves.add(ChessMove(from: from, to: Square(from.file, twoForwardRank)));
        }
      }
    }

    // Captures
    for (final df in [-1, 1]) {
      final targetFile = from.file + df;
      final targetRank = from.rank + forward;
      if (targetFile >= 0 && targetFile < 8 && targetRank >= 0 && targetRank < 8) {
        final targetPiece = pieceAt(targetFile, targetRank);
        final targetSquare = Square(targetFile, targetRank);

        if (targetPiece != null && targetPiece.color != piece.color) {
          if (targetRank == promoRank) {
            for (final promo in [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight]) {
              moves.add(ChessMove(from: from, to: targetSquare, promotion: promo, isCapture: true));
            }
          } else {
            moves.add(ChessMove(from: from, to: targetSquare, isCapture: true));
          }
        } else if (_enPassantSquare != null && _enPassantSquare == targetSquare) {
          moves.add(ChessMove(from: from, to: targetSquare, isCapture: true, isEnPassant: true));
        }
      }
    }
  }

  void _generateKnightMoves(Square from, ChessPiece piece, List<ChessMove> moves) {
    final offsets = [
      [-2, -1], [-2, 1], [-1, -2], [-1, 2],
      [1, -2], [1, 2], [2, -1], [2, 1]
    ];
    for (final offset in offsets) {
      final f = from.file + offset[0];
      final r = from.rank + offset[1];
      if (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final target = pieceAt(f, r);
        if (target == null) {
          moves.add(ChessMove(from: from, to: Square(f, r)));
        } else if (target.color != piece.color) {
          moves.add(ChessMove(from: from, to: Square(f, r), isCapture: true));
        }
      }
    }
  }

  void _generateRayMoves(Square from, ChessPiece piece, List<List<int>> directions, List<ChessMove> moves) {
    for (final dir in directions) {
      int f = from.file + dir[0];
      int r = from.rank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final target = pieceAt(f, r);
        if (target == null) {
          moves.add(ChessMove(from: from, to: Square(f, r)));
        } else {
          if (target.color != piece.color) {
            moves.add(ChessMove(from: from, to: Square(f, r), isCapture: true));
          }
          break;
        }
        f += dir[0];
        r += dir[1];
      }
    }
  }

  void _generateKingMoves(Square from, ChessPiece piece, List<ChessMove> moves) {
    for (int df = -1; df <= 1; df++) {
      for (int dr = -1; dr <= 1; dr++) {
        if (df == 0 && dr == 0) continue;
        final f = from.file + df;
        final r = from.rank + dr;
        if (f >= 0 && f < 8 && r >= 0 && r < 8) {
          final target = pieceAt(f, r);
          if (target == null) {
            moves.add(ChessMove(from: from, to: Square(f, r)));
          } else if (target.color != piece.color) {
            moves.add(ChessMove(from: from, to: Square(f, r), isCapture: true));
          }
        }
      }
    }

    // Castling
    if (piece.color == PieceColor.white && from == const Square(4, 0)) {
      if (_whiteCanCastleKingSide &&
          pieceAt(5, 0) == null &&
          pieceAt(6, 0) == null &&
          !isSquareAttackedBy(const Square(4, 0), PieceColor.black) &&
          !isSquareAttackedBy(const Square(5, 0), PieceColor.black) &&
          !isSquareAttackedBy(const Square(6, 0), PieceColor.black)) {
        moves.add(const ChessMove(from: Square(4, 0), to: Square(6, 0), isCastling: true));
      }
      if (_whiteCanCastleQueenSide &&
          pieceAt(3, 0) == null &&
          pieceAt(2, 0) == null &&
          pieceAt(1, 0) == null &&
          !isSquareAttackedBy(const Square(4, 0), PieceColor.black) &&
          !isSquareAttackedBy(const Square(3, 0), PieceColor.black) &&
          !isSquareAttackedBy(const Square(2, 0), PieceColor.black)) {
        moves.add(const ChessMove(from: Square(4, 0), to: Square(2, 0), isCastling: true));
      }
    } else if (piece.color == PieceColor.black && from == const Square(4, 7)) {
      if (_blackCanCastleKingSide &&
          pieceAt(5, 7) == null &&
          pieceAt(6, 7) == null &&
          !isSquareAttackedBy(const Square(4, 7), PieceColor.white) &&
          !isSquareAttackedBy(const Square(5, 7), PieceColor.white) &&
          !isSquareAttackedBy(const Square(6, 7), PieceColor.white)) {
        moves.add(const ChessMove(from: Square(4, 7), to: Square(6, 7), isCastling: true));
      }
      if (_blackCanCastleQueenSide &&
          pieceAt(3, 7) == null &&
          pieceAt(2, 7) == null &&
          pieceAt(1, 7) == null &&
          !isSquareAttackedBy(const Square(4, 7), PieceColor.white) &&
          !isSquareAttackedBy(const Square(3, 7), PieceColor.white) &&
          !isSquareAttackedBy(const Square(2, 7), PieceColor.white)) {
        moves.add(const ChessMove(from: Square(4, 7), to: Square(2, 7), isCastling: true));
      }
    }
  }

  bool makeMove(ChessMove move, {bool validateLegality = true}) {
    if (validateLegality) {
      final legalMoves = generateLegalMoves();
      final isLegal = legalMoves.any((m) =>
          m.from == move.from &&
          m.to == move.to &&
          (move.promotion == null || m.promotion == move.promotion));
      if (!isLegal) return false;
    }

    final piece = getPiece(move.from);
    if (piece == null) return false;

    final capturedPiece = getPiece(move.to);

    // Save undo state
    _history.add(_UndoState(
      move: move,
      piece: piece,
      capturedPiece: capturedPiece,
      whiteCanCastleKingSide: _whiteCanCastleKingSide,
      whiteCanCastleQueenSide: _whiteCanCastleQueenSide,
      blackCanCastleKingSide: _blackCanCastleKingSide,
      blackCanCastleQueenSide: _blackCanCastleQueenSide,
      enPassantSquare: _enPassantSquare,
      halfmoveClock: _halfmoveClock,
      fullmoveNumber: _fullmoveNumber,
    ));

    // Handle en passant capture
    if (move.isEnPassant || (piece.type == PieceType.pawn && _enPassantSquare == move.to)) {
      final epRank = piece.color == PieceColor.white ? move.to.rank - 1 : move.to.rank + 1;
      _board[epRank][move.to.file] = null;
    }

    // Move the piece
    _board[move.from.rank][move.from.file] = null;
    if (move.promotion != null) {
      _board[move.to.rank][move.to.file] = ChessPiece(type: move.promotion!, color: piece.color);
    } else {
      _board[move.to.rank][move.to.file] = piece;
    }

    // Handle castling rook movement
    if (piece.type == PieceType.king && (move.to.file - move.from.file).abs() == 2) {
      if (move.to.file == 6) {
        // Kingside castling
        final rook = _board[move.from.rank][7];
        _board[move.from.rank][7] = null;
        _board[move.from.rank][5] = rook;
      } else if (move.to.file == 2) {
        // Queenside castling
        final rook = _board[move.from.rank][0];
        _board[move.from.rank][0] = null;
        _board[move.from.rank][3] = rook;
      }
    }

    // Update en passant square
    if (piece.type == PieceType.pawn && (move.to.rank - move.from.rank).abs() == 2) {
      _enPassantSquare = Square(move.from.file, (move.from.rank + move.to.rank) ~/ 2);
    } else {
      _enPassantSquare = null;
    }

    // Update castling rights
    if (piece.type == PieceType.king) {
      if (piece.color == PieceColor.white) {
        _whiteCanCastleKingSide = false;
        _whiteCanCastleQueenSide = false;
      } else {
        _blackCanCastleKingSide = false;
        _blackCanCastleQueenSide = false;
      }
    } else if (piece.type == PieceType.rook) {
      if (move.from == const Square(0, 0)) _whiteCanCastleQueenSide = false;
      if (move.from == const Square(7, 0)) _whiteCanCastleKingSide = false;
      if (move.from == const Square(0, 7)) _blackCanCastleQueenSide = false;
      if (move.from == const Square(7, 7)) _blackCanCastleKingSide = false;
    }

    // If opponent rook is captured in corner
    if (move.to == const Square(0, 0)) _whiteCanCastleQueenSide = false;
    if (move.to == const Square(7, 0)) _whiteCanCastleKingSide = false;
    if (move.to == const Square(0, 7)) _blackCanCastleQueenSide = false;
    if (move.to == const Square(7, 7)) _blackCanCastleKingSide = false;

    // Halfmove clock & fullmove number
    if (piece.type == PieceType.pawn || capturedPiece != null) {
      _halfmoveClock = 0;
    } else {
      _halfmoveClock++;
    }

    if (_turn == PieceColor.black) {
      _fullmoveNumber++;
    }

    _turn = _turn.opposite;
    return true;
  }

  bool undoMove() {
    if (_history.isEmpty) return false;
    final state = _history.removeLast();

    _turn = state.piece.color;
    _whiteCanCastleKingSide = state.whiteCanCastleKingSide;
    _whiteCanCastleQueenSide = state.whiteCanCastleQueenSide;
    _blackCanCastleKingSide = state.blackCanCastleKingSide;
    _blackCanCastleQueenSide = state.blackCanCastleQueenSide;
    _enPassantSquare = state.enPassantSquare;
    _halfmoveClock = state.halfmoveClock;
    _fullmoveNumber = state.fullmoveNumber;

    // Restore moved piece
    _board[state.move.from.rank][state.move.from.file] = state.piece;
    _board[state.move.to.rank][state.move.to.file] = state.capturedPiece;

    // Handle castling undo
    if (state.piece.type == PieceType.king && (state.move.to.file - state.move.from.file).abs() == 2) {
      if (state.move.to.file == 6) {
        final rook = _board[state.move.from.rank][5];
        _board[state.move.from.rank][5] = null;
        _board[state.move.from.rank][7] = rook;
      } else if (state.move.to.file == 2) {
        final rook = _board[state.move.from.rank][3];
        _board[state.move.from.rank][3] = null;
        _board[state.move.from.rank][0] = rook;
      }
    }

    // Handle en passant undo
    if (state.move.isEnPassant || (state.piece.type == PieceType.pawn && state.move.to == state.enPassantSquare)) {
      final epRank = state.piece.color == PieceColor.white ? state.move.to.rank - 1 : state.move.to.rank + 1;
      _board[epRank][state.move.to.file] = ChessPiece(type: PieceType.pawn, color: state.piece.color.opposite);
      _board[state.move.to.rank][state.move.to.file] = null;
    }

    return true;
  }

  GameState getGameState() {
    final legalMoves = generateLegalMoves();
    if (legalMoves.isEmpty) {
      if (isKingInCheck(_turn)) {
        return GameState.checkmate;
      }
      return GameState.stalemate;
    }
    if (isKingInCheck(_turn)) {
      return GameState.check;
    }
    if (_halfmoveClock >= 100) {
      return GameState.draw;
    }
    return GameState.inProgress;
  }

  ChessMove? parseUci(String uci) {
    if (uci.length < 4) return null;
    final from = Square.fromAlgebraic(uci.substring(0, 2));
    final to = Square.fromAlgebraic(uci.substring(2, 4));
    if (from == null || to == null) return null;

    PieceType? promo;
    if (uci.length >= 5) {
      promo = PieceType.fromSymbol(uci[4]);
    }

    final legalMoves = generateLegalMoves();
    for (final m in legalMoves) {
      if (m.from == from && m.to == to) {
        if (promo == null || m.promotion == promo) {
          return m;
        }
      }
    }
    return ChessMove(from: from, to: to, promotion: promo);
  }
}

class _UndoState {
  final ChessMove move;
  final ChessPiece piece;
  final ChessPiece? capturedPiece;
  final bool whiteCanCastleKingSide;
  final bool whiteCanCastleQueenSide;
  final bool blackCanCastleKingSide;
  final bool blackCanCastleQueenSide;
  final Square? enPassantSquare;
  final int halfmoveClock;
  final int fullmoveNumber;

  const _UndoState({
    required this.move,
    required this.piece,
    this.capturedPiece,
    required this.whiteCanCastleKingSide,
    required this.whiteCanCastleQueenSide,
    required this.blackCanCastleKingSide,
    required this.blackCanCastleQueenSide,
    required this.enPassantSquare,
    required this.halfmoveClock,
    required this.fullmoveNumber,
  });
}

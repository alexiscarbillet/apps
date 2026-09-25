import 'package:flutter_test/flutter_test.dart';
import 'package:chess_puzzles/core/chess/chess_models.dart';
import 'package:chess_puzzles/core/chess/chess_engine.dart';

void main() {
  group('ChessEngine', () {
    test('Initial board setup and legal moves count', () {
      final engine = ChessEngine();
      expect(engine.turn, PieceColor.white);
      expect(engine.getPiece(const Square(4, 1))?.type, PieceType.pawn);
      expect(engine.getPiece(const Square(4, 0))?.type, PieceType.king);

      final moves = engine.generateLegalMoves();
      // In initial chess position, white has 16 pawn moves (8 single + 8 double) + 4 knight moves = 20 moves
      expect(moves.length, 20);
    });

    test('Scholar\'s mate sequence', () {
      final engine = ChessEngine();
      // 1. e4 e5
      expect(engine.makeMove(engine.parseUci('e2e4')!), isTrue);
      expect(engine.makeMove(engine.parseUci('e7e5')!), isTrue);
      // 2. Qh5 Nc6
      expect(engine.makeMove(engine.parseUci('d1h5')!), isTrue);
      expect(engine.makeMove(engine.parseUci('b8c6')!), isTrue);
      // 3. Bc4 Nf6??
      expect(engine.makeMove(engine.parseUci('f1c4')!), isTrue);
      expect(engine.makeMove(engine.parseUci('g8f6')!), isTrue);
      // 4. Qxf7# Checkmate!
      expect(engine.makeMove(engine.parseUci('h5f7')!), isTrue);

      expect(engine.getGameState(), GameState.checkmate);
      expect(engine.generateLegalMoves().isEmpty, isTrue);
    });

    test('FEN parsing and generation round-trip', () {
      const fen = 'r1bqk2r/pp2bppp/2n1pn2/3p4/2PP4/2N2NP1/PP3PBP/R1BQK2R b KQkq - 2 8';
      final engine = ChessEngine(fen);
      expect(engine.turn, PieceColor.black);
      expect(engine.generateFen(), fen);
    });

    test('Pawn promotion move execution', () {
      // White pawn at e7 ready to promote on e8 (e8 is empty, black king on a8)
      const fen = 'k7/4P3/8/8/8/8/8/4K3 w - - 0 1';
      final engine = ChessEngine(fen);
      final move = engine.parseUci('e7e8q');
      expect(move, isNotNull);
      expect(engine.makeMove(move!), isTrue);

      final queen = engine.getPiece(const Square(4, 7));
      expect(queen?.type, PieceType.queen);
      expect(queen?.color, PieceColor.white);
    });

    test('Castling kingside and queenside', () {
      // White can castle kingside
      const fen = 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1';
      final engine = ChessEngine(fen);
      final moveO_O = engine.parseUci('e1g1');
      expect(moveO_O, isNotNull);
      expect(engine.makeMove(moveO_O!), isTrue);

      expect(engine.getPiece(const Square(6, 0))?.type, PieceType.king);
      expect(engine.getPiece(const Square(5, 0))?.type, PieceType.rook);
      expect(engine.getPiece(const Square(7, 0)), isNull);
    });
  });
}

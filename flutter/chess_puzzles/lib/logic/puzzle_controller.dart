import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/chess/chess_models.dart';
import '../core/chess/chess_engine.dart';
import '../core/audio/sound_service.dart';
import '../core/storage/local_storage.dart';
import '../data/models/puzzle_model.dart';

enum PuzzleSolveStatus {
  ready,
  inProgress,
  correctMove,
  wrongMove,
  opponentThinking,
  solved,
  failed,
}

class PuzzleController extends ChangeNotifier {
  ChessPuzzle _puzzle;
  late ChessEngine _engine;
  PuzzleSolveStatus _status = PuzzleSolveStatus.ready;
  int _moveIndex = 0;
  Square? _selectedSquare;
  List<ChessMove> _selectedSquareLegalMoves = [];
  ChessMove? _lastMove;
  Square? _hintSourceSquare;
  Square? _hintTargetSquare;
  int _hintsUsed = 0;
  int _mistakesCount = 0;
  bool _isAutoPlaying = false;

  PuzzleController(this._puzzle) {
    _initPuzzle();
  }

  ChessPuzzle get puzzle => _puzzle;
  ChessEngine get engine => _engine;
  PuzzleSolveStatus get status => _status;
  int get moveIndex => _moveIndex;
  Square? get selectedSquare => _selectedSquare;
  List<ChessMove> get selectedSquareLegalMoves => _selectedSquareLegalMoves;
  ChessMove? get lastMove => _lastMove;
  Square? get hintSourceSquare => _hintSourceSquare;
  Square? get hintTargetSquare => _hintTargetSquare;
  int get hintsUsed => _hintsUsed;
  int get mistakesCount => _mistakesCount;
  bool get isAutoPlaying => _isAutoPlaying;

  void loadPuzzle(ChessPuzzle newPuzzle) {
    _puzzle = newPuzzle;
    _initPuzzle();
  }

  void _initPuzzle() {
    _engine = ChessEngine(_puzzle.fen);
    _status = PuzzleSolveStatus.ready;
    _moveIndex = 0;
    _selectedSquare = null;
    _selectedSquareLegalMoves = [];
    _lastMove = null;
    _hintSourceSquare = null;
    _hintTargetSquare = null;
    _hintsUsed = 0;
    _mistakesCount = 0;
    _isAutoPlaying = false;
    notifyListeners();
  }

  void selectSquare(Square square) {
    if (_status == PuzzleSolveStatus.solved || _status == PuzzleSolveStatus.opponentThinking || _isAutoPlaying) {
      return;
    }

    final piece = _engine.getPiece(square);

    // If currently a square is selected and tapped another square, try to move
    if (_selectedSquare != null) {
      if (_selectedSquare == square) {
        _selectedSquare = null;
        _selectedSquareLegalMoves = [];
        notifyListeners();
        return;
      }

      // Check if moving to this square
      final moveMatch = _selectedSquareLegalMoves.where((m) => m.to == square);
      if (moveMatch.isNotEmpty) {
        // If pawn promotion needed, check
        final pieceToMove = _engine.getPiece(_selectedSquare!);
        if (pieceToMove != null &&
            pieceToMove.type == PieceType.pawn &&
            (square.rank == 7 || square.rank == 0)) {
          // Trigger promotion selection
          _pendingPromotionFrom = _selectedSquare;
          _pendingPromotionTo = square;
          notifyListeners();
          return;
        }

        tryPlayerMove(_selectedSquare!, square);
        _selectedSquare = null;
        _selectedSquareLegalMoves = [];
        return;
      }
    }

    // Select piece if it's the player's piece
    if (piece != null && piece.color == _puzzle.playerColor) {
      _selectedSquare = square;
      _selectedSquareLegalMoves =
          _engine.generateLegalMoves().where((m) => m.from == square).toList();
    } else {
      _selectedSquare = null;
      _selectedSquareLegalMoves = [];
    }

    notifyListeners();
  }

  Square? _pendingPromotionFrom;
  Square? _pendingPromotionTo;
  Square? get pendingPromotionFrom => _pendingPromotionFrom;
  Square? get pendingPromotionTo => _pendingPromotionTo;

  void confirmPromotion(PieceType promoType) {
    if (_pendingPromotionFrom != null && _pendingPromotionTo != null) {
      tryPlayerMove(_pendingPromotionFrom!, _pendingPromotionTo!, promoType);
      _pendingPromotionFrom = null;
      _pendingPromotionTo = null;
      _selectedSquare = null;
      _selectedSquareLegalMoves = [];
      notifyListeners();
    }
  }

  void cancelPromotion() {
    _pendingPromotionFrom = null;
    _pendingPromotionTo = null;
    notifyListeners();
  }

  bool tryPlayerMove(Square from, Square to, [PieceType? promotion]) {
    if (_moveIndex >= _puzzle.moves.length) return false;

    final move = ChessMove(from: from, to: to, promotion: promotion);
    final expectedUci = _puzzle.moves[_moveIndex];

    // Check if the move matches the expected puzzle move
    final isCorrect = (move.uci.toLowerCase() == expectedUci.toLowerCase());

    if (isCorrect) {
      // Execute the correct move
      _engine.makeMove(move);
      _lastMove = move;
      _hintSourceSquare = null;
      _hintTargetSquare = null;
      _moveIndex++;

      if (move.isCapture) {
        SoundService.playCaptureSound();
      } else {
        SoundService.playMoveSound();
      }

      if (_moveIndex >= _puzzle.moves.length) {
        // Puzzle solved!
        _status = PuzzleSolveStatus.solved;
        LocalStorage.markPuzzleSolved(_puzzle.id);
        SoundService.playVictorySound();
        notifyListeners();
        return true;
      } else {
        // Correct move, waiting for opponent's reply
        _status = PuzzleSolveStatus.opponentThinking;
        notifyListeners();

        // Play opponent response with slight delay
        Timer(const Duration(milliseconds: 450), () {
          _playOpponentMove();
        });
        return true;
      }
    } else {
      // Wrong move
      _mistakesCount++;
      _status = PuzzleSolveStatus.wrongMove;
      SoundService.playMistakeSound();
      notifyListeners();
      return false;
    }
  }

  void _playOpponentMove() {
    if (_moveIndex >= _puzzle.moves.length) return;

    final oppUci = _puzzle.moves[_moveIndex];
    final oppMove = _engine.parseUci(oppUci);

    if (oppMove != null) {
      _engine.makeMove(oppMove);
      _lastMove = oppMove;
      _moveIndex++;

      if (oppMove.isCapture) {
        SoundService.playCaptureSound();
      } else {
        SoundService.playMoveSound();
      }

      _status = PuzzleSolveStatus.inProgress;
      notifyListeners();
    }
  }

  void retryCurrentPosition() {
    _status = PuzzleSolveStatus.inProgress;
    _selectedSquare = null;
    _selectedSquareLegalMoves = [];
    notifyListeners();
  }

  void resetPuzzle() {
    _initPuzzle();
  }

  void requestHint() {
    if (_moveIndex >= _puzzle.moves.length) return;
    final targetUci = _puzzle.moves[_moveIndex];
    final from = Square.fromAlgebraic(targetUci.substring(0, 2));
    final to = Square.fromAlgebraic(targetUci.substring(2, 4));

    _hintsUsed++;

    if (_hintSourceSquare == null) {
      // Hint 1: Show source piece
      _hintSourceSquare = from;
    } else {
      // Hint 2: Show target square
      _hintTargetSquare = to;
    }

    notifyListeners();
  }

  Future<void> autoPlaySolution() async {
    _isAutoPlaying = true;
    notifyListeners();

    while (_moveIndex < _puzzle.moves.length) {
      final uci = _puzzle.moves[_moveIndex];
      final move = _engine.parseUci(uci);
      if (move != null) {
        _engine.makeMove(move);
        _lastMove = move;
        _moveIndex++;
        SoundService.playMoveSound();
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        break;
      }
    }

    _status = PuzzleSolveStatus.solved;
    _isAutoPlaying = false;
    notifyListeners();
  }
}

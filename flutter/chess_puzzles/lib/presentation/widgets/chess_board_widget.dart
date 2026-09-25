import 'package:flutter/material.dart';
import '../../core/chess/chess_models.dart';
import '../../core/theme/board_themes.dart';
import '../../logic/puzzle_controller.dart';
import 'chess_piece_widget.dart';
import 'promotion_dialog.dart';

class ChessBoardWidget extends StatefulWidget {
  final PuzzleController controller;
  final BoardThemeType theme;
  final bool showCoordinates;
  final bool isFlipped;

  const ChessBoardWidget({
    super.key,
    required this.controller,
    this.theme = BoardThemeType.walnut,
    this.showCoordinates = true,
    this.isFlipped = false,
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    widget.controller.addListener(_handleStateChange);
  }

  @override
  void didUpdateWidget(covariant ChessBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleStateChange);
      widget.controller.addListener(_handleStateChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChange);
    _shakeController.dispose();
    super.dispose();
  }

  void _handleStateChange() {
    if (widget.controller.status == PuzzleSolveStatus.wrongMove) {
      _shakeController.forward(from: 0.0);
    }

    if (widget.controller.pendingPromotionFrom != null &&
        widget.controller.pendingPromotionTo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPromotionDialog();
      });
    }
  }

  void _showPromotionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PromotionDialog(
        color: widget.controller.puzzle.playerColor,
        onSelect: (type) {
          widget.controller.confirmPromotion(type);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _shakeAnimation]),
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.theme.borderColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final squareSize = constraints.maxWidth / 8;
                    return Stack(
                      children: [
                        // 8x8 Board Grid
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                          ),
                          itemCount: 64,
                          itemBuilder: (context, index) {
                            final row = index ~/ 8;
                            final col = index % 8;

                            // Transform board coordinates based on orientation (White perspective: rank 8 at top, rank 1 at bottom)
                            final rank = widget.isFlipped ? row : (7 - row);
                            final file = widget.isFlipped ? (7 - col) : col;
                            final square = Square(file, rank);

                            return _buildSquare(square, squareSize, row, col);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSquare(Square square, double size, int row, int col) {
    final isLight = square.isLightSquare;
    final baseColor = isLight ? widget.theme.lightSquare : widget.theme.darkSquare;
    final piece = widget.controller.engine.getPiece(square);

    final isSelected = widget.controller.selectedSquare == square;
    final isLastMoveFrom = widget.controller.lastMove?.from == square;
    final isLastMoveTo = widget.controller.lastMove?.to == square;
    final isHintSource = widget.controller.hintSourceSquare == square;
    final isHintTarget = widget.controller.hintTargetSquare == square;

    // Check if legal move destination
    final legalMove = widget.controller.selectedSquareLegalMoves.firstWhere(
      (m) => m.to == square,
      orElse: () => const ChessMove(from: Square(0, 0), to: Square(0, 0)),
    );
    final isLegalDestination = widget.controller.selectedSquareLegalMoves.any((m) => m.to == square);

    // In-check king glow
    final isKingInCheck = widget.controller.engine.getGameState() == GameState.check &&
        piece?.type == PieceType.king &&
        piece?.color == widget.controller.engine.turn;

    Color squareColor = baseColor;
    if (isSelected) {
      squareColor = Color.alphaBlend(widget.theme.selectedSquareHighlight, baseColor);
    } else if (isLastMoveFrom || isLastMoveTo) {
      squareColor = Color.alphaBlend(widget.theme.lastMoveHighlight, baseColor);
    }

    return DragTarget<Square>(
      onWillAcceptWithDetails: (details) {
        final from = details.data;
        return widget.controller.engine
            .generateLegalMoves()
            .any((m) => m.from == from && m.to == square);
      },
      onAcceptWithDetails: (details) {
        final from = details.data;
        final pieceToMove = widget.controller.engine.getPiece(from);
        if (pieceToMove != null &&
            pieceToMove.type == PieceType.pawn &&
            (square.rank == 7 || square.rank == 0)) {
          // Pawn promotion
          widget.controller.selectSquare(from);
          widget.controller.selectSquare(square);
        } else {
          widget.controller.tryPlayerMove(from, square);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () => widget.controller.selectSquare(square),
          child: Container(
            color: squareColor,
            child: Stack(
              children: [
                // Hint glow
                if (isHintSource || isHintTarget)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isHintSource ? Colors.cyanAccent : Colors.greenAccent,
                        width: 3.5,
                      ),
                      color: (isHintSource ? Colors.cyanAccent : Colors.greenAccent)
                          .withValues(alpha: 0.3),
                    ),
                  ),

                // Check Red Aura
                if (isKingInCheck)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                  ),

                // Coordinates label (rank on left col, file on bottom row)
                if (widget.showCoordinates) ...[
                  if (col == 0)
                    Positioned(
                      top: 2,
                      left: 3,
                      child: Text(
                        '${square.rank + 1}',
                        style: TextStyle(
                          fontSize: size * 0.22,
                          fontWeight: FontWeight.bold,
                          color: isLight ? widget.theme.darkSquare : widget.theme.lightSquare,
                        ),
                      ),
                    ),
                  if (row == 7)
                    Positioned(
                      bottom: 2,
                      right: 3,
                      child: Text(
                        String.fromCharCode('a'.codeUnitAt(0) + square.file),
                        style: TextStyle(
                          fontSize: size * 0.22,
                          fontWeight: FontWeight.bold,
                          color: isLight ? widget.theme.darkSquare : widget.theme.lightSquare,
                        ),
                      ),
                    ),
                ],

                // Legal Move Indicators
                if (isLegalDestination)
                  Center(
                    child: piece == null
                        ? Container(
                            width: size * 0.3,
                            height: size * 0.3,
                            decoration: BoxDecoration(
                              color: widget.theme.legalMoveDot,
                              shape: BoxShape.circle,
                            ),
                          )
                        : Container(
                            width: size * 0.85,
                            height: size * 0.85,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.theme.legalCaptureRing,
                                width: size * 0.08,
                              ),
                            ),
                          ),
                  ),

                // Chess Piece
                if (piece != null)
                  Center(
                    child: Draggable<Square>(
                      data: square,
                      maxSimultaneousDrags: (piece.color == widget.controller.puzzle.playerColor &&
                              widget.controller.status != PuzzleSolveStatus.solved &&
                              widget.controller.status != PuzzleSolveStatus.opponentThinking)
                          ? 1
                          : 0,
                      feedback: Material(
                        color: Colors.transparent,
                        child: ChessPieceWidget(
                          piece: piece,
                          size: size * 1.15,
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: ChessPieceWidget(
                          piece: piece,
                          size: size * 0.82,
                        ),
                      ),
                      child: ChessPieceWidget(
                        piece: piece,
                        size: size * 0.82,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../logic/puzzle_rush_controller.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/board_themes.dart';
import '../widgets/chess_board_widget.dart';

class PuzzleRushScreen extends StatefulWidget {
  final PuzzleRushMode mode;

  const PuzzleRushScreen({
    super.key,
    this.mode = PuzzleRushMode.survival3Strikes,
  });

  @override
  State<PuzzleRushScreen> createState() => _PuzzleRushScreenState();
}

class _PuzzleRushScreenState extends State<PuzzleRushScreen> {
  late PuzzleRushController _rushController;
  BoardThemeType _boardTheme = BoardThemeType.walnut;
  bool _showCoordinates = true;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _boardTheme = LocalStorage.getBoardTheme();
    _showCoordinates = LocalStorage.getShowCoordinates();

    _rushController = PuzzleRushController(mode: widget.mode);
    _rushController.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _rushController.removeListener(_onStateChanged);
    _rushController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_rushController.currentPuzzle != null) {
      _isFlipped = _rushController.currentPuzzle!.playerColor.name == 'black';
    }

    if (_rushController.isGameOver) {
      _showGameOverDialog();
    }
    setState(() {});
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flash_on, color: AppTheme.accentGold, size: 54),
              ),
              const SizedBox(height: 16),
              const Text(
                'Rush Over!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Solved: ${_rushController.score} Puzzles',
                style: const TextStyle(fontSize: 20, color: AppTheme.accentEmerald, fontWeight: FontWeight.bold),
              ),
              if (_rushController.isNewHighScore) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentGold),
                  ),
                  child: const Text(
                    '🏆 NEW HIGH SCORE! 🏆',
                    style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFF475569)),
                      ),
                      child: const Text('Quit', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _rushController.startNewGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = _rushController.currentPuzzle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Rush', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: 'Skip Puzzle (Count as Strike)',
            onPressed: () => _rushController.skipPuzzle(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score & Lives/Timer Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score
                  Row(
                    children: [
                      const Icon(Icons.flash_on, color: AppTheme.accentGold, size: 28),
                      const SizedBox(width: 6),
                      Text(
                        '${_rushController.score}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Timer or Strikes
                  if (widget.mode == PuzzleRushMode.blitz3Minutes)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: AppTheme.accentCyan, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${_rushController.timeRemainingSeconds ~/ 60}:${(_rushController.timeRemainingSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                  // Strikes ❤️❤️❤️
                  Row(
                    children: List.generate(_rushController.maxStrikes, (index) {
                      final isLost = index < _rushController.strikes;
                      return Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          isLost ? Icons.favorite_border : Icons.favorite,
                          color: isLost ? const Color(0xFF475569) : Colors.redAccent,
                          size: 26,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            if (puzzle != null) ...[
              // Active puzzle prompt
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  '${puzzle.playerColor.displayName} to play • Rating ${puzzle.rating}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),

              // Chess Board
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ChessBoardWidget(
                      controller: _rushController.currentPuzzleController,
                      theme: _boardTheme,
                      showCoordinates: _showCoordinates,
                      isFlipped: _isFlipped,
                    ),
                  ),
                ),
              ),
            ] else
              const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}

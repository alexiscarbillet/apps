import 'package:flutter/material.dart';
import '../../logic/daily_puzzle_controller.dart';
import '../../logic/puzzle_controller.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/board_themes.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/victory_dialog.dart';

class DailyPuzzleScreen extends StatefulWidget {
  const DailyPuzzleScreen({super.key});

  @override
  State<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends State<DailyPuzzleScreen> {
  late DailyPuzzleController _dailyController;
  late PuzzleController _puzzleController;
  BoardThemeType _boardTheme = BoardThemeType.walnut;
  bool _showCoordinates = true;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _boardTheme = LocalStorage.getBoardTheme();
    _showCoordinates = LocalStorage.getShowCoordinates();

    _dailyController = DailyPuzzleController();
    _dailyController.addListener(_onDailyStateChanged);

    _puzzleController = PuzzleController(_dailyController.currentPuzzle);
    _puzzleController.addListener(_onPuzzleSolved);

    _isFlipped = _dailyController.currentPuzzle.playerColor.name == 'black';
  }

  @override
  void dispose() {
    _dailyController.removeListener(_onDailyStateChanged);
    _puzzleController.removeListener(_onPuzzleSolved);
    _dailyController.dispose();
    _puzzleController.dispose();
    super.dispose();
  }

  void _onDailyStateChanged() {
    if (_puzzleController.puzzle.id != _dailyController.currentPuzzle.id) {
      _puzzleController.loadPuzzle(_dailyController.currentPuzzle);
      setState(() {
        _isFlipped = _dailyController.currentPuzzle.playerColor.name == 'black';
      });
    }
    setState(() {});
  }

  void _onPuzzleSolved() {
    if (_puzzleController.status == PuzzleSolveStatus.solved) {
      _dailyController.markCurrentCompleted();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => VictoryDialog(
          puzzle: _puzzleController.puzzle,
          mistakes: _puzzleController.mistakesCount,
          hintsUsed: _puzzleController.hintsUsed,
          onNext: () {
            if (_dailyController.isAllCompleted) {
              _showDailyCompletedCelebration();
            } else {
              _dailyController.nextPuzzle();
            }
          },
          onRetry: () => _puzzleController.resetPuzzle(),
        ),
      );
    }
    setState(() {});
  }

  void _showDailyCompletedCelebration() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department, color: AppTheme.accentGold, size: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                'Daily 5 Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Streak: ${LocalStorage.getDailyStreak()} Days 🔥',
                style: const TextStyle(fontSize: 18, color: AppTheme.accentGold, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'You solved all 5 puzzles today! Come back tomorrow for a fresh batch of tactical challenges.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentEmerald,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = _dailyController.currentPuzzle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily 5 Challenge', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            tooltip: 'Flip Board',
            onPressed: () => setState(() => _isFlipped = !_isFlipped),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Stepper Bar (Puzzles 1..5)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(5, (index) {
                  final isCurrent = index == _dailyController.currentIndex;
                  final isDone = _dailyController.completedIndices.contains(index);

                  Color dotColor = const Color(0xFF334155);
                  if (isDone) dotColor = AppTheme.accentEmerald;
                  else if (isCurrent) dotColor = AppTheme.accentGold;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _dailyController.selectPuzzleIndex(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 38,
                        decoration: BoxDecoration(
                          color: dotColor.withValues(alpha: isDone ? 0.25 : (isCurrent ? 0.35 : 0.1)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCurrent ? AppTheme.accentGold : (isDone ? AppTheme.accentEmerald : Colors.transparent),
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isDone)
                              const Icon(Icons.check, size: 16, color: AppTheme.accentEmerald)
                            else
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? Colors.white : Colors.white60,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Puzzle Info Header Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPurple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(puzzle.theme.icon, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            puzzle.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${puzzle.playerColor.displayName} to play • ${puzzle.theme.title} • Rating ${puzzle.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Chess Board
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ChessBoardWidget(
                    controller: _puzzleController,
                    theme: _boardTheme,
                    showCoordinates: _showCoordinates,
                    isFlipped: _isFlipped,
                  ),
                ),
              ),
            ),

            // Status message
            if (_puzzleController.status == PuzzleSolveStatus.wrongMove)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'Incorrect move. Try again!',
                  style: TextStyle(
                    color: Colors.redAccent.shade100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Bottom Actions Bar (Hint, Retry, Auto-play, Next)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.lightbulb_outline,
                    label: 'Hint',
                    color: AppTheme.accentCyan,
                    onTap: () => _puzzleController.requestHint(),
                  ),
                  _buildActionButton(
                    icon: Icons.refresh,
                    label: 'Reset',
                    color: Colors.white70,
                    onTap: () => _puzzleController.resetPuzzle(),
                  ),
                  _buildActionButton(
                    icon: Icons.play_arrow,
                    label: 'Solve',
                    color: AppTheme.accentPurple,
                    onTap: () => _puzzleController.autoPlaySolution(),
                  ),
                  _buildActionButton(
                    icon: Icons.skip_next,
                    label: 'Next',
                    color: AppTheme.accentGold,
                    onTap: () => _dailyController.nextPuzzle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

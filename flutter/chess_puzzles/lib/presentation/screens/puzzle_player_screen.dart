import 'package:flutter/material.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/random_puzzle_generator.dart';
import '../../logic/puzzle_controller.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/board_themes.dart';
import '../widgets/chess_board_widget.dart';
import '../widgets/victory_dialog.dart';

class PuzzlePlayerScreen extends StatefulWidget {
  final ChessPuzzle initialPuzzle;
  final List<ChessPuzzle>? playlist;
  final bool isRandomMode;

  const PuzzlePlayerScreen({
    super.key,
    required this.initialPuzzle,
    this.playlist,
    this.isRandomMode = false,
  });

  @override
  State<PuzzlePlayerScreen> createState() => _PuzzlePlayerScreenState();
}

class _PuzzlePlayerScreenState extends State<PuzzlePlayerScreen> {
  late PuzzleController _controller;
  int _playlistIndex = 0;
  BoardThemeType _boardTheme = BoardThemeType.walnut;
  bool _showCoordinates = true;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _boardTheme = LocalStorage.getBoardTheme();
    _showCoordinates = LocalStorage.getShowCoordinates();

    _controller = PuzzleController(widget.initialPuzzle);
    _controller.addListener(_onStateChanged);
    _isFlipped = widget.initialPuzzle.playerColor.name == 'black';

    if (widget.playlist != null) {
      _playlistIndex = widget.playlist!.indexWhere((p) => p.id == widget.initialPuzzle.id);
      if (_playlistIndex == -1) _playlistIndex = 0;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_controller.status == PuzzleSolveStatus.solved) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => VictoryDialog(
          puzzle: _controller.puzzle,
          mistakes: _controller.mistakesCount,
          hintsUsed: _controller.hintsUsed,
          onNext: () => _playNext(),
          onRetry: () => _controller.resetPuzzle(),
        ),
      );
    }
    setState(() {});
  }

  void _playNext() {
    if (widget.isRandomMode) {
      final next = RandomPuzzleGenerator.getRandomPuzzle();
      _controller.loadPuzzle(next);
      setState(() {
        _isFlipped = next.playerColor.name == 'black';
      });
    } else if (widget.playlist != null && widget.playlist!.isNotEmpty) {
      _playlistIndex = (_playlistIndex + 1) % widget.playlist!.length;
      final next = widget.playlist![_playlistIndex];
      _controller.loadPuzzle(next);
      setState(() {
        _isFlipped = next.playerColor.name == 'black';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = _controller.puzzle;

    return Scaffold(
      appBar: AppBar(
        title: Text(puzzle.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            // Puzzle Meta Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
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
                        color: AppTheme.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(puzzle.theme.icon, style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            puzzle.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${puzzle.playerColor.displayName} to play',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: puzzle.playerColor.name == 'white'
                                      ? Colors.white
                                      : Colors.amberAccent,
                                ),
                              ),
                              const Text(' • ', style: TextStyle(color: Colors.white38)),
                              Text(
                                '${puzzle.rating} Rating',
                                style: const TextStyle(fontSize: 12, color: AppTheme.accentPurple),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Chess Board
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ChessBoardWidget(
                    controller: _controller,
                    theme: _boardTheme,
                    showCoordinates: _showCoordinates,
                    isFlipped: _isFlipped,
                  ),
                ),
              ),
            ),

            // Status message
            if (_controller.status == PuzzleSolveStatus.wrongMove)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'Incorrect move. Try another idea!',
                  style: TextStyle(
                    color: Colors.redAccent.shade100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Bottom Actions Bar
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
                    onTap: () => _controller.requestHint(),
                  ),
                  _buildActionButton(
                    icon: Icons.refresh,
                    label: 'Reset',
                    color: Colors.white70,
                    onTap: () => _controller.resetPuzzle(),
                  ),
                  _buildActionButton(
                    icon: Icons.play_arrow,
                    label: 'Solve',
                    color: AppTheme.accentPurple,
                    onTap: () => _controller.autoPlaySolution(),
                  ),
                  _buildActionButton(
                    icon: Icons.skip_next,
                    label: 'Next',
                    color: AppTheme.accentGold,
                    onTap: () => _playNext(),
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

import 'package:flutter/material.dart';
import '../../data/models/puzzle_model.dart';
import '../../core/theme/app_theme.dart';

class VictoryDialog extends StatelessWidget {
  final ChessPuzzle puzzle;
  final int mistakes;
  final int hintsUsed;
  final VoidCallback onNext;
  final VoidCallback? onRetry;

  const VictoryDialog({
    super.key,
    required this.puzzle,
    required this.mistakes,
    required this.hintsUsed,
    required this.onNext,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final perfectSolve = (mistakes == 0 && hintsUsed == 0);

    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: perfectSolve ? AppTheme.accentGold : AppTheme.accentEmerald,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (perfectSolve ? AppTheme.accentGold : AppTheme.accentEmerald)
                    .withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                perfectSolve ? Icons.emoji_events : Icons.check_circle_outline,
                color: perfectSolve ? AppTheme.accentGold : AppTheme.accentEmerald,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              perfectSolve ? 'Flawless Victory!' : 'Puzzle Solved!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              puzzle.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 16),

            // Stars / Performance row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMetricChip(
                  icon: Icons.star,
                  label: perfectSolve ? '3 Stars' : (mistakes == 0 ? '2 Stars' : '1 Star'),
                  color: AppTheme.accentGold,
                ),
                const SizedBox(width: 8),
                _buildMetricChip(
                  icon: Icons.bolt,
                  label: '${puzzle.rating} Rating',
                  color: AppTheme.accentPurple,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tactical Explanation Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        puzzle.theme.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        puzzle.theme.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    puzzle.explanation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                if (onRetry != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry!();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF475569)),
                      ),
                      child: const Text('Retry', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onNext();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentEmerald,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

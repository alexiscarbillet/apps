import 'package:flutter/material.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../data/random_puzzle_generator.dart';
import 'daily_puzzle_screen.dart';
import 'puzzle_player_screen.dart';
import 'puzzle_rush_screen.dart';
import 'category_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dailyStreak = LocalStorage.getDailyStreak();
    final longestStreak = LocalStorage.getLongestStreak();
    final dailyCompleted = LocalStorage.getDailyCompletedIndices().length;
    final isDailyDone = LocalStorage.isDailyCompletedToday();
    final solvedCount = LocalStorage.getSolvedPuzzles().length;
    final rushHighScore = LocalStorage.getPuzzleRushHighScore();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield, color: AppTheme.accentGold, size: 24),
            SizedBox(width: 8),
            Text('Chess Tactics Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SettingsScreen(
                    onSettingsChanged: () => setState(() {}),
                  ),
                ),
              );
              _loadState();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Daily 5 Hero Card
            _buildDaily5HeroCard(dailyStreak, dailyCompleted, isDailyDone),

            const SizedBox(height: 18),

            // Game Modes Grid
            const Text(
              'Training Modes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildGameModeCard(
                    title: 'Random Puzzle',
                    subtitle: 'Instant tactical trainer',
                    icon: Icons.shuffle,
                    accentColor: AppTheme.accentCyan,
                    badge: 'Infinite',
                    onTap: () async {
                      final puzzle = RandomPuzzleGenerator.getRandomPuzzle();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => PuzzlePlayerScreen(
                            initialPuzzle: puzzle,
                            isRandomMode: true,
                          ),
                        ),
                      );
                      _loadState();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGameModeCard(
                    title: 'Puzzle Rush',
                    subtitle: '3 lives survival sprint',
                    icon: Icons.flash_on,
                    accentColor: AppTheme.accentGold,
                    badge: rushHighScore > 0 ? 'Best: $rushHighScore' : 'New',
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const PuzzleRushScreen(),
                        ),
                      );
                      _loadState();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildGameModeCard(
              title: 'Curated Puzzle Library',
              subtitle: 'Mate in 1/2, Forks, Pins, Endgames & GM Classics',
              icon: Icons.menu_book,
              accentColor: AppTheme.accentPurple,
              badge: '$solvedCount Solved',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const CategoryListScreen(),
                  ),
                );
                _loadState();
              },
            ),

            const SizedBox(height: 24),

            // Player Stats Section
            const Text(
              'Your Achievements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    label: 'Total Solved',
                    value: '$solvedCount',
                    icon: Icons.check_circle_outline,
                    color: AppTheme.accentEmerald,
                  ),
                  Container(width: 1, height: 40, color: const Color(0xFF334155)),
                  _buildStatItem(
                    label: 'Daily Streak',
                    value: '$dailyStreak Days',
                    icon: Icons.local_fire_department,
                    color: AppTheme.accentGold,
                  ),
                  Container(width: 1, height: 40, color: const Color(0xFF334155)),
                  _buildStatItem(
                    label: 'Best Rush',
                    value: '$rushHighScore',
                    icon: Icons.bolt,
                    color: AppTheme.accentCyan,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDaily5HeroCard(int streak, int completedCount, bool isDone) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDone
              ? [const Color(0xFF065F46), const Color(0xFF047857)]
              : [const Color(0xFF1E1B4B), const Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? AppTheme.accentEmerald : AppTheme.accentPurple.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDone ? AppTheme.accentEmerald : AppTheme.accentPurple).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentGold),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, color: AppTheme.accentGold, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$streak Day Streak',
                          style: const TextStyle(
                            color: AppTheme.accentGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '$completedCount / 5 Solved',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Daily 5 Puzzle Challenge',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isDone
                ? 'All 5 puzzles solved for today! Keep the flame alive tomorrow.'
                : 'Solve today\'s curated tactical set to build your daily streak.',
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),

          const SizedBox(height: 16),

          // 5 Progress Dots
          Row(
            children: List.generate(5, (index) {
              final isDotDone = index < completedCount;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: isDotDone ? AppTheme.accentEmerald : Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const DailyPuzzleScreen()),
              );
              _loadState();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDone ? AppTheme.accentEmerald : AppTheme.accentGold,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(48),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isDone
                      ? 'Review Today\'s Puzzles'
                      : (completedCount > 0 ? 'Continue Daily 5' : 'Start Daily 5'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameModeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required String badge,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: accentColor, size: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white60),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white60),
        ),
      ],
    );
  }
}

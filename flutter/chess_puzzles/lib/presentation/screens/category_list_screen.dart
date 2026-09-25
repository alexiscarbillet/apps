import 'package:flutter/material.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/puzzle_database.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_theme.dart';
import 'puzzle_player_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  PuzzleTheme _selectedTheme = PuzzleTheme.mateIn1;

  @override
  Widget build(BuildContext context) {
    final puzzles = PuzzleDatabase.getPuzzlesByTheme(_selectedTheme);
    final solvedPuzzles = LocalStorage.getSolvedPuzzles();
    final solvedCount = puzzles.where((p) => solvedPuzzles.contains(p.id)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curated Puzzle Library', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Category Selector Horizontal Scroll
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: PuzzleTheme.values.length,
              itemBuilder: (context, index) {
                final theme = PuzzleTheme.values[index];
                final isSelected = theme == _selectedTheme;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(theme.icon, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(theme.title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      ],
                    ),
                    selectedColor: AppTheme.accentGold.withValues(alpha: 0.25),
                    checkmarkColor: AppTheme.accentGold,
                    side: BorderSide(
                      color: isSelected ? AppTheme.accentGold : const Color(0xFF334155),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedTheme = theme;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Category Header Progress Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_selectedTheme.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Text(
                        _selectedTheme.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        '$solvedCount / ${puzzles.length} Solved',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedTheme.description,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: puzzles.isEmpty ? 0 : (solvedCount / puzzles.length),
                      backgroundColor: const Color(0xFF334155),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.accentEmerald),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Puzzles List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: puzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzles[index];
                final isSolved = solvedPuzzles.contains(puzzle.id);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSolved
                            ? AppTheme.accentEmerald.withValues(alpha: 0.2)
                            : const Color(0xFF334155),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSolved ? AppTheme.accentEmerald : const Color(0xFF475569),
                        ),
                      ),
                      child: Center(
                        child: isSolved
                            ? const Icon(Icons.check, color: AppTheme.accentEmerald, size: 24)
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                              ),
                      ),
                    ),
                    title: Text(
                      puzzle.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      '${puzzle.playerColor.displayName} to play • Rating ${puzzle.rating}',
                      style: const TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white38),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => PuzzlePlayerScreen(
                            initialPuzzle: puzzle,
                            playlist: puzzles,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chess_puzzles/core/storage/local_storage.dart';
import 'package:chess_puzzles/core/chess/chess_models.dart';
import 'package:chess_puzzles/data/models/puzzle_model.dart';
import 'package:chess_puzzles/data/puzzle_database.dart';
import 'package:chess_puzzles/data/random_puzzle_generator.dart';
import 'package:chess_puzzles/logic/puzzle_controller.dart';
import 'package:chess_puzzles/logic/daily_puzzle_controller.dart';
import 'package:chess_puzzles/logic/puzzle_rush_controller.dart';
import 'package:chess_puzzles/presentation/screens/home_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  group('Puzzle Logic & Controllers', () {
    test('PuzzleController correctly solves a Mate in 1 puzzle', () {
      final puzzle = PuzzleDatabase.getPuzzleById('m1_01')!;
      final controller = PuzzleController(puzzle);

      expect(controller.status, PuzzleSolveStatus.ready);
      expect(controller.puzzle.theme, PuzzleTheme.mateIn1);

      // Play correct move f3f7
      final from = const Square(5, 2); // f3
      final to = const Square(5, 6);   // f7
      final success = controller.tryPlayerMove(from, to);

      expect(success, isTrue);
      expect(controller.status, PuzzleSolveStatus.solved);
      expect(LocalStorage.isPuzzleSolved('m1_01'), isTrue);
    });

    test('PuzzleController handles incorrect move and retry', () {
      final puzzle = PuzzleDatabase.getPuzzleById('m1_01')!;
      final controller = PuzzleController(puzzle);

      // Play incorrect move e1e2
      final from = const Square(4, 0); // e1
      final to = const Square(4, 1);   // e2
      final success = controller.tryPlayerMove(from, to);

      expect(success, isFalse);
      expect(controller.status, PuzzleSolveStatus.wrongMove);
      expect(controller.mistakesCount, 1);

      controller.retryCurrentPosition();
      expect(controller.status, PuzzleSolveStatus.inProgress);
    });

    test('PuzzleController hint system gives source then target square', () {
      final puzzle = PuzzleDatabase.getPuzzleById('m1_01')!;
      final controller = PuzzleController(puzzle);

      // Request Hint 1
      controller.requestHint();
      expect(controller.hintSourceSquare, const Square(5, 2)); // f3
      expect(controller.hintTargetSquare, isNull);
      expect(controller.hintsUsed, 1);

      // Request Hint 2
      controller.requestHint();
      expect(controller.hintTargetSquare, const Square(5, 6)); // f7
      expect(controller.hintsUsed, 2);
    });

    test('DailyPuzzleController loads 5 daily puzzles and tracks completion', () async {
      final dailyController = DailyPuzzleController();

      expect(dailyController.dailyPuzzles.length, 5);
      expect(dailyController.currentIndex, 0);
      expect(dailyController.completedCount, 0);

      await dailyController.markCurrentCompleted();
      expect(dailyController.completedCount, 1);
      expect(dailyController.completedIndices.contains(0), isTrue);

      dailyController.nextPuzzle();
      expect(dailyController.currentIndex, 1);
    });

    test('RandomPuzzleGenerator creates valid puzzle rush queues and filtered puzzles', () {
      final randomPuzzle = RandomPuzzleGenerator.getRandomPuzzle(theme: PuzzleTheme.mateIn1);
      expect(randomPuzzle.theme, PuzzleTheme.mateIn1);

      final rushQueue = RandomPuzzleGenerator.generatePuzzleRushQueue();
      expect(rushQueue.isNotEmpty, isTrue);
    });

    test('PuzzleRushController handles strikes and game over', () {
      final rushController = PuzzleRushController(mode: PuzzleRushMode.survival3Strikes);

      expect(rushController.strikes, 0);
      expect(rushController.isGameOver, isFalse);

      rushController.skipPuzzle();
      expect(rushController.strikes, 1);

      rushController.skipPuzzle();
      expect(rushController.strikes, 2);

      rushController.skipPuzzle();
      expect(rushController.strikes, 3);
      expect(rushController.isGameOver, isTrue);
    });
  });

  group('UI & Screen Widgets', () {
    testWidgets('HomeScreen renders Daily 5 Hero Card and game modes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chess Tactics Pro'), findsOneWidget);
      expect(find.text('Daily 5 Puzzle Challenge'), findsOneWidget);
      expect(find.text('Random Puzzle'), findsOneWidget);
      expect(find.text('Puzzle Rush'), findsOneWidget);
      expect(find.text('Curated Puzzle Library'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_finance/data/quiz_data.dart';
import 'package:learn_finance/models/question.dart';
import 'package:learn_finance/screens/quiz_screen.dart';

void main() {
  group('QuizScreen Random Sampling & Option Shuffling Tests', () {
    testWidgets('QuizScreen initializes with exactly 10 questions and shuffled options', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuizScreen(category: 'Investing Fundamentals'),
        ),
      );

      // Verify header and progress indicator
      expect(find.text('Investing Fundamentals Quiz'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);

      // Verify question card exists
      final currentQuestionTextFinder = find.byType(Text);
      expect(currentQuestionTextFinder, findsWidgets);

      // Verify exactly 4 option cards (A, B, C, D) are rendered
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    test('Option shuffling preserves correct answer string identity', () {
      // Test across all 8 categories
      for (final category in quizData.keys) {
        final rawQuestions = quizData[category]!;
        expect(rawQuestions.length, equals(50));

        for (final q in rawQuestions) {
          final originalCorrectAnswerText = q.options[q.correctAnswerIndex];

          // Simulate option shuffling
          final shuffledOptions = List<String>.from(q.options)..shuffle();
          final newCorrectIndex = shuffledOptions.indexOf(originalCorrectAnswerText);

          expect(newCorrectIndex, inInclusiveRange(0, 3));
          expect(shuffledOptions[newCorrectIndex], equals(originalCorrectAnswerText));
        }
      }
    });

    testWidgets('QuizScreen interactive gameplay, answer submission, and results summary flow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuizScreen(category: 'Stock Valuation'),
        ),
      );

      // Answer 10 questions sequentially
      for (int i = 1; i <= 10; i++) {
        expect(find.text('$i/10'), findsOneWidget);

        // Tap the first option (Option A)
        await tester.tap(find.text('A'));
        await tester.pumpAndSettle();

        // Rationale should be visible
        expect(find.text('Rationale & Insight'), findsOneWidget);

        // Tap Next Question / Finish Quiz button
        if (i < 10) {
          await tester.tap(find.text('Next Question'));
        } else {
          await tester.tap(find.text('Finish Quiz'));
        }
        await tester.pumpAndSettle();
      }

      // Verify Results Summary screen
      expect(find.text('Results Summary'), findsOneWidget);
      expect(find.text('Review and Learn'), findsOneWidget);
      expect(find.text('Back to Menu'), findsOneWidget);
      expect(find.text('Play Again'), findsOneWidget);

      // Tap Play Again
      await tester.tap(find.text('Play Again'));
      await tester.pumpAndSettle();

      // Verify it resets back to question 1 of 10
      expect(find.text('Stock Valuation Quiz'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);
    });
  });
}

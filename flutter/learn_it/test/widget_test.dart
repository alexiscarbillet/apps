import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_it/data/quiz_data.dart';
import 'package:learn_it/main.dart';
import 'package:learn_it/screens/quiz_screen.dart';

void main() {
  testWidgets('Landing screen loads categories smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuizApp());

    // Verify that our app header text is present.
    expect(find.text('LearnIt Quiz'), findsOneWidget);

    // Verify that some of the key categories are visible on the dashboard.
    expect(find.text('AWS'), findsOneWidget);
    expect(find.text('GCP'), findsOneWidget);
  });

  testWidgets('Quiz screen uses a 10-question quiz session', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: QuizScreen(category: 'AWS'),
      ),
    );

    expect(find.text('1/10'), findsOneWidget);
  });

  test('Each quiz category has at least 50 questions', () {
    for (final entry in quizData.entries) {
      expect(
        entry.value.length,
        greaterThanOrEqualTo(50),
        reason: '${entry.key} should have at least 50 questions',
      );
    }
  });
}

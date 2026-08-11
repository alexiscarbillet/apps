import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_it/data/decision_trees/decision_tree_data.dart';
import 'package:learn_it/data/quiz_data.dart';
import 'package:learn_it/main.dart';
import 'package:learn_it/screens/quiz_screen.dart';
import 'package:learn_it/screens/flashcard_screen.dart';
import 'package:learn_it/screens/cheatsheet_screen.dart';
import 'package:learn_it/screens/decision_tree_screen.dart';
import 'package:learn_it/screens/category_selection_screen.dart';
import 'package:learn_it/screens/landing_screen.dart';

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

  testWidgets('Azure home tile opens the Azure submenu', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Azure'),
      find.byType(CustomScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Azure'));
    await tester.pumpAndSettle();

    expect(find.text('Azure'), findsWidgets);
    expect(find.text('How do you want to learn?'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
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

  test('Decision trees use category-specific knowledge branches', () {
    final gcpStartNode = decisionTreeData['GCP']!.firstWhere((node) => node.id == 'start');
    expect(gcpStartNode.prompt.toLowerCase(), contains('product'));
    expect(
      gcpStartNode.branches.any((branch) => branch.label.toLowerCase().contains('product')),
      isTrue,
    );

    final electricityStartNode = decisionTreeData['Electricity']!.firstWhere((node) => node.id == 'start');
    expect(electricityStartNode.prompt.toLowerCase(), contains('circuit'));
    expect(
      electricityStartNode.branches.any((branch) => branch.label.toLowerCase().contains('circuit')),
      isTrue,
    );
  });

  testWidgets('Decision tree screen renders a tree view', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DecisionTreeScreen(
          category: 'GCP',
          gradient: [Colors.blue, Colors.teal],
        ),
      ),
    );

    expect(find.text('Tree view'), findsOneWidget);
    expect(find.text('Product and service basics'), findsOneWidget);
  });

  testWidgets('Flashcard screen displays mode selection options', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FlashcardScreen(
          category: 'AWS',
          gradient: [Colors.orange, Colors.red],
        ),
      ),
    );

    // Verify search deck/mode options are shown
    expect(find.text('Select Study Deck'), findsOneWidget);
    expect(find.text('Study Concepts'), findsOneWidget);
    expect(find.text('Study Quiz Questions'), findsOneWidget);
    expect(find.text('Mixed Mode'), findsOneWidget);
  });

  testWidgets('Cheatsheet screen search filters sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheatsheetScreen(
          category: 'AWS',
          gradient: [Colors.orange, Colors.red],
        ),
      ),
    );

    // Initial state: sections are shown.
    // e.g. EC2 section should be visible (appears in chips AND section cards).
    expect(find.text('EC2 & Compute Services'), findsAtLeastNWidgets(1));
    expect(find.text('S3 & Object Storage'), findsAtLeastNWidgets(1));

    // Enter search query
    await tester.enterText(find.byType(TextField), 'EC2');
    await tester.pump();

    // Verify that the filtered list contains EC2, but not S3.
    // Filter chips are hidden during search, so only section cards remain.
    expect(find.text('EC2 & Compute Services'), findsAtLeastNWidgets(1));
    expect(find.text('S3 & Object Storage'), findsNothing);
  });
}


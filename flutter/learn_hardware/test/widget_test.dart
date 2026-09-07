import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hardware/data/cheatsheet_data.dart';
import 'package:learn_hardware/data/decision_trees/decision_tree_data.dart';
import 'package:learn_hardware/data/quiz_data.dart';
import 'package:learn_hardware/main.dart';

void main() {
  const categories = [
    'Hardware Foundations',
    'CPU Architecture',
    'Memory Systems',
    'Storage & I/O',
    'Motherboards & Components',
    'Power & Thermals',
  ];

  testWidgets('landing screen shows the hardware learning tracks', (tester) async {
    await tester.pumpWidget(const QuizApp());
    expect(find.text('Learn Hardware'), findsOneWidget);
    expect(find.text('Hardware Foundations'), findsOneWidget);
  });

  test('every hardware track has all learning modes wired', () {
    expect(cheatsheetData.keys, containsAll(categories));
    expect(quizData.keys, containsAll(categories));
    expect(decisionTreeData.keys, containsAll(categories));

    for (final category in categories) {
      expect(cheatsheetData[category]!.sections, isNotEmpty);
      expect(quizData[category], hasLength(50));
      expect(decisionTreeData[category], isNotEmpty);
    }
  });

  testWidgets('hardware category opens its study menu', (tester) async {
    await tester.pumpWidget(const QuizApp());
    await tester.tap(find.text('CPU Architecture'));
    await tester.pumpAndSettle();

    expect(find.text('How do you want to learn?'), findsOneWidget);
    expect(find.text('Cheatsheet'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Decision Tree'),
      find.byType(Scrollable),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(find.text('Decision Tree'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_electricity/data/cheatsheet_data.dart';
import 'package:learn_electricity/data/decision_trees/decision_tree_data.dart';
import 'package:learn_electricity/data/quiz_data.dart';
import 'package:learn_electricity/main.dart';

void main() {
  const categories = [
    'Electrical Foundations',
    'Circuit Analysis',
    'AC/DC & Power',
    'Components & Semiconductors',
    'Wiring & Canadian Regulations',
    'Safety & Applications',
  ];

  testWidgets('electricity app shows its focused landing screen', (tester) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Learn Electricity'), findsOneWidget);
    expect(find.text('Electrical Foundations'), findsOneWidget);
  });

  test('every electricity category has 50 or more questions and study data', () {
    for (final category in categories) {
      expect(cheatsheetData[category]!.sections, isNotEmpty);
      expect(quizData[category]!.length, greaterThanOrEqualTo(50));
      expect(decisionTreeData[category], isNotEmpty);
    }
  });

  testWidgets('electricity category opens every study mode', (tester) async {
    await tester.pumpWidget(const QuizApp());
    await tester.tap(find.text('Electrical Foundations'));
    await tester.pumpAndSettle();

    expect(find.text('How do you want to learn?'), findsOneWidget);
    expect(find.text('Cheatsheet'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
  });
}

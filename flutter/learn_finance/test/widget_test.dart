import 'package:flutter_test/flutter_test.dart';
import 'package:learn_finance/main.dart';

void main() {
  testWidgets('LearnFinance app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LearnFinanceApp());
    expect(find.text('LearnFinance'), findsOneWidget);
    expect(find.text('Interactive Wealth Tools'), findsOneWidget);
  });
}

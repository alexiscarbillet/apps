import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chess_puzzles/core/storage/local_storage.dart';
import 'package:chess_puzzles/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();

    await tester.pumpWidget(const ChessPuzzlesApp());
    await tester.pumpAndSettle();

    expect(find.text('Chess Tactics Pro'), findsOneWidget);
  });
}

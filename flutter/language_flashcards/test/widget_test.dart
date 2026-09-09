import 'package:flutter_test/flutter_test.dart';

import 'package:language_flashcards/main.dart';

void main() {
  testWidgets('app loads the language flashcards screen', (tester) async {
    await tester.pumpWidget(const LanguageFlashcardsApp());

    expect(find.text('Language Flashcards'), findsOneWidget);
    expect(find.text('Choose a language'), findsOneWidget);
  });
}

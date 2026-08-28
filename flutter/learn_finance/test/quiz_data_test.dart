import 'package:flutter_test/flutter_test.dart';
import 'package:learn_finance/data/quiz_data.dart';

void main() {
  group('Quiz Data Validation Tests', () {
    test('Quiz data contains all 8 expected categories', () {
      expect(quizData.keys.length, equals(8));
      expect(quizData.containsKey('Investing Fundamentals'), isTrue);
      expect(quizData.containsKey('Stock Valuation'), isTrue);
      expect(quizData.containsKey('Portfolio Management'), isTrue);
      expect(quizData.containsKey('Macroeconomics'), isTrue);
      expect(quizData.containsKey('Personal Wealth'), isTrue);
      expect(quizData.containsKey('Options & Derivatives'), isTrue);
      expect(quizData.containsKey('Financial Coding'), isTrue);
      expect(quizData.containsKey('Risk Management'), isTrue);
    });

    test('Each category has exactly 50 questions and every question is valid', () {
      int totalQuestions = 0;

      quizData.forEach((category, questions) {
        expect(
          questions.length,
          equals(50),
          reason: 'Category "$category" should have exactly 50 questions',
        );

        totalQuestions += questions.length;

        for (int i = 0; i < questions.length; i++) {
          final q = questions[i];

          expect(
            q.questionText.trim().isNotEmpty,
            isTrue,
            reason: 'Question $i in $category has empty questionText',
          );

          expect(
            q.options.length,
            equals(4),
            reason: 'Question "$q.questionText" in $category must have exactly 4 options',
          );

          expect(
            q.correctAnswerIndex,
            inInclusiveRange(0, 3),
            reason: 'Question "$q.questionText" in $category has invalid correctAnswerIndex: ${q.correctAnswerIndex}',
          );

          expect(
            q.explanation.trim().isNotEmpty,
            isTrue,
            reason: 'Question "$q.questionText" in $category has empty explanation',
          );

          for (int optIdx = 0; optIdx < q.options.length; optIdx++) {
            expect(
              q.options[optIdx].trim().isNotEmpty,
              isTrue,
              reason: 'Option $optIdx in question "$q.questionText" in $category is empty',
            );
          }
        }
      });

      expect(totalQuestions, equals(400));
    });
  });
}

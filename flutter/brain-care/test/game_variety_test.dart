import 'package:flutter_test/flutter_test.dart';
import 'package:brain_care/logic/divergent_thinking_controller.dart';
import 'package:brain_care/logic/mental_rotation_controller.dart';
import 'package:brain_care/logic/story_studio_controller.dart';

void main() {
  test('Triad sessions use a larger bank without repeating a prompt', () {
    final controller = DivergentThinkingController();
    controller.startSession();

    expect(controller.totalTriads, greaterThanOrEqualTo(10));
    final seenPrompts = <String>{};
    while (controller.isPlaying) {
      final triad = controller.currentTriad;
      expect(
        seenPrompts.add('${triad.word1}|${triad.word2}|${triad.word3}'),
        isTrue,
      );
      controller.submitAnswer(triad.solution);
      controller.nextTriad();
    }

    expect(controller.score, controller.totalTriads);
    controller.dispose();
  });

  test('Mental rotation choices retain a correct answer after reshuffling', () {
    final controller = MentalRotationController();
    controller.startSession();

    final questionTitles = <String>{};
    while (controller.isPlaying) {
      final question = controller.currentQuestion;
      expect(questionTitles.add(question.title), isTrue);
      expect(
        question.correctIndex,
        inInclusiveRange(0, question.candidates.length - 1),
      );
      controller.selectCandidate(question.correctIndex);
      expect(controller.isCurrentAnswerCorrect, isTrue);
      controller.nextQuestion();
    }

    expect(controller.score, controller.totalQuestions);
    controller.dispose();
  });

  test('Story prompts do not repeat in consecutive sessions', () {
    final controller = StoryStudioController();
    controller.startStorySession();
    final firstPrompt = controller.currentPrompt;
    controller.finishSession();

    controller.startStorySession();
    expect(controller.currentPrompt, isNot(firstPrompt));
    controller.finishSession();
    controller.dispose();
  });
}

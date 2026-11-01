import 'package:flutter_test/flutter_test.dart';
import 'package:brain_care/logic/dual_n_back_controller.dart';
import 'package:brain_care/logic/divergent_thinking_controller.dart';
import 'package:brain_care/logic/mental_rotation_controller.dart';
import 'package:brain_care/logic/task_switching_controller.dart';
import 'package:brain_care/presentation/screens/exercises/cross_modal_screen.dart';
import 'package:brain_care/presentation/screens/exercises/motor_drawing_screen.dart';
import 'package:brain_care/presentation/widgets/mirror_drawing_canvas.dart';
import 'package:brain_care/logic/story_studio_controller.dart';

void main() {
  test('Triad sessions choose five prompts without repeating a prompt', () {
    final controller = DivergentThinkingController();
    controller.startSession();

    expect(controller.triadBankSize, greaterThanOrEqualTo(20));
    expect(controller.totalTriads, 5);
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

    expect(controller.questionBankSize, greaterThanOrEqualTo(20));
    expect(controller.totalQuestions, 5);
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

  test('Every exercise category has a 20-item bank and selects five', () {
    expect(CrossModalTaskBank.tasks.length, greaterThanOrEqualTo(20));
    expect(
      MentalRotationController.questionBank.length,
      greaterThanOrEqualTo(20),
    );
    expect(
      DivergentThinkingController.triadBank.length,
      greaterThanOrEqualTo(20),
    );
    expect(
      TaskSwitchingController.stimulusBank.length,
      greaterThanOrEqualTo(20),
    );
    expect(DualNBackController.stimulusBank.length, greaterThanOrEqualTo(20));
    expect(MotorDrawingChallengeBank.templates, hasLength(20));
    expect(MirrorDrawingCanvas.templateShapes, hasLength(20));

    final memory = DualNBackController();
    memory.startSession();
    expect(memory.totalTrials, 5);
    expect(memory.selectedStimuli, hasLength(5));
    expect(
      memory.selectedStimuli
          .map(
            (trial) =>
                '${trial.positionIndex}-${trial.letter}-${trial.colorName}',
          )
          .toSet(),
      hasLength(5),
    );
    memory.stop();
    memory.dispose();

    final switching = TaskSwitchingController();
    switching.startSession();
    expect(switching.maxRounds, 5);
    expect(switching.selectedStimuli, hasLength(5));
    expect(
      switching.selectedStimuli
          .map((card) => '${card.shape}-${card.colorName}-${card.count}')
          .toSet(),
      hasLength(5),
    );
    for (var round = 0; round < 5; round++) {
      switching.chooseBucket(0);
    }
    expect(switching.isFinished, isTrue);
    expect(switching.roundsPlayed, 5);
    switching.dispose();
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

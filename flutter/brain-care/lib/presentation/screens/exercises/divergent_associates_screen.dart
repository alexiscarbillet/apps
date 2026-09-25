import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../../logic/divergent_thinking_controller.dart';

class DivergentAssociatesScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const DivergentAssociatesScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<DivergentAssociatesScreen> createState() =>
      _DivergentAssociatesScreenState();
}

class _DivergentAssociatesScreenState extends State<DivergentAssociatesScreen> {
  late DivergentThinkingController _controller;
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = DivergentThinkingController();
    _controller.addListener(_onUpdate);
  }

  void _onUpdate() {
    setState(() {});
    if (_controller.isFinished) {
      _recordSession();
    }
  }

  void _recordSession() {
    final session = ExerciseSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: 'divergent_associates',
      exerciseTitle: 'Remote Triad Synthesis',
      domain: CognitiveDomainType.divergentThinking,
      timestamp: DateTime.now(),
      durationSeconds: 240,
      scorePercent: _controller.scorePercent,
      noveltyPointsGained: (_controller.scorePercent * 1.5).round(),
      metadata: {'score': _controller.score, 'total': _controller.totalTriads},
    );
    widget.brainCareController.recordCompletedSession(session);
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divergent Triad Associates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showScienceDialog(context),
            tooltip: 'Scientific Rationale',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: _controller.isPlaying
              ? _buildActiveTriad()
              : _controller.isFinished
                  ? _buildFinishedState()
                  : _buildIntroState(),
        ),
      ),
    );
  }

  Widget _buildIntroState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.neuralRose.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lightbulb_rounded,
                  size: 40, color: AppColors.neuralRose),
            ),
            const SizedBox(height: 20),
            Text(
              'Remote Triad & Divergent Links',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Find the single missing word or semantic anchor that forms a compound phrase or logical bridge with all 3 given terms.\n\nStimulates distant semantic networks in the Default Mode Network (DMN), moving away from linear math puzzles.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _controller.startSession(),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Lateral Challenge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neuralRose,
                minimumSize: const Size(220, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTriad() {
    final triad = _controller.currentTriad;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Triad ${_controller.currentIndex + 1} of ${_controller.totalTriads}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.neuralRose,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text('Score: ${_controller.score} / ${_controller.totalTriads}'),
            ],
          ),
          const SizedBox(height: 16),

          // 3 Words Cards
          Row(
            children: [
              _buildWordPill(triad.word1),
              const SizedBox(width: 8),
              _buildWordPill(triad.word2),
              const SizedBox(width: 8),
              _buildWordPill(triad.word3),
            ],
          ),
          const SizedBox(height: 24),

          // Input field
          if (_controller.isSolved == null) ...[
            TextField(
              controller: _textCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Enter connecting concept...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded,
                      color: AppColors.neuralRose),
                  onPressed: () {
                    _controller.submitAnswer(_textCtrl.text);
                    _textCtrl.clear();
                  },
                ),
              ),
              onSubmitted: (val) {
                _controller.submitAnswer(val);
                _textCtrl.clear();
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _controller.revealHint,
                  icon: const Icon(Icons.help_outline_rounded, size: 16),
                  label: const Text('Need a Hint?'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.electricCyan,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.submitAnswer(_textCtrl.text);
                    _textCtrl.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neuralRose,
                  ),
                  child: const Text('Verify'),
                ),
              ],
            ),
          ],

          if (_controller.showHint && _controller.isSolved == null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates_rounded,
                      size: 18, color: AppColors.amberGold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'HINT: ${triad.hint}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Feedback & Solution reveal
          if (_controller.isSolved != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _controller.isSolved == true
                    ? AppColors.emeraldSynapse.withValues(alpha: 0.15)
                    : AppColors.coralPulse.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _controller.isSolved == true
                      ? AppColors.emeraldSynapse
                      : AppColors.coralPulse,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _controller.isSolved == true
                            ? Icons.check_circle_rounded
                            : Icons.info_outline_rounded,
                        color: _controller.isSolved == true
                            ? AppColors.emeraldSynapse
                            : AppColors.coralPulse,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _controller.isSolved == true
                            ? 'Brilliant Association!'
                            : 'Target Anchor: "${triad.solution}"',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _controller.isSolved == true
                              ? AppColors.emeraldSynapse
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    triad.explanation,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.nextTriad(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neuralRose,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _controller.currentIndex + 1 < _controller.totalTriads
                    ? 'Next Triad'
                    : 'View Results',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWordPill(String word) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            word,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildFinishedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_rounded,
              size: 64, color: AppColors.neuralRose),
          const SizedBox(height: 16),
          Text(
            'Triad Workout Completed',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${_controller.scorePercent.toStringAsFixed(0)}% (${_controller.score}/${_controller.totalTriads})',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.neuralRose,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Dashboard'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _controller.startSession(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neuralRose),
                child: const Text('New Triad Set'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showScienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.biotech_rounded, color: AppColors.neuralRose),
            SizedBox(width: 8),
            Text('Remote Associates & Divergent Thinking'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Remote Associate Tests (Mednick) measure creative synthesis and the retrieval of non-obvious lexical connections.\n\nWhile routine sudoku and crossword puzzles activate well-worn verbal pathways, remote triads force the brain to search across broad semantic networks, strengthening synaptic branching.',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}

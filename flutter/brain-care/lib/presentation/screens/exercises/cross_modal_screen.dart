import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../widgets/waveform_visualizer.dart';

class CrossModalTask {
  final String title;
  final double frequencyHz;
  final Color primaryColor;
  final String sensoryPrompt;
  final List<String> candidateSensoryMappings;
  final int correctIndex;
  final String neuroExplanation;

  const CrossModalTask({
    required this.title,
    required this.frequencyHz,
    required this.primaryColor,
    required this.sensoryPrompt,
    required this.candidateSensoryMappings,
    required this.correctIndex,
    required this.neuroExplanation,
  });
}

class CrossModalScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const CrossModalScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<CrossModalScreen> createState() => _CrossModalScreenState();
}

class _CrossModalScreenState extends State<CrossModalScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isPlaying = false;
  bool _isFinished = false;
  int? _selectedAnswer;

  final List<CrossModalTask> _tasks = const [
    CrossModalTask(
      title: 'High-Frequency Shimmer & Tactile Binding',
      frequencyHz: 42.0,
      primaryColor: AppColors.electricCyan,
      sensoryPrompt:
          'Observe the high-velocity, rapid-oscillation cyan waveform above. Which tactile texture and acoustic timbre does this rhythm match?',
      candidateSensoryMappings: [
        'Crisp iced glass & ringing crystalline bell',
        'Warm heavy velvet & deep cello drone',
        'Coarse sandpaper & muted wooden thud',
        'Soft damp moss & distant waterfall',
      ],
      correctIndex: 0,
      neuroExplanation:
          'High gamma frequencies (>40Hz) naturally cross-map in the parietal cortex with sharp, bright acoustic transients and crystalline textures (Kiki/Bouba sensory sound-shape symbolism).',
    ),
    CrossModalTask(
      title: 'Low-Undulation Delta & Emotional Gravity',
      frequencyHz: 3.5,
      primaryColor: AppColors.vividViolet,
      sensoryPrompt:
          'Notice the deep, slow rolling violet swells. Which emotional-kinetic state does your auditory-visual cortex map to this wave?',
      candidateSensoryMappings: [
        'Urgent panic & frenetic sprint',
        'Deep oceanic calm & dreamlike hypnosis',
        'Sharp witty sarcasm & electric dance',
        'Crisp morning sunrise & bird song',
      ],
      correctIndex: 1,
      neuroExplanation:
          'Slow sinusoidal rhythms induce parasympathetic auditory entrainment and match deep emotional anchoring in the insular cortex.',
    ),
    CrossModalTask(
      title: 'Pulsing Amber Syncopation & Kinetic Spark',
      frequencyHz: 14.0,
      primaryColor: AppColors.amberGold,
      sensoryPrompt:
          'Observe the sharp rhythmic pulse of this amber waveform. Which natural phenomenon and temperature feeling does this stimulate?',
      candidateSensoryMappings: [
        'Freezing sub-zero blizzard',
        'Crackling hearth flame & warm sparks',
        'Stagnant swamp at midnight',
        'Smooth polished marble floor',
      ],
      correctIndex: 1,
      neuroExplanation:
          'Intermediate beta frequencies with sharp envelope attacks recruit motor prep areas (SMA) and evoke energetic thermal imagery.',
    ),
  ];

  void _start() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _isPlaying = true;
      _isFinished = false;
      _selectedAnswer = null;
    });
  }

  void _chooseOption(int index) {
    if (_selectedAnswer != null) return;
    setState(() {
      _selectedAnswer = index;
      if (index == _tasks[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_currentIndex + 1 < _tasks.length) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      setState(() {
        _isPlaying = false;
        _isFinished = true;
      });
      _record();
    }
  }

  void _record() {
    final pct = (_score / _tasks.length * 100);
    final session = ExerciseSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: 'cross_modal',
      exerciseTitle: 'Synesthesia Sensory Integration',
      domain: CognitiveDomainType.crossModal,
      timestamp: DateTime.now(),
      durationSeconds: 180,
      scorePercent: pct,
      noveltyPointsGained: (pct * 1.5).round(),
      metadata: {'score': _score, 'total': _tasks.length},
    );
    widget.brainCareController.recordCompletedSession(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synesthesia & Sensory Fusion'),
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
          child: _isPlaying
              ? _buildActiveScreen()
              : _isFinished
                  ? _buildFinishedScreen()
                  : _buildIntroScreen(),
        ),
      ),
    );
  }

  Widget _buildIntroScreen() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.electricCyan.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.graphic_eq_rounded,
                  size: 40, color: AppColors.electricCyan),
            ),
            const SizedBox(height: 20),
            Text(
              'Cross-Modal Sensory Binding',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Experience dynamic multi-frequency visual waveforms and synthesize them with tactile textures, emotional resonances, and acoustic timbres.\n\nForces inter-sensory binding in the superior temporal sulcus to combat sensory processing decline.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Sensory Synthesis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricCyan,
                foregroundColor: AppColors.background,
                minimumSize: const Size(220, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveScreen() {
    final current = _tasks[_currentIndex];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task ${_currentIndex + 1} of ${_tasks.length}',
                style: TextStyle(
                  color: current.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text('Score: $_score / ${_tasks.length}'),
            ],
          ),
          const SizedBox(height: 12),

          // Waveform Display Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                Text(
                  current.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: current.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                WaveformVisualizer(
                  frequencyHz: current.frequencyHz,
                  isPulsing: true,
                  primaryColor: current.primaryColor,
                  height: 110,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            current.sensoryPrompt,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 14),

          // Options
          ...List.generate(current.candidateSensoryMappings.length, (idx) {
            final option = current.candidateSensoryMappings[idx];
            final isChosen = _selectedAnswer == idx;
            final isAnswered = _selectedAnswer != null;
            final isCorrectOption = idx == current.correctIndex;

            Color borderColor = AppColors.borderSubtle;
            Color bg = AppColors.surface;

            if (isAnswered) {
              if (isCorrectOption) {
                borderColor = AppColors.emeraldSynapse;
                bg = AppColors.emeraldSynapse.withValues(alpha: 0.15);
              } else if (isChosen) {
                borderColor = AppColors.coralPulse;
                bg = AppColors.coralPulse.withValues(alpha: 0.15);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _chooseOption(idx),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + idx),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isAnswered && isCorrectOption
                                    ? AppColors.emeraldSynapse
                                    : AppColors.textPrimary,
                                fontWeight: isAnswered && isCorrectOption
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Neuro Explanation
          if (_selectedAnswer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.insights_rounded,
                      color: AppColors.electricCyan, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      current.neuroExplanation,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: current.primaryColor,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _currentIndex + 1 < _tasks.length ? 'Next Sensory Task' : 'Complete',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinishedScreen() {
    final pct = (_score / _tasks.length * 100);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_rounded,
              size: 64, color: AppColors.electricCyan),
          const SizedBox(height: 16),
          Text('Sensory Integration Complete',
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            'Score: ${pct.toStringAsFixed(0)}% ($_score/${_tasks.length})',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.electricCyan,
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
                onPressed: _start,
                child: const Text('Play Again'),
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
            Icon(Icons.biotech_rounded, color: AppColors.electricCyan),
            SizedBox(width: 8),
            Text('Cross-Modal & Synesthesia'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Cross-modal integration occurs in associative hubs (such as the Superior Temporal Sulcus and Angular Gyrus).\n\nStimulating synesthetic correspondences (sound to texture, visual rhythm to mood) prevents unimodal isolation and encourages broad axonal sprouting between sensory cortices.',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

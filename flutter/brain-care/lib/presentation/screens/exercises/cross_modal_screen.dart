import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../../logic/exercise_selection.dart';
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

class CrossModalTaskBank {
  static const List<CrossModalTask> tasks = [
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
    CrossModalTask(
      title: 'Steady Green Pulse & Gentle Momentum',
      frequencyHz: 8.0,
      primaryColor: AppColors.emeraldSynapse,
      sensoryPrompt:
          'Follow the even green pulse. Which scene best fits its measured pace and soft visual weight?',
      candidateSensoryMappings: [
        'A quiet forest path after a light rain',
        'A brass band rushing through a parade',
        'A bright flash followed by a sharp crack',
        'A crowded market at its busiest hour',
      ],
      correctIndex: 0,
      neuroExplanation:
          'A steady, moderate rhythm can suggest a calm and predictable scene; consider the waveform’s pace and color together.',
    ),
    CrossModalTask(
      title: 'Bright Violet Flutter & Airy Motion',
      frequencyHz: 28.0,
      primaryColor: AppColors.vividViolet,
      sensoryPrompt:
          'Notice the quick violet flutter. Which texture and movement feel closest to this light, lively pattern?',
      candidateSensoryMappings: [
        'A heavy wool blanket settling on a bed',
        'Leaves skittering in a brisk breeze',
        'Slow waves pressing against a stone pier',
        'A thick clay pot resting on a shelf',
      ],
      correctIndex: 1,
      neuroExplanation:
          'The rapid, light visual rhythm pairs naturally with a quick and airy movement rather than a heavy or slow one.',
    ),
    CrossModalTask(
      title: 'Slow Cyan Drift & Cool Stillness',
      frequencyHz: 5.0,
      primaryColor: AppColors.electricCyan,
      sensoryPrompt:
          'Watch the slow cyan drift. Which imagined texture best matches its cool, spacious quality?',
      candidateSensoryMappings: [
        'Hot coals snapping in a metal tray',
        'A smooth cool stone beneath clear water',
        'A rough brush scraping across dry wood',
        'A sharp citrus peel being twisted',
      ],
      correctIndex: 1,
      neuroExplanation:
          'A slow and spacious wave can be associated with a cool, smooth texture; use your own sensory impression as a guide.',
    ),
    CrossModalTask(
      title: 'Amber Spark & Warmth',
      frequencyHz: 31.0,
      primaryColor: AppColors.amberGold,
      sensoryPrompt:
          'Which imagined sound fits this bright, quick amber flicker?',
      candidateSensoryMappings: [
        'A soft whisper through thick curtains',
        'Tiny sparks snapping beside a fire',
        'A slow foghorn across a lake',
        'A pebble sinking into mud',
      ],
      correctIndex: 1,
      neuroExplanation:
          'The quick flicker pairs naturally with a brief, crisp sound.',
    ),
    CrossModalTask(
      title: 'Emerald Ripple & Soft Motion',
      frequencyHz: 9.0,
      primaryColor: AppColors.emeraldSynapse,
      sensoryPrompt:
          'Which surface would you imagine moving with this gentle green rhythm?',
      candidateSensoryMappings: [
        'A still pond with small ripples',
        'A metal sheet in a storm',
        'A racing engine on a track',
        'A dry branch snapping sharply',
      ],
      correctIndex: 0,
      neuroExplanation:
          'The gentle repeating rhythm evokes small, measured ripples.',
    ),
    CrossModalTask(
      title: 'Coral Beat & Soft Texture',
      frequencyHz: 12.0,
      primaryColor: AppColors.coralPulse,
      sensoryPrompt:
          'Which tactile impression best fits this measured coral beat?',
      candidateSensoryMappings: [
        'A smooth knitted scarf',
        'Jagged gravel underfoot',
        'A freezing metal railing',
        'A rough file across stone',
      ],
      correctIndex: 0,
      neuroExplanation:
          'The regular beat suggests a soft, even texture.',
    ),
    CrossModalTask(
      title: 'Cyan Flash & Crisp Sound',
      frequencyHz: 48.0,
      primaryColor: AppColors.electricCyan,
      sensoryPrompt:
          'Which sound best matches this rapid cyan shimmer?',
      candidateSensoryMappings: [
        'A crisp glass chime',
        'A low drum heard from far away',
        'A slow wooden creak',
        'A soft breeze through grass',
      ],
      correctIndex: 0,
      neuroExplanation:
          'A rapid shimmer is easy to associate with a bright, crisp chime.',
    ),
    CrossModalTask(
      title: 'Violet Current & Cool Depth',
      frequencyHz: 6.0,
      primaryColor: AppColors.vividViolet,
      sensoryPrompt:
          'Which imagined place matches this slow violet current?',
      candidateSensoryMappings: [
        'A crowded dance floor',
        'A cool, deep underwater cavern',
        'A sunlit field full of insects',
        'A sizzling pan on a stove',
      ],
      correctIndex: 1,
      neuroExplanation:
          'The slow movement suggests depth and stillness.',
    ),
    CrossModalTask(
      title: 'Golden Rhythm & Gentle Heat',
      frequencyHz: 18.0,
      primaryColor: AppColors.amberGold,
      sensoryPrompt:
          'Which scene fits this steady golden rhythm?',
      candidateSensoryMappings: [
        'A quiet candle warming a room',
        'A sudden hailstorm',
        'A cold wind across a bare ridge',
        'A sharp alarm in a station',
      ],
      correctIndex: 0,
      neuroExplanation:
          'A steady rhythm can suggest a gentle, sustained warmth.',
    ),
    CrossModalTask(
      title: 'Green Pulse & Rainfall',
      frequencyHz: 10.0,
      primaryColor: AppColors.emeraldSynapse,
      sensoryPrompt:
          'Which sound fits this soft, repeating green pulse?',
      candidateSensoryMappings: [
        'A waterfall crashing onto rocks',
        'Light rain tapping on leaves',
        'A trumpet fanfare',
        'A single door slamming',
      ],
      correctIndex: 1,
      neuroExplanation:
          'The regular, soft pulse suggests a gentle repeating sound.',
    ),
    CrossModalTask(
      title: 'Coral Wave & Citrus Brightness',
      frequencyHz: 24.0,
      primaryColor: AppColors.coralPulse,
      sensoryPrompt:
          'Which flavor and sensation fit this bright coral wave?',
      candidateSensoryMappings: [
        'Bitter dark cocoa and a heavy finish',
        'A tart orange with a lively sparkle',
        'Plain water and a cool stillness',
        'Smoky tea and a slow drift',
      ],
      correctIndex: 1,
      neuroExplanation:
          'The bright color and lively wave can suggest a tart, energetic flavor.',
    ),
    CrossModalTask(
      title: 'Deep Cyan Hum & Spacious Calm',
      frequencyHz: 2.5,
      primaryColor: AppColors.electricCyan,
      sensoryPrompt:
          'Which sound best matches this very slow cyan wave?',
      candidateSensoryMappings: [
        'A low, distant bell',
        'A rapid series of clicks',
        'A bright whistle',
        'A sharp hand clap',
      ],
      correctIndex: 0,
      neuroExplanation:
          'The very slow wave suggests a low, spacious sound.',
    ),
    CrossModalTask(
      title: 'Violet Hush & Softness',
      frequencyHz: 7.0,
      primaryColor: AppColors.vividViolet,
      sensoryPrompt:
          'Which texture fits this quiet, gently shifting violet pattern?',
      candidateSensoryMappings: [
        'Soft felt beneath your fingertips',
        'A sharp thorn',
        'A rough concrete wall',
        'Crackling dry leaves',
      ],
      correctIndex: 0,
      neuroExplanation:
          'A quiet, gently shifting pattern suggests a soft tactile impression.',
    ),
    CrossModalTask(
      title: 'Amber Crackle & Bright Heat',
      frequencyHz: 36.0,
      primaryColor: AppColors.amberGold,
      sensoryPrompt:
          'Which sound and temperature fit this lively amber pattern?',
      candidateSensoryMappings: [
        'A warm fire gently crackling',
        'A cold stream barely moving',
        'A silent snowy field',
        'A slow ship horn',
      ],
      correctIndex: 0,
      neuroExplanation:
          'The lively, bright pattern suggests warmth and small crackling sounds.',
    ),
    CrossModalTask(
      title: 'Emerald Flow & Cool Smoothness',
      frequencyHz: 11.0,
      primaryColor: AppColors.emeraldSynapse,
      sensoryPrompt:
          'Which surface fits this smooth, steady emerald flow?',
      candidateSensoryMappings: [
        'A rough brick wall',
        'A polished stone in a cool stream',
        'A dry, crumbling leaf',
        'A hot iron grate',
      ],
      correctIndex: 1,
      neuroExplanation:
          'The smooth movement suggests a cool, polished surface.',
    ),
    CrossModalTask(
      title: 'Coral Flutter & Breezy Motion',
      frequencyHz: 29.0,
      primaryColor: AppColors.coralPulse,
      sensoryPrompt:
          'Which scene best fits this quick, fluttering coral motion?',
      candidateSensoryMappings: [
        'A kite dancing in a gusty breeze',
        'A slow glacier moving downhill',
        'A heavy stone resting on sand',
        'A still room at midnight',
      ],
      correctIndex: 0,
      neuroExplanation:
          'The quick flutter suggests a light object moving in a breeze.',
    ),
    CrossModalTask(
      title: 'Cyan Rhythm & Open Air',
      frequencyHz: 21.0,
      primaryColor: AppColors.electricCyan,
      sensoryPrompt:
          'Which sensation best matches this clear, even cyan rhythm?',
      candidateSensoryMappings: [
        'A fresh breeze through an open window',
        'A dense fog pressing close',
        'A rough scrape on a hard surface',
        'A loud crash in a narrow room',
      ],
      correctIndex: 0,
      neuroExplanation:
          'The clear, even rhythm suggests a light and open sensation.',
    ),
  ];
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

  List<CrossModalTask> _sessionTasks = [];

  void _start() {
    final random = Random();
    _sessionTasks = selectFiveRandom(CrossModalTaskBank.tasks, random: random)
        .map((task) {
          final options = task.candidateSensoryMappings
              .asMap()
              .entries
              .toList()
            ..shuffle(random);
          return CrossModalTask(
            title: task.title,
            frequencyHz: task.frequencyHz,
            primaryColor: task.primaryColor,
            sensoryPrompt: task.sensoryPrompt,
            candidateSensoryMappings:
                options.map((option) => option.value).toList(),
            correctIndex: options
                .indexWhere((option) => option.key == task.correctIndex),
            neuroExplanation: task.neuroExplanation,
          );
        })
        .toList()
      ..shuffle(random);

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
      if (index == _sessionTasks[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_currentIndex + 1 < _sessionTasks.length) {
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
    final pct = (_score / _sessionTasks.length * 100);
    final session = ExerciseSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: 'cross_modal',
      exerciseTitle: 'Synesthesia Sensory Integration',
      domain: CognitiveDomainType.crossModal,
      timestamp: DateTime.now(),
      durationSeconds: 180,
      scorePercent: pct,
      noveltyPointsGained: (pct * 1.5).round(),
      metadata: {'score': _score, 'total': _sessionTasks.length},
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
    final current = _sessionTasks[_currentIndex];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task ${_currentIndex + 1} of ${_sessionTasks.length}',
                style: TextStyle(
                  color: current.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text('Score: $_score / ${_sessionTasks.length}'),
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
                _currentIndex + 1 < _sessionTasks.length
                    ? 'Next Sensory Task'
                    : 'Complete',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinishedScreen() {
    final pct = (_score / _sessionTasks.length * 100);
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
            'Score: ${pct.toStringAsFixed(0)}% ($_score/${_sessionTasks.length})',
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

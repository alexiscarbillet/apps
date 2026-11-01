import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../widgets/mirror_drawing_canvas.dart';
import '../../../logic/exercise_selection.dart';

class MotorDrawingChallengeBank {
  static const List<String> templates = MirrorDrawingCanvas.templateShapes;
}

class MotorDrawingScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const MotorDrawingScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<MotorDrawingScreen> createState() => _MotorDrawingScreenState();
}

class _MotorDrawingScreenState extends State<MotorDrawingScreen> {
  double _symmetryScore = 0;
  bool _isSaved = false;
  int _currentTemplateIndex = 0;
  late final List<String> _sessionTemplates;
  final List<double> _completedScores = [];

  @override
  void initState() {
    super.initState();
    _sessionTemplates = selectFiveRandom(MotorDrawingChallengeBank.templates);
  }

  void _recordSession() {
    if (_isSaved) return;
    setState(() {
      _isSaved = true;
    });
    final averageScore =
        _completedScores.reduce((total, score) => total + score) /
        _completedScores.length;

    final session = ExerciseSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: 'motor_drawing',
      exerciseTitle: 'Mirror Motor-Cortex Canvas',
      domain: CognitiveDomainType.motorPlasticity,
      timestamp: DateTime.now(),
      durationSeconds: 240,
      scorePercent: averageScore,
      noveltyPointsGained: (averageScore * 1.4).round(),
      metadata: {
        'symmetry_score': averageScore,
        'templates_completed': _completedScores.length,
      },
    );

    widget.brainCareController.recordCompletedSession(session);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Motor-cortex workout recorded to cognitive reserve!'),
        backgroundColor: AppColors.emeraldSynapse,
      ),
    );
  }

  void _advanceTemplate() {
    if (_symmetryScore <= 0 || _isSaved) return;
    _completedScores.add(_symmetryScore);
    if (_currentTemplateIndex == _sessionTemplates.length - 1) {
      _recordSession();
      return;
    }

    setState(() {
      _currentTemplateIndex++;
      _symmetryScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Non-Dominant Mirror Drawing'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pan_tool_alt_rounded,
                        color: AppColors.deepIndigo),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Pattern ${_currentTemplateIndex + 1} of ${_sessionTemplates.length}: ${_sessionTemplates[_currentTemplateIndex]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.vividViolet,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                            'Hold device & draw with NON-DOMINANT HAND',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.electricCyan,
                                  fontSize: 13,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Trace the ghost shape. Watch the mirrored neural feedback.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Interactive Drawing Canvas
              Expanded(
                child: MirrorDrawingCanvas(
                  key: ValueKey(_sessionTemplates[_currentTemplateIndex]),
                  templateShape: _sessionTemplates[_currentTemplateIndex],
                  onSymmetryScoreCalculated: (score) {
                    setState(() {
                      _symmetryScore = score;
                    });
                  },
                ),
              ),

              const SizedBox(height: 14),

              // Bottom Control Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_graph_rounded,
                              size: 18, color: AppColors.neuralRose),
                          const SizedBox(width: 8),
                          Text(
                            'Symmetry: ${_symmetryScore.toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _symmetryScore > 0 && !_isSaved
                        ? _advanceTemplate
                        : null,
                    icon: Icon(
                      _currentTemplateIndex == _sessionTemplates.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(
                      _isSaved
                          ? 'Saved!'
                          : _currentTemplateIndex == _sessionTemplates.length - 1
                          ? 'Complete Workout'
                          : 'Next Pattern',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepIndigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            Icon(Icons.biotech_rounded, color: AppColors.deepIndigo),
            SizedBox(width: 8),
            Text('Motor Cortex Neuroplasticity'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Using your non-dominant hand for precise motor tasks stimulates the contralateral motor strip (M1) and forces communication across the corpus callosum.\n\nThis cross-hemispheric demand sparks immediate synaptogenesis and breaks automated muscle memory habits.',
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

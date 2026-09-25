import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../../logic/mental_rotation_controller.dart';
import '../../widgets/isometric_voxel_painter.dart';

class MentalRotationScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const MentalRotationScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<MentalRotationScreen> createState() => _MentalRotationScreenState();
}

class _MentalRotationScreenState extends State<MentalRotationScreen> {
  late MentalRotationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MentalRotationController();
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
      exerciseId: 'mental_rotation',
      exerciseTitle: '3D Mental Rotation Matrix',
      domain: CognitiveDomainType.spatialManipulation,
      timestamp: DateTime.now(),
      durationSeconds: 240,
      scorePercent: _controller.scorePercent,
      noveltyPointsGained: (_controller.scorePercent * 1.5).round(),
      metadata: {'score': _controller.score, 'total': _controller.totalQuestions},
    );
    widget.brainCareController.recordCompletedSession(session);
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Mental Rotation'),
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
              ? _buildActivePuzzle()
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
                color: AppColors.vividViolet.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.view_in_ar_rounded,
                  size: 40, color: AppColors.vividViolet),
            ),
            const SizedBox(height: 20),
            Text(
              '3D Spatial Volumetric Rotation',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Mentally project the 3D polycube assembly in mental space. Examine 3 candidate views and identify which option is a true, genuine 3D rotation of the target object.\n\nProtects the parietal cortex and hippocampal grid cells from early Alzheimer\'s decline.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _controller.startSession(),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start 3D Rotation Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vividViolet,
                minimumSize: const Size(220, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePuzzle() {
    final q = _controller.currentQuestion;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress & Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Object ${_controller.currentIndex + 1} of ${_controller.totalQuestions}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.vividViolet,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Score: ${_controller.score}'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Primary Reference Target 3D Cube Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TARGET OBJECT (Reference View)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.electricCyan,
                          ),
                    ),
                    const Icon(Icons.rotate_90_degrees_ccw_rounded,
                        size: 16, color: AppColors.textMuted),
                  ],
                ),
                const SizedBox(height: 12),
                IsometricVoxelWidget(
                  voxels: q.originalShape,
                  size: 150,
                  primaryColor: AppColors.electricCyan,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Which candidate is a true 3D rotation?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),

          // Candidates Grid
          Row(
            children: List.generate(q.candidates.length, (index) {
              final isSelected = _controller.selectedAnswerIndex == index;
              final isAnswered = _controller.selectedAnswerIndex != null;
              final isThisCorrect = index == q.correctIndex;

              Color borderColor = AppColors.borderSubtle;
              Color bg = AppColors.surface;

              if (isAnswered) {
                if (isThisCorrect) {
                  borderColor = AppColors.emeraldSynapse;
                  bg = AppColors.emeraldSynapse.withValues(alpha: 0.1);
                } else if (isSelected) {
                  borderColor = AppColors.coralPulse;
                  bg = AppColors.coralPulse.withValues(alpha: 0.1);
                }
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => _controller.selectCandidate(index),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < q.candidates.length - 1 ? 8 : 0,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: (isSelected || (isAnswered && isThisCorrect)) ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Option ${String.fromCharCode(65 + index)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: (isAnswered && isThisCorrect)
                                ? AppColors.emeraldSynapse
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        IsometricVoxelWidget(
                          voxels: q.candidates[index],
                          size: 90,
                          primaryColor: (isAnswered && isThisCorrect)
                              ? AppColors.emeraldSynapse
                              : AppColors.vividViolet,
                          showGridFloor: false,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          // Feedback & Next Button
          if (_controller.selectedAnswerIndex != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _controller.isCurrentAnswerCorrect == true
                    ? AppColors.emeraldSynapse.withValues(alpha: 0.15)
                    : AppColors.coralPulse.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _controller.isCurrentAnswerCorrect == true
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
                        _controller.isCurrentAnswerCorrect == true
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: _controller.isCurrentAnswerCorrect == true
                            ? AppColors.emeraldSynapse
                            : AppColors.coralPulse,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _controller.isCurrentAnswerCorrect == true
                            ? 'Spatial Rotation Verified!'
                            : 'Chiral / Distractor Option Selected',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _controller.isCurrentAnswerCorrect == true
                              ? AppColors.emeraldSynapse
                              : AppColors.coralPulse,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q.rationale,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.nextQuestion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vividViolet,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _controller.currentIndex + 1 < _controller.totalQuestions
                    ? 'Next Spatial Shape'
                    : 'View Spatial Score',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinishedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium_rounded,
              size: 64, color: AppColors.amberGold),
          const SizedBox(height: 16),
          Text(
            '3D Rotation Evaluation Complete',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Accuracy: ${_controller.scorePercent.toStringAsFixed(0)}% (${_controller.score}/${_controller.totalQuestions})',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.vividViolet,
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
                    backgroundColor: AppColors.vividViolet),
                child: const Text('Try Again'),
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
            Icon(Icons.biotech_rounded, color: AppColors.vividViolet),
            SizedBox(width: 8),
            Text('3D Spatial Rotation'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Spatial navigation and mental rotation engage the right posterior parietal cortex, entorhinal cortex, and hippocampus.\n\nBecause the entorhinal cortex is the primary point of neurofibrillary tau accumulation in early Alzheimer\'s, volumetric 3D puzzles challenge grid cells and preserve cognitive reserve.',
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

import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../../logic/task_switching_controller.dart';

class TaskSwitchingScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const TaskSwitchingScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<TaskSwitchingScreen> createState() => _TaskSwitchingScreenState();
}

class _TaskSwitchingScreenState extends State<TaskSwitchingScreen> {
  late TaskSwitchingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TaskSwitchingController();
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
      exerciseId: 'task_switching',
      exerciseTitle: 'Executive Paradigm Switcher',
      domain: CognitiveDomainType.taskSwitching,
      timestamp: DateTime.now(),
      durationSeconds: 180,
      scorePercent: _controller.accuracyPercent,
      noveltyPointsGained: (_controller.accuracyPercent * 1.4).round(),
      metadata: {
        'accuracy': _controller.accuracyPercent,
        'latency_ms': _controller.averageLatencyMs,
      },
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
        title: const Text('Prefrontal Task Switching'),
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
              ? _buildActiveGame()
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
                color: AppColors.amberGold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shuffle_rounded,
                  size: 40, color: AppColors.amberGold),
            ),
            const SizedBox(height: 20),
            Text(
              'Dynamic Prefrontal Rule Shifter',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Sort the central card into one of 4 target bins.\n\nWARNING: The sorting rule will SHIFT unpredictably between COLOR, SHAPE, and PARITY (Odd/Even count).\n\nTrains the anterior cingulate cortex and prefrontal inhibition to prevent cognitive rigidity.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _controller.startSession(),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Switching Gym'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amberGold,
                foregroundColor: Colors.black,
                minimumSize: const Size(220, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGame() {
    final stimulus = _controller.currentStimulus;

    return Column(
      children: [
        // Rule Banner (Dynamic Shift Alert)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _getRuleColor(_controller.activeRule).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _getRuleColor(_controller.activeRule),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sync_problem_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                'CURRENT RULE: ${_getRuleTitle(_controller.activeRule)}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: 0.5,
                  color: _getRuleColor(_controller.activeRule),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Stats row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Round ${_controller.roundsPlayed + 1} / ${_controller.maxRounds}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Row(
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    size: 16, color: AppColors.amberGold),
                const SizedBox(width: 4),
                Text('Streak: ${_controller.streak}'),
              ],
            ),
          ],
        ),
        const Spacer(),

        // Central Stimulus Card
        if (stimulus != null)
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: stimulus.color.withValues(alpha: 0.25),
                  blurRadius: 20,
                )
              ],
            ),
            child: Center(
              child: _buildShapeElements(stimulus),
            ),
          ),
        const Spacer(),

        // 4 Target Buckets to tap
        Text(
          'Select Matching Target:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(_controller.targetBuckets.length, (idx) {
            final target = _controller.targetBuckets[idx];
            return Expanded(
              child: GestureDetector(
                onTap: () => _controller.chooseBucket(idx),
                child: Container(
                  margin: EdgeInsets.only(
                    right: idx < _controller.targetBuckets.length - 1 ? 8 : 0,
                  ),
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Center(
                    child: _buildShapeElements(target, scale: 0.65),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildShapeElements(TaskSwitchingCard card, {double scale = 1.0}) {
    IconData icon;
    switch (card.shape) {
      case 'Circle':
        icon = Icons.circle;
        break;
      case 'Square':
        icon = Icons.square_rounded;
        break;
      case 'Triangle':
        icon = Icons.change_history_rounded;
        break;
      case 'Star':
      default:
        icon = Icons.star_rounded;
        break;
    }

    return Wrap(
      spacing: 4 * scale,
      runSpacing: 4 * scale,
      alignment: WrapAlignment.center,
      children: List.generate(
        card.count,
        (_) => Icon(icon, color: card.color, size: 28 * scale),
      ),
    );
  }

  Color _getRuleColor(SortingRule rule) {
    switch (rule) {
      case SortingRule.color:
        return AppColors.electricCyan;
      case SortingRule.shape:
        return AppColors.vividViolet;
      case SortingRule.parity:
        return AppColors.amberGold;
    }
  }

  String _getRuleTitle(SortingRule rule) {
    switch (rule) {
      case SortingRule.color:
        return 'MATCH BY COLOR';
      case SortingRule.shape:
        return 'MATCH BY SHAPE';
      case SortingRule.parity:
        return 'MATCH BY COUNT PARITY (Odd/Even)';
    }
  }

  Widget _buildFinishedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.military_tech_rounded,
              size: 64, color: AppColors.amberGold),
          const SizedBox(height: 16),
          Text(
            'Executive Session Completed',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Accuracy: ${_controller.accuracyPercent.toStringAsFixed(0)}% (${_controller.score}/${_controller.maxRounds})',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.amberGold,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mean Reaction Latency: ${_controller.averageLatencyMs.toStringAsFixed(0)} ms',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
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
                  backgroundColor: AppColors.amberGold,
                  foregroundColor: Colors.black,
                ),
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
            Icon(Icons.biotech_rounded, color: AppColors.amberGold),
            SizedBox(width: 8),
            Text('Task Switching & Cognitive Flexibility'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Cognitive flexibility is the ability to disengage from an established behavioral rule and activate a competing cognitive schema.\n\nIn older adults, perseverative errors (sticking to the old rule) are early signs of prefrontal network weakening. Frequent paradigm shifting exercises build proactive cognitive control.',
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

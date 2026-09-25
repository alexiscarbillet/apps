import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../../logic/dual_n_back_controller.dart';

class DualNBackScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const DualNBackScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<DualNBackScreen> createState() => _DualNBackScreenState();
}

class _DualNBackScreenState extends State<DualNBackScreen> {
  late DualNBackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DualNBackController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    setState(() {});
    if (_controller.isFinished) {
      _recordSession();
    }
  }

  void _recordSession() {
    final session = ExerciseSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: 'dual_n_back',
      exerciseTitle: 'Dual ${_controller.nLevel}-Back Working Memory',
      domain: CognitiveDomainType.workingMemory,
      timestamp: DateTime.now(),
      durationSeconds: 180,
      scorePercent: _controller.accuracyScore,
      noveltyPointsGained: (_controller.accuracyScore * 1.5).round(),
      metadata: {'n_level': _controller.nLevel},
    );
    widget.brainCareController.recordCompletedSession(session);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dual N-Back Working Memory'),
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
            children: [
              // Top Stats Bar
              _buildTopBar(),
              const SizedBox(height: 16),

              // Main Interactive Grid
              Expanded(
                child: Center(
                  child: _controller.isPlaying
                      ? _buildActiveGrid()
                      : _controller.isFinished
                          ? _buildFinishedState()
                          : _buildIntroState(),
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              if (_controller.isPlaying) _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded,
                  color: AppColors.electricCyan, size: 20),
              const SizedBox(width: 8),
              Text(
                'N-Level: ${_controller.nLevel}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.electricCyan,
                    ),
              ),
            ],
          ),
          if (_controller.isPlaying)
            Text(
              'Trial ${_controller.currentTrialIndex + 1} / ${_controller.totalTrials}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            )
          else
            Row(
              children: [1, 2, 3].map((n) {
                final isSel = _controller.nLevel == n;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text('$n-Back'),
                    selected: isSel,
                    selectedColor: AppColors.electricCyan,
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.background : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) _controller.setNLevel(n);
                    },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildIntroState() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.emeraldSynapse.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sync_alt_rounded,
                size: 40, color: AppColors.emeraldSynapse),
          ),
          const SizedBox(height: 20),
          Text(
            'Dual ${_controller.nLevel}-Back Training',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Remember simultaneously where the square appears AND what letter is shown.\n\nTap "Position Match" if the position matches ${_controller.nLevel} steps ago.\nTap "Letter Match" if the letter matches ${_controller.nLevel} steps ago.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _controller.startSession(),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start Neuro Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricCyan,
              foregroundColor: AppColors.background,
              minimumSize: const Size(220, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveGrid() {
    final trial = _controller.currentTrial;

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final isActive = trial?.positionIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.electricCyan
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? AppColors.electricCyan
                      : AppColors.borderLight,
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.electricCyan.withValues(alpha: 0.5),
                          blurRadius: 16,
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: isActive
                    ? Text(
                        trial?.letter ?? '',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.background,
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFinishedState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.stars_rounded, size: 64, color: AppColors.amberGold),
        const SizedBox(height: 16),
        Text(
          'Workout Complete!',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Accuracy Score: ${_controller.accuracyScore}%',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.electricCyan,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          '+${(_controller.accuracyScore * 1.5).round()} Neuroplasticity Points Gained',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.emeraldSynapse,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Dashboard'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _controller.startSession(),
              child: const Text('Train Again'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        // Position Match Button
        Expanded(
          child: ElevatedButton(
            onPressed: _controller.claimPositionMatch,
            style: ElevatedButton.styleFrom(
              backgroundColor: _controller.userPositionMatchClaimed
                  ? AppColors.emeraldSynapse
                  : AppColors.surfaceElevated,
              foregroundColor: _controller.userPositionMatchClaimed
                  ? Colors.white
                  : AppColors.electricCyan,
              side: const BorderSide(color: AppColors.electricCyan, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_controller.userPositionMatchClaimed
                    ? Icons.check_circle_rounded
                    : Icons.grid_view_rounded),
                const SizedBox(width: 8),
                const Text('Position Match'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Letter Match Button
        Expanded(
          child: ElevatedButton(
            onPressed: _controller.claimAudioMatch,
            style: ElevatedButton.styleFrom(
              backgroundColor: _controller.userAudioMatchClaimed
                  ? AppColors.emeraldSynapse
                  : AppColors.surfaceElevated,
              foregroundColor: _controller.userAudioMatchClaimed
                  ? Colors.white
                  : AppColors.vividViolet,
              side: const BorderSide(color: AppColors.vividViolet, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_controller.userAudioMatchClaimed
                    ? Icons.check_circle_rounded
                    : Icons.text_fields_rounded),
                const SizedBox(width: 8),
                const Text('Letter Match'),
              ],
            ),
          ),
        ),
      ],
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
            Text('Dual N-Back Science'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Dual N-Back is one of the only cognitive paradigms scientifically demonstrated (Jaeggi et al., PNAS) to transfer to fluid intelligence (Gf) and working memory capacity.\n\nBy forcing simultaneous updating in two independent cortical streams (spatial grid + verbal phonological loop in the DLPFC), it expands your neural buffer against memory loss.',
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

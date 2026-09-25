import 'package:flutter/material.dart';
import '../../../core/constants/cognitive_domains.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exercise_session_model.dart';
import '../../../data/models/story_creation_model.dart';
import '../../../logic/brain_care_controller.dart';
import '../../../logic/story_studio_controller.dart';

class StoryStudioScreen extends StatefulWidget {
  final BrainCareController brainCareController;

  const StoryStudioScreen({
    super.key,
    required this.brainCareController,
  });

  @override
  State<StoryStudioScreen> createState() => _StoryStudioScreenState();
}

class _StoryStudioScreenState extends State<StoryStudioScreen> {
  late StoryStudioController _controller;
  final TextEditingController _draftCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = StoryStudioController();
    _controller.addListener(_onUpdate);
  }

  void _onUpdate() {
    setState(() {});
  }

  void _finishAndSave() {
    _controller.finishSession();
    final score = _controller.calculateCreativityScore();

    final story = StoryCreationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Constraint Story #${DateTime.now().minute}',
      content: _draftCtrl.text.trim().isEmpty
          ? 'No text recorded'
          : _draftCtrl.text.trim(),
      createdAt: DateTime.now(),
      activeConstraints: _controller.constraintsLog,
      injectedWords: _controller.injectedObjects,
      wordCount: _controller.wordCount,
      creativityScore: score,
    );

    widget.brainCareController.saveStoryEntry(story);

    final session = ExerciseSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: 'story_studio',
      exerciseTitle: 'Improvisational Constraint Story',
      domain: CognitiveDomainType.divergentThinking,
      timestamp: DateTime.now(),
      durationSeconds: 120,
      scorePercent: score,
      noveltyPointsGained: (score * 1.5).round(),
      metadata: {
        'words': _controller.wordCount,
        'injections': _controller.injectedObjects.length,
      },
    );

    widget.brainCareController.recordCompletedSession(session);
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    _draftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Improvisational Story Studio'),
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
          child: _controller.isActive
              ? _buildActiveStudio()
              : _controller.isFinished
                  ? _buildFinishedStudio()
                  : _buildIntroStudio(),
        ),
      ),
    );
  }

  Widget _buildIntroStudio() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.electricPurple.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_stories_rounded,
                  size: 40, color: AppColors.electricPurple),
            ),
            const SizedBox(height: 20),
            Text(
              'Dynamic Constraint Storytelling',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Compose a continuous creative story based on a randomized prompt.\n\nEvery 30 seconds, an unexpected object or dynamic rule will be injected mid-sentence (e.g. Lipogram: avoid "E", tone shifts).\n\nForces real-time generative plasticity and verbal agility.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                _draftCtrl.clear();
                _controller.startStorySession();
              },
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Start 2-Minute Story Studio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricPurple,
                minimumSize: const Size(220, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveStudio() {
    final mins = _controller.secondsRemaining ~/ 60;
    final secs = _controller.secondsRemaining % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Timer & Word Count Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 16, color: AppColors.electricCyan),
                  const SizedBox(width: 6),
                  Text(
                    '$mins:${secs.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.electricCyan,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Words: ${_controller.wordCount}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Live Dynamic Constraint Alert Box
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.electricPurple,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt_rounded,
                      size: 18, color: AppColors.amberGold),
                  const SizedBox(width: 6),
                  Text(
                    'ACTIVE DYNAMIC CONSTRAINT:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.amberGold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _controller.activeConstraint,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        if (_controller.injectedObjects.isNotEmpty) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _controller.injectedObjects.map((obj) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neuralRose.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.neuralRose.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'Injected: $obj',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.neuralRose),
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        const SizedBox(height: 12),

        // Prompt
        Text(
          'Prompt: "${_controller.currentPrompt}"',
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        // Story Editor
        Expanded(
          child: TextField(
            controller: _draftCtrl,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Type your unfolding narrative here...',
              alignLabelWithHint: true,
            ),
            onChanged: (text) {
              _controller.updateDraft(text);
            },
          ),
        ),
        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: _finishAndSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.electricPurple,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Finish & Score Narrative'),
        ),
      ],
    );
  }

  Widget _buildFinishedStudio() {
    final score = _controller.calculateCreativityScore();

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories_rounded,
                size: 64, color: AppColors.electricPurple),
            const SizedBox(height: 16),
            Text(
              'Improvisational Narrative Saved!',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Creativity Score: ${score.toStringAsFixed(0)} / 100',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.electricPurple,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Word Count: ${_controller.wordCount} words • ${_controller.injectedObjects.length} Injections Handled',
              style: Theme.of(context).textTheme.bodyMedium,
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
                  onPressed: () {
                    _draftCtrl.clear();
                    _controller.startStorySession();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricPurple),
                  child: const Text('New Story Prompt'),
                ),
              ],
            ),
          ],
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
            Icon(Icons.biotech_rounded, color: AppColors.electricPurple),
            SizedBox(width: 8),
            Text('Dynamic Constraint Narrative Science'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Improvisational storytelling with sudden constraint injections mimics high-level executive communication.\n\nIt activates both Broca\'s area (syntax), Wernicke\'s area (semantics), and prefrontal inhibitory gating to bypass habitual verbal templates and synthesize novel neural associations.',
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

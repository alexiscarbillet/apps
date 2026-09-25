import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/movement_timer_controller.dart';

class StretchGuideDialog extends StatefulWidget {
  final StretchRoutine routine;
  final VoidCallback onComplete;

  const StretchGuideDialog({
    super.key,
    required this.routine,
    required this.onComplete,
  });

  @override
  State<StretchGuideDialog> createState() => _StretchGuideDialogState();
}

class _StretchGuideDialogState extends State<StretchGuideDialog> {
  int _currentStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final routine = widget.routine;

    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(routine.icon, color: AppColors.primaryLight, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Target: ${routine.targetArea} • ${routine.durationText}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Benefit callout
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceDark),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFFFD166), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      routine.physiologicalBenefit,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Step Progress Indicator
            Text(
              'Step ${_currentStepIndex + 1} of ${routine.steps.length}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentStepIndex + 1) / routine.steps.length,
                minHeight: 6,
                backgroundColor: AppColors.surfaceDark,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
              ),
            ),
            const SizedBox(height: 14),

            // Current Step Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Text(
                routine.steps[_currentStepIndex],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStepIndex > 0)
                  TextButton(
                    onPressed: () {
                      setState(() => _currentStepIndex--);
                    },
                    child: const Text('Previous', style: TextStyle(color: AppColors.textSecondaryDark)),
                  )
                else
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss', style: TextStyle(color: AppColors.textSecondaryDark)),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentStepIndex < routine.steps.length - 1) {
                      setState(() => _currentStepIndex++);
                    } else {
                      widget.onComplete();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    _currentStepIndex < routine.steps.length - 1 ? 'Next Step' : 'Finish Break',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

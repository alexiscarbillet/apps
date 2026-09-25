import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/movement_timer_controller.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/stretch_guide_dialog.dart';

class MovementTimerScreen extends StatefulWidget {
  final MovementTimerController timerController;
  final HealthDashboardController healthController;

  const MovementTimerScreen({
    super.key,
    required this.timerController,
    required this.healthController,
  });

  @override
  State<MovementTimerScreen> createState() => _MovementTimerScreenState();
}

class _MovementTimerScreenState extends State<MovementTimerScreen> {
  void _openStretchGuide(StretchRoutine routine) {
    showDialog(
      context: context,
      builder: (ctx) => StretchGuideDialog(
        routine: routine,
        onComplete: () {
          widget.timerController.completeBreak(
            onCompleted: () => widget.healthController.incrementStandingBreaks(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tc = widget.timerController;

    return ListenableBuilder(
      listenable: tc,
      builder: (context, _) {
        final progress = tc.progressFraction;
        final isRunning = tc.isRunning;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Movement & Ergonomics',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Combat Sedentary Sitting & Spinal Compression',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline, color: Color(0xFFFF9500), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.healthController.todayLog.standingBreaks} Breaks Done',
                          style: const TextStyle(color: Color(0xFFFF9500), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 1. Sitting Timer Radial Dial
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isRunning
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                      width: 1.5,
                    ),
                    boxShadow: isRunning
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      // Circular Countdown
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 12,
                                strokeCap: StrokeCap.round,
                                backgroundColor: isDark
                                    ? AppColors.surfaceDark.withValues(alpha: 0.5)
                                    : AppColors.surfaceLight,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  tc.isBreakTime ? AppColors.error : AppColors.primaryLight,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tc.formattedTime,
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                Text(
                                  tc.isBreakTime
                                      ? 'TAKE 5-MIN BREAK!'
                                      : (isRunning ? 'FOCUSED SITTING' : 'TIMER PAUSED'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: tc.isBreakTime
                                        ? AppColors.error
                                        : (isRunning ? AppColors.primaryLight : AppColors.textSecondaryDark),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Interval Selector Chips
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [30, 45, 60].map((mins) {
                          final isSel = tc.intervalMinutes == mins;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text('$mins min'),
                              selected: isSel,
                              selectedColor: AppColors.primary,
                              onSelected: isRunning
                                  ? null
                                  : (_) => tc.setIntervalMinutes(mins),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Controls (Start / Pause / Reset / Guided Break)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => tc.resetTimer(),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Reset'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: isRunning ? () => tc.pauseTimer() : () => tc.startTimer(),
                            icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 22),
                            label: Text(isRunning ? 'Pause' : 'Start Timer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isRunning ? const Color(0xFFFF9500) : AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 2. Guided 5-Minute Break Routines
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guided 5-Minute Break Routines',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _openStretchGuide(tc.currentRoutine),
                    icon: const Icon(Icons.play_circle_outline, size: 16),
                    label: const Text('Start Now', style: TextStyle(color: AppColors.primaryLight)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ...MovementTimerController.routines.map((routine) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(routine.icon, color: AppColors.primaryLight, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'Target: ${routine.targetArea} • ${routine.durationText}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primaryLight),
                        onPressed: () => _openStretchGuide(routine),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

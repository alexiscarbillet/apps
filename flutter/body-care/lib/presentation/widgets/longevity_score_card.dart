import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LongevityScoreCard extends StatelessWidget {
  final double score;
  final int streakDays;
  final VoidCallback? onTap;

  const LongevityScoreCard({
    super.key,
    required this.score,
    required this.streakDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreInt = score.round();
    final isDark = theme.brightness == Brightness.dark;

    Color scoreColor;
    String scoreGrade;
    if (score >= 85) {
      scoreColor = AppColors.primaryLight;
      scoreGrade = 'Optimal Longevity';
    } else if (score >= 70) {
      scoreColor = AppColors.secondary;
      scoreGrade = 'Strong Prevention';
    } else if (score >= 50) {
      scoreColor = AppColors.warning;
      scoreGrade = 'Moderate Adherence';
    } else {
      scoreColor = AppColors.error;
      scoreGrade = 'Needs Attention';
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [Colors.white, const Color(0xFFF1F5F9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: scoreColor.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 18,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DAILY LONGEVITY INDEX',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            letterSpacing: 1.1,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scoreGrade,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Streak Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF9500).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFFFF9500),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streakDays Days',
                        style: const TextStyle(
                          color: Color(0xFFFF9500),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Radial Score Indicator
                SizedBox(
                  width: 84,
                  height: 84,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: score / 100.0,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.5)
                            : AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$scoreInt%',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: scoreColor,
                              ),
                            ),
                            Text(
                              'SCORE',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetricRow(
                        context,
                        label: 'Dietary Prevention',
                        fraction: score >= 70 ? 0.9 : 0.6,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      _buildMetricRow(
                        context,
                        label: 'UV & Skin Protection',
                        fraction: 1.0,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 8),
                      _buildMetricRow(
                        context,
                        label: 'Screening Compliance',
                        fraction: 0.85,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required String label,
    required double fraction,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            Text(
              '${(fraction * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 5,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

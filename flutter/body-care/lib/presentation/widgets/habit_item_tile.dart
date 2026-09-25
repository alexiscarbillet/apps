import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HabitItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String targetText;
  final int currentValue;
  final int targetValue;
  final IconData icon;
  final Color activeColor;
  final String rationale;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const HabitItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.targetText,
    required this.currentValue,
    required this.targetValue,
    required this.icon,
    required this.activeColor,
    required this.rationale,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGoalMet = currentValue >= targetValue;
    final progress = targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGoalMet
              ? activeColor.withValues(alpha: 0.5)
              : (isDark ? AppColors.surfaceDark.withValues(alpha: 0.5) : AppColors.surfaceLight),
          width: isGoalMet ? 1.5 : 1.0,
        ),
        boxShadow: isGoalMet
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: activeColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (isGoalMet)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: AppColors.success, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'GOAL MET',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar & Counter controls
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$currentValue / $targetText',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isGoalMet ? activeColor : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Decrement Button
              _buildCircleButton(
                icon: Icons.remove,
                onPressed: currentValue > 0 ? onDecrement : null,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              // Increment Button
              _buildCircleButton(
                icon: Icons.add,
                onPressed: onIncrement,
                isDark: isDark,
                isPrimary: true,
                activeColor: activeColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Preventative Rationale Tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    rationale,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDark,
    bool isPrimary = false,
    Color? activeColor,
  }) {
    return Material(
      color: isPrimary
          ? (activeColor ?? AppColors.primary)
          : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: isPrimary
                ? Colors.white
                : (onPressed == null
                    ? (isDark ? Colors.white24 : Colors.black26)
                    : (isDark ? Colors.white : Colors.black87)),
          ),
        ),
      ),
    );
  }
}

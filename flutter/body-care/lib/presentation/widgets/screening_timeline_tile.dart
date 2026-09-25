import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/screening_model.dart';

class ScreeningTimelineTile extends StatelessWidget {
  final MedicalScreening screening;
  final VoidCallback onMarkCompleted;
  final VoidCallback? onEdit;

  const ScreeningTimelineTile({
    super.key,
    required this.screening,
    required this.onMarkCompleted,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (screening.status == ScreeningStatus.completed) {
      statusColor = AppColors.success;
      statusLabel = 'Completed';
      statusIcon = Icons.check_circle_rounded;
    } else if (screening.isOverdue) {
      statusColor = AppColors.error;
      statusLabel = 'Overdue by ${-screening.daysUntilDue} days';
      statusIcon = Icons.error_rounded;
    } else if (screening.status == ScreeningStatus.scheduled) {
      statusColor = AppColors.secondary;
      statusLabel = 'Scheduled (in ${screening.daysUntilDue} days)';
      statusIcon = Icons.event_available_rounded;
    } else {
      statusColor = AppColors.warning;
      statusLabel = 'Due in ${screening.daysUntilDue} days';
      statusIcon = Icons.schedule_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: screening.isOverdue
              ? AppColors.error.withValues(alpha: 0.5)
              : (isDark ? AppColors.surfaceDark.withValues(alpha: 0.6) : AppColors.surfaceLight),
          width: screening.isOverdue ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  screening.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            screening.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15.5,
            ),
          ),
          const SizedBox(height: 4),
          // Provider & Facility
          if (screening.providerName.isNotEmpty || screening.facility.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${screening.providerName} • ${screening.facility}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          // Why Important
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_outlined, size: 13, color: AppColors.secondary),
                    const SizedBox(width: 5),
                    Text(
                      'Preventative Rationale',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  screening.whyImportant,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          // Prep checklist
          if (screening.prepChecklist.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Preparation Guidelines:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 4),
            ...screening.prepChecklist.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.primaryLight, fontSize: 12)),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Footer Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Due: ${screening.nextDueDate.year}-${screening.nextDueDate.month.toString().padLeft(2, '0')}-${screening.nextDueDate.day.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              if (screening.status != ScreeningStatus.completed)
                ElevatedButton.icon(
                  onPressed: onMarkCompleted,
                  icon: const Icon(Icons.check, size: 14),
                  label: const Text('Mark Done'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

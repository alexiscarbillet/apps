import 'package:flutter/material.dart';
import '../../core/constants/cognitive_domains.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/brain_care_controller.dart';

class DailyProtocolCard extends StatelessWidget {
  final DailyProtocolItem item;
  final bool isCompleted;
  final VoidCallback onTap;

  const DailyProtocolCard({
    super.key,
    required this.item,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final domainInfo = CognitiveDomains.getInfo(item.domain);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppColors.emeraldSynapse.withValues(alpha: 0.6)
                : AppColors.borderSubtle,
            width: isCompleted ? 1.5 : 1.0,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: AppColors.emeraldSynapse.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            // Domain Icon Badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.emeraldSynapse.withValues(alpha: 0.15)
                    : domainInfo.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle_rounded : item.icon,
                color: isCompleted
                    ? AppColors.emeraldSynapse
                    : domainInfo.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: domainInfo.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          domainInfo.title.split(' ')[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: domainInfo.primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Text(
                            '${item.targetMinutes} min',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textPrimary,
                        ),
                  ),
                  Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right_rounded,
              color: isCompleted
                  ? AppColors.emeraldSynapse
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

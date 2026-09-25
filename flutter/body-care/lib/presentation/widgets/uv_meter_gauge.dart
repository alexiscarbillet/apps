import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/uv_data_model.dart';

class UvMeterGauge extends StatelessWidget {
  final UvEnvironmentData uvData;
  final VoidCallback onLogSunscreen;
  final VoidCallback onRefresh;
  final Function(String location, double lat, double lon)? onChangeLocation;

  const UvMeterGauge({
    super.key,
    required this.uvData,
    required this.onLogSunscreen,
    required this.onRefresh,
    this.onChangeLocation,
  });

  Color _getUvColor(double uv) {
    if (uv < 3.0) return const Color(0xFF10B981); // Green
    if (uv < 6.0) return const Color(0xFFFBBF24); // Yellow/Amber
    if (uv < 8.0) return const Color(0xFFF97316); // Orange
    if (uv < 11.0) return const Color(0xFFEF4444); // Red
    return const Color(0xFF8B5CF6); // Violet Extreme
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final uvColor = _getUvColor(uvData.currentUv);

    final hasAppliedRecently = uvData.sunscreenAppliedAt != null &&
        DateTime.now().difference(uvData.sunscreenAppliedAt!).inHours < 2;

    int minutesRemaining = 0;
    if (hasAppliedRecently) {
      final elapsed = DateTime.now().difference(uvData.sunscreenAppliedAt!).inMinutes;
      minutesRemaining = (120 - elapsed).clamp(0, 120);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: uvData.currentUv >= 3.0
              ? uvColor.withValues(alpha: 0.4)
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: uvColor.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Location & Weather
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 16, color: uvColor),
                  const SizedBox(width: 4),
                  Text(
                    uvData.locationName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    onPressed: onRefresh,
                    tooltip: 'Refresh live UV data',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Main UV Index Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Gauge
              Container(
                width: 92,
                height: 92,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: uvColor.withValues(alpha: 0.12),
                  border: Border.all(color: uvColor, width: 2.5),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          uvData.currentUv.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: uvColor,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'UV INDEX',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: uvColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        uvData.riskLabel.toUpperCase(),
                        style: TextStyle(
                          color: uvColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Peak Today: UV ${uvData.maxTodayUv.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${uvData.temperatureCelsius.round()}°C • ${uvData.weatherDescription}',
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
          const SizedBox(height: 16),
          // Sunscreen application tracker / timer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasAppliedRecently
                    ? AppColors.success.withValues(alpha: 0.4)
                    : AppColors.warning.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasAppliedRecently ? Icons.verified_user_rounded : Icons.warning_amber_rounded,
                  color: hasAppliedRecently ? AppColors.success : AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasAppliedRecently
                            ? 'Protected (SPF Active)'
                            : 'Sunscreen Needed Outdoors',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: hasAppliedRecently ? AppColors.success : AppColors.warning,
                        ),
                      ),
                      Text(
                        hasAppliedRecently
                            ? 'Reapply in $minutesRemaining minutes'
                            : 'Apply SPF 50+ mineral protection',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onLogSunscreen,
                  icon: const Icon(Icons.touch_app, size: 14),
                  label: Text(hasAppliedRecently ? 'Reapply' : 'Apply Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasAppliedRecently ? AppColors.cardDark : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Actionable Recommendations
          ...uvData.actionableRecommendations.take(2).map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.secondary, fontSize: 14)),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

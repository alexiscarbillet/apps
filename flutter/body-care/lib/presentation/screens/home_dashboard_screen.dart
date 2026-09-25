import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/longevity_score_card.dart';
import '../widgets/why_tracker_banner.dart';
import '../widgets/habit_item_tile.dart';
import '../widgets/uv_meter_gauge.dart';

class HomeDashboardScreen extends StatelessWidget {
  final HealthDashboardController controller;
  final Function(int targetTab) onNavigateTab;

  const HomeDashboardScreen({
    super.key,
    required this.controller,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final today = controller.todayLog;
    final overdueScreenings = controller.screenings.where((s) => s.isOverdue).toList();

    return RefreshIndicator(
      onRefresh: () => controller.loadAllData(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Greeting & Quick Profile Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${controller.userProfile.fullName.split(' ').first}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Daily Preventative & Longevity Care',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    controller.isDarkTheme ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: AppColors.primaryLight,
                  ),
                  onPressed: () => controller.toggleTheme(),
                  tooltip: 'Toggle Theme',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 1. Longevity Score Card
            LongevityScoreCard(
              score: controller.longevityScore,
              streakDays: controller.currentStreakDays,
              onTap: () => onNavigateTab(1), // Go to Habits tab
            ),
            const SizedBox(height: 14),

            // 2. The "Why" Tracker Banner
            WhyTrackerBanner(
              profile: controller.userProfile,
              onEditWhy: (newWhy) => controller.updatePersonalWhy(newWhy),
            ),
            const SizedBox(height: 14),

            // Overdue screening alert if any
            if (overdueScreenings.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Action Needed: Overdue Screening',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            overdueScreenings.first.title,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(3), // Screenings Vault
                      child: const Text('View', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 3. Quick Habit Checkers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Preventative Priorities",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigateTab(1),
                  child: const Text('All Habits →', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Leafy greens
            HabitItemTile(
              title: 'Leafy Greens & Cruciferous Veggies',
              subtitle: 'Sulforaphane, Folate & Polyphenols',
              targetText: '3 servings',
              currentValue: today.leafyGreensServings,
              targetValue: 3,
              icon: Icons.eco_rounded,
              activeColor: AppColors.primary,
              rationale: 'Mitigates colorectal & cardiovascular inflammation pathways.',
              onIncrement: () => controller.incrementLeafyGreens(),
              onDecrement: () => controller.decrementLeafyGreens(),
            ),

            // UPF-Free Clean Nutrition
            HabitItemTile(
              title: 'Zero Ultra-Processed Meals (UPF-Free)',
              subtitle: 'Whole Foods, Fiber & Healthy Lipids',
              targetText: '3 meals',
              currentValue: today.noUpfMeals,
              targetValue: 3,
              icon: Icons.restaurant_rounded,
              activeColor: AppColors.secondary,
              rationale: 'Protects vascular endothelial function & insulin sensitivity.',
              onIncrement: () => controller.incrementNoUpfMeals(),
              onDecrement: () => controller.decrementNoUpfMeals(),
            ),

            // Hydration
            HabitItemTile(
              title: 'Mineralized Hydration',
              subtitle: 'Electrolytes & Pure Water',
              targetText: '8 glasses (2.0L)',
              currentValue: today.waterGlasses,
              targetValue: 8,
              icon: Icons.water_drop_rounded,
              activeColor: const Color(0xFF00B4D8),
              rationale: 'Maintains optimal blood viscosity & kidney filtration.',
              onIncrement: () => controller.incrementWater(),
              onDecrement: () => controller.decrementWater(),
            ),

            const SizedBox(height: 14),

            // 4. UV & Environment Snapshot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Live Environment & UV Protection",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigateTab(2),
                  child: const Text('Details →', style: TextStyle(color: AppColors.secondary, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            UvMeterGauge(
              uvData: controller.uvData,
              onLogSunscreen: () => controller.logSunscreenApplication(),
              onRefresh: () => controller.refreshUvData(),
            ),

            const SizedBox(height: 20),

            // Quick Hub Navigation Cards
            Row(
              children: [
                Expanded(
                  child: _buildQuickCard(
                    context,
                    title: 'Movement Timer',
                    subtitle: '${today.standingBreaks}/6 breaks today',
                    icon: Icons.timer_outlined,
                    color: const Color(0xFFFF9500),
                    onTap: () => onNavigateTab(4), // Movement timer
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickCard(
                    context,
                    title: 'Mole & Skin Map',
                    subtitle: '${controller.moleRecords.length} moles tracked',
                    icon: Icons.accessibility_new_rounded,
                    color: const Color(0xFF8B5CF6),
                    onTap: () => onNavigateTab(5), // Skin map
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

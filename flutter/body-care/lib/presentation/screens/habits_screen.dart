import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/habit_item_tile.dart';

class HabitsScreen extends StatelessWidget {
  final HealthDashboardController controller;

  const HabitsScreen({super.key, required this.controller});

  void _showAlcoholDialog(BuildContext context) {
    final current = controller.todayLog.alcoholUnits;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.no_drinks_rounded, color: Color(0xFFFF9500)),
            SizedBox(width: 8),
            Text('Alcohol Intake Tracker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target for longevity: 0 standard drinks. Track units consumed today (1 unit = 10g ethanol / small beer / glass of wine):',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [0.0, 0.5, 1.0, 2.0, 3.0].map((val) {
                final isSel = current == val;
                return ChoiceChip(
                  label: Text(val == 0.0 ? '0 (Alcohol-Free)' : '$val units'),
                  selected: isSel,
                  selectedColor: AppColors.primary,
                  onSelected: (_) {
                    controller.setAlcoholUnits(val);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotesDialog(BuildContext context) {
    final ctrl = TextEditingController(text: controller.todayLog.notes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Today\'s Preventative Notes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Record dietary highlights, fasting window, energy levels...',
            hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
            filled: true,
            fillColor: AppColors.surfaceDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateNotes(ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save Notes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final today = controller.todayLog;
    final history = controller.last7DaysLogs;

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
                    'Preventative Habit Tracker',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quality & Cellular Longevity Focus',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.note_alt_outlined, color: AppColors.primaryLight),
                onPressed: () => _showNotesDialog(context),
                tooltip: 'Daily Notes',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. 7-Day Adherence Visual Trend
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '7-Day Adherence Trend',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                    Text(
                      'Streak: ${controller.currentStreakDays} Days 🔥',
                      style: const TextStyle(
                        color: Color(0xFFFF9500),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: history.map((log) {
                    final score = log.adherenceScore;
                    final isToday = log.dateKey == today.dateKey;
                    Color barColor = AppColors.primary;
                    if (score < 50) barColor = AppColors.warning;
                    if (score >= 80) barColor = AppColors.primaryLight;

                    final dateParts = log.dateKey.split('-');
                    final dayNum = dateParts.length > 2 ? dateParts[2] : '';

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${score.round()}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? AppColors.primaryLight : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 28,
                          height: (score * 0.7).clamp(8.0, 70.0),
                          decoration: BoxDecoration(
                            color: barColor.withValues(alpha: isToday ? 1.0 : 0.6),
                            borderRadius: BorderRadius.circular(6),
                            border: isToday ? Border.all(color: Colors.white, width: 1.5) : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isToday ? 'Today' : 'D$dayNum',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? AppColors.primaryLight : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Preventative Nutrition Habit Items
          Text(
            'Daily Quality Targets (Non-Caloric)',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Leafy Greens & Cruciferous
          HabitItemTile(
            title: 'Leafy Greens & Cruciferous Veggies',
            subtitle: 'Sulforaphane, Folate, Chlorophyll & Fiber',
            targetText: '3 servings (1 cup raw / ½ cup cooked)',
            currentValue: today.leafyGreensServings,
            targetValue: 3,
            icon: Icons.eco_rounded,
            activeColor: AppColors.primary,
            rationale: 'Upregulates Nrf2 phase II detoxification enzymes and feeds microbiome butyrate producers.',
            onIncrement: () => controller.incrementLeafyGreens(),
            onDecrement: () => controller.decrementLeafyGreens(),
          ),

          // UPF-Free Clean Nutrition
          HabitItemTile(
            title: 'Ultra-Processed Food Elimination',
            subtitle: 'Zero emulsifiers, artificial sweeteners & seed oils',
            targetText: '3 clean whole-food meals',
            currentValue: today.noUpfMeals,
            targetValue: 3,
            icon: Icons.restaurant_menu_rounded,
            activeColor: AppColors.secondary,
            rationale: 'Protects gut mucosal barrier integrity and prevents chronic low-grade endotoxemia.',
            onIncrement: () => controller.incrementNoUpfMeals(),
            onDecrement: () => controller.decrementNoUpfMeals(),
          ),

          // Alcohol Minimization Card
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: today.alcoholUnits == 0
                    ? AppColors.success.withValues(alpha: 0.5)
                    : AppColors.warning.withValues(alpha: 0.5),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (today.alcoholUnits == 0 ? AppColors.success : AppColors.warning).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.no_drinks_rounded,
                    color: today.alcoholUnits == 0 ? AppColors.success : AppColors.warning,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Alcohol Moderation',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (today.alcoholUnits == 0 ? AppColors.success : AppColors.warning).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              today.alcoholUnits == 0 ? 'ALCOHOL-FREE (100%)' : '${today.alcoholUnits} UNITS',
                              style: TextStyle(
                                color: today.alcoholUnits == 0 ? AppColors.success : AppColors.warning,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Target: 0 units • Protects sleep architecture & liver DNA',
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showAlcoholDialog(context),
                  child: const Text('Log'),
                ),
              ],
            ),
          ),

          // Hydration Tracker
          HabitItemTile(
            title: 'Optimal Cellular Hydration',
            subtitle: 'Electrolyte-balanced mineral water',
            targetText: '8 glasses (2.0L)',
            currentValue: today.waterGlasses,
            targetValue: 8,
            icon: Icons.water_drop_rounded,
            activeColor: const Color(0xFF0EA5E9),
            rationale: 'Maintains optimal blood plasma volume, renal clearance, and synovial joint lubrication.',
            onIncrement: () => controller.incrementWater(),
            onDecrement: () => controller.decrementWater(),
          ),

          // Resistance & Muscle Longevity
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: today.resistanceTrained ? AppColors.primary.withValues(alpha: 0.5) : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                width: today.resistanceTrained ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF8B5CF6), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resistance / Zone 2 Training',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Muscle mass is the primary metabolic organ of longevity',
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: today.resistanceTrained,
                  activeTrackColor: AppColors.primary,
                  activeThumbColor: AppColors.primaryLight,
                  onChanged: (_) => controller.toggleResistanceTrained(),
                ),
              ],
            ),
          ),

          // Daily notes if present
          if (today.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded, color: AppColors.primaryLight, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      today.notes,
                      style: const TextStyle(fontSize: 13, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

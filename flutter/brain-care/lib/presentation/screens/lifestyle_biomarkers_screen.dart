import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/lifestyle_biomarker_model.dart';
import '../../logic/brain_care_controller.dart';

class LifestyleBiomarkersScreen extends StatefulWidget {
  final BrainCareController controller;

  const LifestyleBiomarkersScreen({
    super.key,
    required this.controller,
  });

  @override
  State<LifestyleBiomarkersScreen> createState() =>
      _LifestyleBiomarkersScreenState();
}

class _LifestyleBiomarkersScreenState
    extends State<LifestyleBiomarkersScreen> {
  late double _sleepHours;
  late int _deepSleep;
  late int _mindDiet;
  late int _aerobic;
  late int _resistance;
  late int _novelSkill;
  late int _social;
  late int _stress;

  @override
  void initState() {
    super.initState();
    final today = widget.controller.todayBiomarkers;
    _sleepHours = today.sleepHours;
    _deepSleep = today.deepSleepPercentage;
    _mindDiet = today.mindDietScore;
    _aerobic = today.aerobicBdnfMinutes;
    _resistance = today.resistanceTrainingMinutes;
    _novelSkill = today.novelSkillMinutes;
    _social = today.socialConnectionRating;
    _stress = today.stressManagementRating;
  }

  void _save() {
    final entry = LifestyleBiomarkerModel(
      date: DateTime.now(),
      sleepHours: _sleepHours,
      deepSleepPercentage: _deepSleep,
      mindDietScore: _mindDiet,
      aerobicBdnfMinutes: _aerobic,
      resistanceTrainingMinutes: _resistance,
      novelSkillMinutes: _novelSkill,
      socialConnectionRating: _social,
      stressManagementRating: _stress,
    );
    widget.controller.saveBiomarkerEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lifestyle biomarkers saved!'),
        backgroundColor: AppColors.emeraldSynapse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = LifestyleBiomarkerModel(
      date: DateTime.now(),
      sleepHours: _sleepHours,
      deepSleepPercentage: _deepSleep,
      mindDietScore: _mindDiet,
      aerobicBdnfMinutes: _aerobic,
      resistanceTrainingMinutes: _resistance,
      novelSkillMinutes: _novelSkill,
      socialConnectionRating: _social,
      stressManagementRating: _stress,
    );
    final score = entry.lifestyleLongevityScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifestyle Biomarkers'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.emeraldSynapse,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.emeraldSynapse.withValues(alpha: 0.2),
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: AppColors.emeraldSynapse.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.emeraldSynapse.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          score.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.emeraldSynapse,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lifestyle Longevity Score',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEEE, MMMM d').format(DateTime.now()),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sleep Section
              _buildSectionHeader('Sleep & Glymphatic Recovery',
                  Icons.bedtime_rounded, AppColors.vividViolet),
              const SizedBox(height: 10),
              _buildSliderCard(
                label: 'Total Sleep',
                value: _sleepHours,
                min: 4,
                max: 12,
                suffix: ' hrs',
                target: '7–9 hrs',
                color: AppColors.vividViolet,
                onChanged: (v) => setState(() => _sleepHours = v),
              ),
              _buildSliderCard(
                label: 'Deep Sleep Ratio',
                value: _deepSleep.toDouble(),
                min: 0,
                max: 40,
                suffix: '%',
                target: '≥ 18%',
                color: AppColors.vividViolet,
                onChanged: (v) =>
                    setState(() => _deepSleep = v.round()),
              ),

              const SizedBox(height: 16),

              // MIND Diet Section
              _buildSectionHeader('MIND Diet Adherence',
                  Icons.restaurant_rounded, AppColors.emeraldSynapse),
              const SizedBox(height: 10),
              _buildSliderCard(
                label: 'MIND Diet Score',
                value: _mindDiet.toDouble(),
                min: 0,
                max: 15,
                suffix: '/15',
                target: '≥ 10/15',
                color: AppColors.emeraldSynapse,
                onChanged: (v) =>
                    setState(() => _mindDiet = v.round()),
              ),

              const SizedBox(height: 16),

              // Exercise & BDNF Section
              _buildSectionHeader('Exercise & BDNF Stimulation',
                  Icons.fitness_center_rounded, AppColors.electricCyan),
              const SizedBox(height: 10),
              _buildSliderCard(
                label: 'Zone 2 / Brisk Aerobic',
                value: _aerobic.toDouble(),
                min: 0,
                max: 120,
                suffix: ' min',
                target: '≥ 30 min',
                color: AppColors.electricCyan,
                onChanged: (v) =>
                    setState(() => _aerobic = v.round()),
              ),
              _buildSliderCard(
                label: 'Resistance Training',
                value: _resistance.toDouble(),
                min: 0,
                max: 90,
                suffix: ' min',
                target: '≥ 20 min',
                color: AppColors.electricCyan,
                onChanged: (v) =>
                    setState(() => _resistance = v.round()),
              ),

              const SizedBox(height: 16),

              // Novel Skill Section
              _buildSectionHeader('Novel Skill & Novelty Seeking',
                  Icons.psychology_alt_rounded, AppColors.amberGold),
              const SizedBox(height: 10),
              _buildSliderCard(
                label: 'Novel Skill Learning',
                value: _novelSkill.toDouble(),
                min: 0,
                max: 120,
                suffix: ' min',
                target: '≥ 15 min',
                color: AppColors.amberGold,
                onChanged: (v) =>
                    setState(() => _novelSkill = v.round()),
              ),

              const SizedBox(height: 16),

              // Social & Stress Section
              _buildSectionHeader('Social Connection & Stress Management',
                  Icons.people_rounded, AppColors.neuralRose),
              const SizedBox(height: 10),
              _buildRatingRow(
                label: 'Social Connection Quality',
                value: _social,
                color: AppColors.neuralRose,
                onChanged: (v) => setState(() => _social = v),
              ),
              const SizedBox(height: 8),
              _buildRatingRow(
                label: 'Stress Management / Mindfulness',
                value: _stress,
                color: AppColors.neuralRose,
                onChanged: (v) => setState(() => _stress = v),
              ),

              const SizedBox(height: 24),

              // Weekly Log Summary
              _buildWeeklyMiniChart(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard({
    required String label,
    required double value,
    required double min,
    required double max,
    required String suffix,
    required String target,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Row(
                children: [
                  Text(
                    suffix.contains('/')
                        ? '${value.round()}$suffix'
                        : '${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1)}$suffix',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Target: $target',
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: color,
            inactiveColor: color.withValues(alpha: 0.15),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow({
    required String label,
    required int value,
    required Color color,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              return GestureDetector(
                onTap: () => onChanged(starIndex),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    starIndex <= value
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: starIndex <= value ? color : AppColors.textMuted,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMiniChart() {
    final logs = widget.controller.lifestyleLogs;
    final recent = logs.take(7).toList().reversed.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7-DAY LIFESTYLE LONGEVITY TREND',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                recent.length.clamp(0, 7),
                (i) {
                  final log = recent[i];
                  final score = log.lifestyleLongevityScore;
                  final height = (score / 100.0) * 60;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            score.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.emeraldSynapse,
                                  AppColors.electricCyan,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEE').format(log.date),
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

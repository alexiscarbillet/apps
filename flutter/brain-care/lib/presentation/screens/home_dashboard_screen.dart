import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/cognitive_domains.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/brain_care_controller.dart';
import '../widgets/cognitive_radar_chart.dart';
import '../widgets/cri_score_gauge.dart';
import '../widgets/daily_protocol_card.dart';
import 'exercises/cross_modal_screen.dart';
import 'exercises/divergent_associates_screen.dart';
import 'exercises/dual_n_back_screen.dart';
import 'exercises/mental_rotation_screen.dart';
import 'exercises/motor_drawing_screen.dart';
import 'exercises/story_studio_screen.dart';
import 'exercises/task_switching_screen.dart';
import 'lifestyle_biomarkers_screen.dart';
import 'neuromodulation_lounge_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  final BrainCareController controller;

  const HomeDashboardScreen({
    super.key,
    required this.controller,
  });

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUpdate);
  }

  void _onUpdate() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onUpdate);
    super.dispose();
  }

  void _navigateToExercise(String exerciseId) {
    Widget screen;
    switch (exerciseId) {
      case 'dual_n_back':
        screen = DualNBackScreen(brainCareController: widget.controller);
        break;
      case 'mental_rotation':
        screen =
            MentalRotationScreen(brainCareController: widget.controller);
        break;
      case 'task_switching':
        screen =
            TaskSwitchingScreen(brainCareController: widget.controller);
        break;
      case 'divergent_associates':
        screen = DivergentAssociatesScreen(
            brainCareController: widget.controller);
        break;
      case 'motor_drawing':
        screen =
            MotorDrawingScreen(brainCareController: widget.controller);
        break;
      case 'cross_modal':
        screen =
            CrossModalScreen(brainCareController: widget.controller);
        break;
      default:
        screen = DualNBackScreen(brainCareController: widget.controller);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.controller.profile;
    final todayBiomarker = widget.controller.todayBiomarkers;
    final lifestyleScore = todayBiomarker.lifestyleLongevityScore;

    return Scaffold(
      body: SafeArea(
        child: widget.controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    color: AppColors.electricCyan))
            : CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: AppColors.background,
                    toolbarHeight: 66,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good ${_getGreetingTime()}, ${profile.userName}',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('EEEE, MMMM d')
                              .format(DateTime.now()),
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    actions: [
                      // Streak Badge
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amberGold
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.amberGold
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                                Icons.local_fire_department_rounded,
                                size: 16,
                                color: AppColors.amberGold),
                            const SizedBox(width: 4),
                            Text(
                              '${profile.streakDays}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.amberGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 8),

                        // "Why" Motivation Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.vividViolet
                                    .withValues(alpha: 0.2),
                                AppColors.surface,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.vividViolet
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.vividViolet
                                      .withValues(alpha: 0.2),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.shield_rounded,
                                    size: 18,
                                    color: AppColors.vividViolet),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'YOUR "WHY"',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.vividViolet,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      profile.personalWhyMotivation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors
                                                .textSecondary,
                                            fontStyle:
                                                FontStyle.italic,
                                          ),
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // CRI Gauge + Radar Row
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.borderSubtle),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                      Icons.psychology_rounded,
                                      size: 18,
                                      color:
                                          AppColors.electricCyan),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'COGNITIVE RESERVE INDEX',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          AppColors.electricCyan,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .surfaceElevated,
                                      borderRadius:
                                          BorderRadius.circular(
                                              6),
                                    ),
                                    child: Text(
                                      '${profile.totalTrainingMinutes} min total',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color:
                                            AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CriScoreGauge(
                                score:
                                    profile.cognitiveReserveIndex,
                                size: 170,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Radar Chart
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.borderSubtle),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                      Icons.hub_rounded,
                                      size: 18,
                                      color:
                                          AppColors.vividViolet),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'NEUROPLASTIC DOMAIN MAP',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          AppColors.vividViolet,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              CognitiveRadarChart(
                                domainScores:
                                    profile.domainMastery,
                                size: 260,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Quick Access Cards Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickAccess(
                                icon:
                                    Icons.graphic_eq_rounded,
                                title: 'Neuro Lounge',
                                subtitle: '40 Hz Gamma Pulse',
                                color: AppColors.amberGold,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const NeuromodulationLoungeScreen(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildQuickAccess(
                                icon: Icons
                                    .monitor_heart_rounded,
                                title: 'Lifestyle Log',
                                subtitle:
                                    'Score: ${lifestyleScore.toStringAsFixed(0)}/100',
                                color:
                                    AppColors.emeraldSynapse,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LifestyleBiomarkersScreen(
                                      controller:
                                          widget.controller,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Daily Protocol Header
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Neuroplasticity Protocol',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${widget.controller.completedDailyCount} / ${widget.controller.dailyProtocols.length} workouts completed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                            // Progress Ring
                            SizedBox(
                              width: 42,
                              height: 42,
                              child: Stack(
                                children: [
                                  CircularProgressIndicator(
                                    value: widget.controller
                                        .dailyCompletionPercentage,
                                    backgroundColor: AppColors
                                        .surfaceElevated,
                                    color:
                                        AppColors.emeraldSynapse,
                                    strokeWidth: 4,
                                  ),
                                  Center(
                                    child: Text(
                                      '${(widget.controller.dailyCompletionPercentage * 100).round()}%',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: AppColors
                                            .emeraldSynapse,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Exercise Protocol Cards
                        ...widget.controller.dailyProtocols
                            .map((item) {
                          final isCompleted = profile
                              .dailyCompletedExercises
                              .contains(item.id);
                          return DailyProtocolCard(
                            item: item,
                            isCompleted: isCompleted,
                            onTap: () =>
                                _navigateToExercise(item.id),
                          );
                        }),

                        // Story Studio Special Card
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StoryStudioScreen(
                                brainCareController:
                                    widget.controller,
                              ),
                            ),
                          ),
                          borderRadius:
                              BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.electricPurple
                                      .withValues(alpha: 0.15),
                                  AppColors.surface,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius:
                                  BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.electricPurple
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .electricPurple
                                        .withValues(
                                            alpha: 0.15),
                                    borderRadius:
                                        BorderRadius.circular(
                                            12),
                                  ),
                                  child: const Icon(
                                    Icons
                                        .auto_stories_rounded,
                                    color: AppColors
                                        .electricPurple,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                    6,
                                                vertical:
                                                    2),
                                        decoration:
                                            BoxDecoration(
                                          color: AppColors
                                              .electricPurple
                                              .withValues(
                                                  alpha:
                                                      0.12),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      4),
                                        ),
                                        child: const Text(
                                          'BONUS STUDIO',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                            color: AppColors
                                                .electricPurple,
                                            letterSpacing:
                                                0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 4),
                                      Text(
                                        'Improvisational Constraint Storytelling',
                                        style: Theme.of(
                                                context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                      ),
                                      Text(
                                        'Dynamic mid-sentence constraints & injections',
                                        style: Theme.of(
                                                context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons
                                      .chevron_right_rounded,
                                  color: AppColors
                                      .electricPurple,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildQuickAccess({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreetingTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

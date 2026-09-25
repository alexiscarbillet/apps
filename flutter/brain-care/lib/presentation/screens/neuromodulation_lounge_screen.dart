import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/binaural_preset_model.dart';
import '../../data/services/audio_synthesizer_service.dart';
import '../widgets/waveform_visualizer.dart';

class NeuromodulationLoungeScreen extends StatefulWidget {
  const NeuromodulationLoungeScreen({super.key});

  @override
  State<NeuromodulationLoungeScreen> createState() =>
      _NeuromodulationLoungeScreenState();
}

class _NeuromodulationLoungeScreenState
    extends State<NeuromodulationLoungeScreen> {
  late AudioSynthesizerService _synth;

  @override
  void initState() {
    super.initState();
    _synth = AudioSynthesizerService();
    _synth.addListener(_onUpdate);
  }

  void _onUpdate() => setState(() {});

  @override
  void dispose() {
    _synth.removeListener(_onUpdate);
    _synth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preset = _synth.activePreset;
    final remaining = _synth.remainingSeconds;
    final mins = remaining ~/ 60;
    final secs = remaining % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Neuromodulation Lounge'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Active Preset Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      preset.themeColor.withValues(alpha: 0.25),
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: preset.themeColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: preset.themeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(preset.icon,
                              color: preset.themeColor, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                preset.frequencyLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: preset.themeColor,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                preset.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Waveform
                    WaveformVisualizer(
                      frequencyHz: preset.targetBeatFrequency,
                      isPulsing: _synth.isPlaying,
                      primaryColor: preset.themeColor,
                      height: 100,
                    ),

                    const SizedBox(height: 14),

                    // Timer display
                    Text(
                      '$mins:${secs.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Play / Pause / Reset Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _synth.reset,
                          icon: const Icon(Icons.replay_rounded),
                          color: AppColors.textSecondary,
                          iconSize: 28,
                          tooltip: 'Reset',
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: _synth.togglePlay,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: preset.themeColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      preset.themeColor.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Icon(
                              _synth.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _synth.toggleIsochronicPulse,
                          icon: Icon(
                            _synth.isIsochronicPulseEnabled
                                ? Icons.graphic_eq_rounded
                                : Icons.graphic_eq_outlined,
                          ),
                          color: _synth.isIsochronicPulseEnabled
                              ? preset.themeColor
                              : AppColors.textMuted,
                          iconSize: 28,
                          tooltip: 'Isochronic Pulse',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Duration Presets
              Row(
                children: [10, 15, 20, 30].map((m) {
                  final isSel =
                      _synth.sessionDurationSeconds == m * 60;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('$m min'),
                        selected: isSel,
                        selectedColor: preset.themeColor,
                        labelStyle: TextStyle(
                          color: isSel
                              ? AppColors.background
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) _synth.setDurationMinutes(m);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Science Description
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.biotech_rounded,
                            size: 16, color: AppColors.electricCyan),
                        const SizedBox(width: 6),
                        Text(
                          preset.scientificFocus.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.electricCyan,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      preset.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Preset Selector List
              Text(
                'FREQUENCY PRESETS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              ...BinauralPresetModel.defaultPresets.map((p) {
                final isActive = p.id == preset.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => _synth.selectPreset(p),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isActive
                            ? p.themeColor.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isActive
                              ? p.themeColor
                              : AppColors.borderSubtle,
                          width: isActive ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(p.icon, color: p.themeColor, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isActive
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${p.frequencyLabel} • ${p.scientificFocus}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isActive)
                            Icon(Icons.check_circle_rounded,
                                color: p.themeColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BinauralPresetModel {
  final String id;
  final String name;
  final String frequencyLabel;
  final double carrierFrequency; // Hz
  final double targetBeatFrequency; // Hz (e.g. 40Hz for gamma)
  final String description;
  final String scientificFocus;
  final IconData icon;
  final Color themeColor;

  const BinauralPresetModel({
    required this.id,
    required this.name,
    required this.frequencyLabel,
    required this.carrierFrequency,
    required this.targetBeatFrequency,
    required this.description,
    required this.scientificFocus,
    required this.icon,
    required this.themeColor,
  });

  static const List<BinauralPresetModel> defaultPresets = [
    BinauralPresetModel(
      id: 'gamma_40',
      name: '40 Hz Gamma Microglia Pulse',
      frequencyLabel: '40 Hz',
      carrierFrequency: 240.0,
      targetBeatFrequency: 40.0,
      description:
          '40 Hz auditory stimulation has been shown in MIT research (Tsai Lab) to synchronize gamma oscillations and recruit microglia for amyloid-beta / tau clearance.',
      scientificFocus: 'Amyloid Clearance & High-Order Synaptic Binding',
      icon: Icons.flash_on_rounded,
      themeColor: AppColors.amberGold,
    ),
    BinauralPresetModel(
      id: 'theta_6',
      name: '6 Hz Theta Memory Imprint',
      frequencyLabel: '6 Hz',
      carrierFrequency: 216.0,
      targetBeatFrequency: 6.0,
      description:
          'Hippocampal theta rhythms are crucial for long-term potentiation (LTP) and encoding episodic memories during learning intervals.',
      scientificFocus: 'Hippocampal Long-Term Potentiation (LTP)',
      icon: Icons.psychology_rounded,
      themeColor: AppColors.electricCyan,
    ),
    BinauralPresetModel(
      id: 'alpha_10',
      name: '10 Hz Alpha Divergent Flow',
      frequencyLabel: '10 Hz',
      carrierFrequency: 200.0,
      targetBeatFrequency: 10.0,
      description:
          'Induces relaxed, open alertness ideal for divergent lateral thinking and reducing cortisol-mediated neurotoxicity.',
      scientificFocus: 'Lateral Creative Thinking & Stress Reduction',
      icon: Icons.spa_rounded,
      themeColor: AppColors.emeraldSynapse,
    ),
    BinauralPresetModel(
      id: 'solfeggio_528',
      name: '528 Hz Harmonic Neuro-Rest',
      frequencyLabel: '528 Hz',
      carrierFrequency: 528.0,
      targetBeatFrequency: 8.0,
      description:
          'Resonant acoustic tone designed for evening wind-down, parasympathetic recovery, and promoting restorative glymphatic slow-wave sleep.',
      scientificFocus: 'Deep Parasympathetic Recovery & Glymphatic Prep',
      icon: Icons.nights_stay_rounded,
      themeColor: AppColors.vividViolet,
    ),
  ];
}

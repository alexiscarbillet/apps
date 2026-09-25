import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum CognitiveDomainType {
  crossModal,
  spatialManipulation,
  workingMemory,
  taskSwitching,
  divergentThinking,
  motorPlasticity,
}

class CognitiveDomainInfo {
  final CognitiveDomainType type;
  final String title;
  final String subtitle;
  final String description;
  final String brainRegion;
  final String neuroplasticBenefit;
  final IconData icon;
  final Color primaryColor;
  final LinearGradient gradient;

  const CognitiveDomainInfo({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.brainRegion,
    required this.neuroplasticBenefit,
    required this.icon,
    required this.primaryColor,
    required this.gradient,
  });
}

class CognitiveDomains {
  static const Map<CognitiveDomainType, CognitiveDomainInfo> domainData = {
    CognitiveDomainType.crossModal: CognitiveDomainInfo(
      type: CognitiveDomainType.crossModal,
      title: 'Synesthesia & Cross-Modal',
      subtitle: 'Sensory Binding & Auditory-Visual Fusion',
      description:
          'Forces your brain to bridge separate sensory cortices (auditory, visual, emotional) creating novel multi-sensory associative synapses.',
      brainRegion: 'Superior Temporal Sulcus & Parietal Associative Cortex',
      neuroplasticBenefit:
          'Reactivates dormant inter-cortical connections and fights single-pathway cognitive atrophy.',
      icon: Icons.graphic_eq_rounded,
      primaryColor: AppColors.electricCyan,
      gradient: AppColors.neuralGradient,
    ),
    CognitiveDomainType.spatialManipulation: CognitiveDomainInfo(
      type: CognitiveDomainType.spatialManipulation,
      title: '3D Spatial Manipulation',
      subtitle: 'Mental Rotation & Volumetric Reasoning',
      description:
          'Mentally project, rotate, and manipulate complex 3D polycube geometry in mind space without 2D plane reliance.',
      brainRegion: 'Right Posterior Parietal Cortex & Hippocampus',
      neuroplasticBenefit:
          'Protects the hippocampus and grid-cell navigational network, the earliest regions affected in Alzheimer\'s.',
      icon: Icons.view_in_ar_rounded,
      primaryColor: AppColors.vividViolet,
      gradient: AppColors.violetRoseGradient,
    ),
    CognitiveDomainType.workingMemory: CognitiveDomainInfo(
      type: CognitiveDomainType.workingMemory,
      title: 'Working Memory & Reverse Flow',
      subtitle: 'Dual N-Back & Chronological Inversion',
      description:
          'Simultaneous multi-stream item retention and reverse chronological sequence reconstruction.',
      brainRegion: 'Dorsolateral Prefrontal Cortex (DLPFC)',
      neuroplasticBenefit:
          'Increases fluid intelligence (Gf) and expands executive buffer capacity against cognitive decay.',
      icon: Icons.sync_alt_rounded,
      primaryColor: AppColors.emeraldSynapse,
      gradient: AppColors.emeraldCyanGradient,
    ),
    CognitiveDomainType.taskSwitching: CognitiveDomainInfo(
      type: CognitiveDomainType.taskSwitching,
      title: 'Executive Task Switching',
      subtitle: 'Dynamic Paradigm Shifts & Inhibition',
      description:
          'Rapidly alternate between completely opposing sorting rules, suppressing automatic cognitive momentum.',
      brainRegion: 'Anterior Cingulate Cortex & Prefrontal Cortex',
      neuroplasticBenefit:
          'Prevents cognitive rigidity and improves mental agility when adapting to unpredictable stimuli.',
      icon: Icons.shuffle_rounded,
      primaryColor: AppColors.amberGold,
      gradient: AppColors.gammaGlowGradient,
    ),
    CognitiveDomainType.divergentThinking: CognitiveDomainInfo(
      type: CognitiveDomainType.divergentThinking,
      title: 'Divergent & Creative Synthesis',
      subtitle: 'Remote Associations & Constraint Storytelling',
      description:
          'Break away from linear logic by finding hyper-distant semantic links and composing improvisational stories with real-time dynamic constraints.',
      brainRegion: 'Default Mode Network (DMN) & Fronto-Insular Hub',
      neuroplasticBenefit:
          'Stimulates creative lateral connectivity, building dense cognitive reserve and linguistic elasticity.',
      icon: Icons.lightbulb_rounded,
      primaryColor: AppColors.neuralRose,
      gradient: AppColors.violetRoseGradient,
    ),
    CognitiveDomainType.motorPlasticity: CognitiveDomainInfo(
      type: CognitiveDomainType.motorPlasticity,
      title: 'Motor-Cortex Mirror Drawing',
      subtitle: 'Non-Dominant Hand & Bilateral Coordination',
      description:
          'Draw symmetrical mirrored patterns and recall geometric strokes using your non-dominant hand.',
      brainRegion: 'Primary Motor Cortex (M1) & Corpus Callosum',
      neuroplasticBenefit:
          'Forces inter-hemispheric communication and builds new neuromuscular motor pathways.',
      icon: Icons.draw_rounded,
      primaryColor: AppColors.deepIndigo,
      gradient: AppColors.neuralGradient,
    ),
  };

  static CognitiveDomainInfo getInfo(CognitiveDomainType type) {
    return domainData[type]!;
  }
}

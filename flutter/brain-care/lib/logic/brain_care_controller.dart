import 'package:flutter/material.dart';
import '../../core/constants/cognitive_domains.dart';
import '../data/models/cognitive_profile_model.dart';
import '../data/models/exercise_session_model.dart';
import '../data/models/lifestyle_biomarker_model.dart';
import '../data/models/story_creation_model.dart';
import '../data/repositories/brain_care_repository.dart';

class DailyProtocolItem {
  final String id;
  final String title;
  final String subtitle;
  final CognitiveDomainType domain;
  final int targetMinutes;
  final IconData icon;

  const DailyProtocolItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.domain,
    required this.targetMinutes,
    required this.icon,
  });
}

class BrainCareController extends ChangeNotifier {
  final BrainCareRepository _repository;

  CognitiveProfileModel _profile = CognitiveProfileModel.initial();
  List<ExerciseSessionModel> _sessions = [];
  List<LifestyleBiomarkerModel> _lifestyleLogs = [];
  List<StoryCreationModel> _stories = [];
  bool _isLoading = true;

  final List<DailyProtocolItem> dailyProtocols = const [
    DailyProtocolItem(
      id: 'dual_n_back',
      title: 'Dual 2-Back Working Memory',
      subtitle: 'Audio-Spatial dual stream encoding',
      domain: CognitiveDomainType.workingMemory,
      targetMinutes: 3,
      icon: Icons.sync_alt_rounded,
    ),
    DailyProtocolItem(
      id: 'mental_rotation',
      title: '3D Mental Rotation Matrix',
      subtitle: 'Hippocampal grid-cell spatial rotation',
      domain: CognitiveDomainType.spatialManipulation,
      targetMinutes: 4,
      icon: Icons.view_in_ar_rounded,
    ),
    DailyProtocolItem(
      id: 'task_switching',
      title: 'Prefrontal Paradigm Switcher',
      subtitle: 'Rapid cognitive flexibility & inhibition',
      domain: CognitiveDomainType.taskSwitching,
      targetMinutes: 3,
      icon: Icons.shuffle_rounded,
    ),
    DailyProtocolItem(
      id: 'divergent_associates',
      title: 'Divergent Triad Synthesis',
      subtitle: 'Lateral semantic bridge connections',
      domain: CognitiveDomainType.divergentThinking,
      targetMinutes: 4,
      icon: Icons.lightbulb_rounded,
    ),
    DailyProtocolItem(
      id: 'motor_drawing',
      title: 'Mirror Motor-Cortex Canvas',
      subtitle: 'Non-dominant hand bilateral coordination',
      domain: CognitiveDomainType.motorPlasticity,
      targetMinutes: 4,
      icon: Icons.draw_rounded,
    ),
    DailyProtocolItem(
      id: 'cross_modal',
      title: 'Synesthesia & Sensory Fusion',
      subtitle: 'Harmonic color-rhythm binding',
      domain: CognitiveDomainType.crossModal,
      targetMinutes: 3,
      icon: Icons.graphic_eq_rounded,
    ),
  ];

  BrainCareController({BrainCareRepository? repository})
      : _repository = repository ?? BrainCareRepository() {
    loadAllData();
  }

  CognitiveProfileModel get profile => _profile;
  List<ExerciseSessionModel> get sessions => _sessions;
  List<LifestyleBiomarkerModel> get lifestyleLogs => _lifestyleLogs;
  List<StoryCreationModel> get stories => _stories;
  bool get isLoading => _isLoading;

  LifestyleBiomarkerModel get todayBiomarkers {
    if (_lifestyleLogs.isEmpty) return LifestyleBiomarkerModel.defaultToday();
    final now = DateTime.now();
    return _lifestyleLogs.firstWhere(
      (e) =>
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day,
      orElse: () => LifestyleBiomarkerModel.defaultToday(),
    );
  }

  int get completedDailyCount {
    int count = 0;
    for (final p in dailyProtocols) {
      if (_profile.dailyCompletedExercises.contains(p.id)) {
        count++;
      }
    }
    return count;
  }

  double get dailyCompletionPercentage =>
      dailyProtocols.isEmpty ? 0 : (completedDailyCount / dailyProtocols.length);

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    _profile = await _repository.getProfile();
    _sessions = await _repository.getSessions();
    _lifestyleLogs = await _repository.getLifestyleLogs();
    _stories = await _repository.getStories();

    _checkStreak();

    _isLoading = false;
    notifyListeners();
  }

  void _checkStreak() {
    final now = DateTime.now();
    final last = _profile.lastActiveDate;
    final diffDays = DateTime(now.year, now.month, now.day)
        .difference(DateTime(last.year, last.month, last.day))
        .inDays;

    if (diffDays == 1) {
      // Maintained streak
    } else if (diffDays > 1) {
      // Reset streak or mark 1
      _profile = _profile.copyWith(streakDays: 1, dailyCompletedExercises: []);
      _repository.updateProfile(_profile);
    }
  }

  Future<void> recordCompletedSession(ExerciseSessionModel session) async {
    await _repository.addSession(session);
    _profile = await _repository.getProfile();
    _sessions = await _repository.getSessions();
    notifyListeners();
  }

  Future<void> updateMotivation(String newWhy) async {
    _profile = _profile.copyWith(personalWhyMotivation: newWhy);
    await _repository.updateProfile(_profile);
    notifyListeners();
  }

  Future<void> saveBiomarkerEntry(LifestyleBiomarkerModel entry) async {
    await _repository.saveLifestyleLog(entry);
    _lifestyleLogs = await _repository.getLifestyleLogs();
    notifyListeners();
  }

  Future<void> saveStoryEntry(StoryCreationModel story) async {
    await _repository.saveStory(story);
    _stories = await _repository.getStories();
    notifyListeners();
  }
}

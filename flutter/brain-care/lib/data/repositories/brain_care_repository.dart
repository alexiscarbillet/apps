import '../../core/constants/cognitive_domains.dart';
import '../models/cognitive_profile_model.dart';
import '../models/exercise_session_model.dart';
import '../models/lifestyle_biomarker_model.dart';
import '../models/story_creation_model.dart';
import '../services/local_storage_service.dart';

class BrainCareRepository {
  final LocalStorageService _storage;

  BrainCareRepository({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService();

  Future<CognitiveProfileModel> getProfile() => _storage.loadProfile();

  Future<void> updateProfile(CognitiveProfileModel profile) =>
      _storage.saveProfile(profile);

  Future<List<ExerciseSessionModel>> getSessions() => _storage.loadSessions();

  Future<CognitiveProfileModel> syncProfileFromUsage() async {
    final profile = await _storage.loadProfile();
    final sessions = await _storage.loadSessions();

    final updatedMastery = {
      for (final domain in CognitiveDomainType.values) domain: 0.0,
    };

    for (final session in sessions) {
      final current = updatedMastery[session.domain] ?? 0.0;
      final next = (current * 0.7 + session.scorePercent * 0.3).clamp(0.0, 100.0);
      updatedMastery[session.domain] = double.parse(next.toStringAsFixed(1));
    }

    final avgMastery = updatedMastery.values.isEmpty
        ? 0.0
        : updatedMastery.values.reduce((a, b) => a + b) /
            updatedMastery.length;
    final totalMinutes = sessions.fold<int>(
      0,
      (sum, session) => sum + (session.durationSeconds ~/ 60),
    );
    final dailyList = sessions.map((e) => e.exerciseId).toSet().toList();
    final latestTimestamp = sessions.isNotEmpty
        ? sessions.first.timestamp
        : profile.lastActiveDate;

    final updatedProfile = profile.copyWith(
      domainMastery: updatedMastery,
      cognitiveReserveIndex: double.parse(avgMastery.toStringAsFixed(1)),
      totalTrainingMinutes: totalMinutes,
      dailyCompletedExercises: dailyList,
      lastActiveDate: latestTimestamp,
    );

    await _storage.saveProfile(updatedProfile);
    return updatedProfile;
  }

  Future<void> addSession(ExerciseSessionModel session) async {
    final list = await _storage.loadSessions();
    list.insert(0, session);
    await _storage.saveSessions(list);

    final profile = await _storage.loadProfile();
    final updatedMastery = Map<CognitiveDomainType, double>.from(
      profile.domainMastery,
    );

    final currentDomainScore = updatedMastery[session.domain] ?? 0.0;
    final newScore = (currentDomainScore * 0.7 + session.scorePercent * 0.3)
        .clamp(0.0, 100.0);
    updatedMastery[session.domain] = double.parse(newScore.toStringAsFixed(1));

    final avgMastery = updatedMastery.values.isEmpty
        ? 0.0
        : updatedMastery.values.reduce((a, b) => a + b) /
            updatedMastery.length;
    final totalMins = profile.totalTrainingMinutes + (session.durationSeconds ~/ 60);

    final dailyList = List<String>.from(profile.dailyCompletedExercises);
    if (!dailyList.contains(session.exerciseId)) {
      dailyList.add(session.exerciseId);
    }

    final updatedProfile = profile.copyWith(
      domainMastery: updatedMastery,
      cognitiveReserveIndex: double.parse(avgMastery.toStringAsFixed(1)),
      totalTrainingMinutes: totalMins,
      dailyCompletedExercises: dailyList,
      lastActiveDate: DateTime.now(),
    );

    await _storage.saveProfile(updatedProfile);
  }

  Future<List<LifestyleBiomarkerModel>> getLifestyleLogs() =>
      _storage.loadLifestyleLogs();

  Future<void> saveLifestyleLog(LifestyleBiomarkerModel log) async {
    final list = await _storage.loadLifestyleLogs();
    final index = list.indexWhere((e) =>
        e.date.year == log.date.year &&
        e.date.month == log.date.month &&
        e.date.day == log.date.day);
    if (index >= 0) {
      list[index] = log;
    } else {
      list.insert(0, log);
    }
    await _storage.saveLifestyleLogs(list);
  }

  Future<List<StoryCreationModel>> getStories() => _storage.loadStories();

  Future<void> saveStory(StoryCreationModel story) async {
    final list = await _storage.loadStories();
    list.insert(0, story);
    await _storage.saveStories(list);
  }
}

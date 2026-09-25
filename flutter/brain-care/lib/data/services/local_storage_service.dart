import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cognitive_profile_model.dart';
import '../models/exercise_session_model.dart';
import '../models/lifestyle_biomarker_model.dart';
import '../models/story_creation_model.dart';

class LocalStorageService {
  static const String _keyProfile = 'braincare_profile';
  static const String _keySessions = 'braincare_sessions';
  static const String _keyLifestyle = 'braincare_lifestyle';
  static const String _keyStories = 'braincare_stories';

  Future<CognitiveProfileModel> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyProfile);
    if (jsonStr == null) {
      final initial = CognitiveProfileModel.initial();
      await saveProfile(initial);
      return initial;
    }
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return CognitiveProfileModel.fromJson(map);
    } catch (_) {
      return CognitiveProfileModel.initial();
    }
  }

  Future<void> saveProfile(CognitiveProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  Future<List<ExerciseSessionModel>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keySessions);
    if (jsonStr == null) return _seedSessions();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => ExerciseSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _seedSessions();
    }
  }

  Future<void> saveSessions(List<ExerciseSessionModel> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final list = sessions.map((e) => e.toJson()).toList();
    await prefs.setString(_keySessions, jsonEncode(list));
  }

  Future<List<LifestyleBiomarkerModel>> loadLifestyleLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLifestyle);
    if (jsonStr == null) return _seedLifestyleLogs();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) =>
              LifestyleBiomarkerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _seedLifestyleLogs();
    }
  }

  Future<void> saveLifestyleLogs(List<LifestyleBiomarkerModel> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final list = logs.map((e) => e.toJson()).toList();
    await prefs.setString(_keyLifestyle, jsonEncode(list));
  }

  Future<List<StoryCreationModel>> loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyStories);
    if (jsonStr == null) return _seedStories();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => StoryCreationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _seedStories();
    }
  }

  Future<void> saveStories(List<StoryCreationModel> stories) async {
    final prefs = await SharedPreferences.getInstance();
    final list = stories.map((e) => e.toJson()).toList();
    await prefs.setString(_keyStories, jsonEncode(list));
  }

  List<ExerciseSessionModel> _seedSessions() {
    final now = DateTime.now();
    return [
      ExerciseSessionModel(
        id: 'sess_1',
        exerciseId: 'dual_n_back',
        exerciseTitle: 'Dual 2-Back Spatial & Sound',
        domain: CognitiveDomainType.workingMemory,
        timestamp: now.subtract(const Duration(days: 1)),
        durationSeconds: 180,
        scorePercent: 88.0,
        noveltyPointsGained: 120,
        metadata: {'n_level': 2, 'hits': 18, 'misses': 2},
      ),
      ExerciseSessionModel(
        id: 'sess_2',
        exerciseId: 'divergent_associates',
        exerciseTitle: 'Remote Triad Synthesis',
        domain: CognitiveDomainType.divergentThinking,
        timestamp: now.subtract(const Duration(days: 2)),
        durationSeconds: 240,
        scorePercent: 92.0,
        noveltyPointsGained: 150,
        metadata: {'triads_solved': 4},
      ),
    ];
  }

  List<LifestyleBiomarkerModel> _seedLifestyleLogs() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return LifestyleBiomarkerModel(
        date: d,
        sleepHours: 7.2 + (i % 3) * 0.4,
        deepSleepPercentage: 18 + (i % 4) * 2,
        mindDietScore: 10 + (i % 5),
        aerobicBdnfMinutes: 30 + (i % 2) * 15,
        resistanceTrainingMinutes: (i % 2 == 0) ? 25 : 0,
        novelSkillMinutes: 20 + (i % 3) * 10,
        socialConnectionRating: 4,
        stressManagementRating: 4,
      );
    });
  }

  List<StoryCreationModel> _seedStories() {
    return [
      StoryCreationModel(
        id: 'story_seed_1',
        title: 'The Clockmaker\'s Compass',
        content:
            'A quiet workshop ticked softly. A forgotten compass spun wildly, pointing not north, but toward an ancient oak outside. In the moss sat a glowing crystal glowing with silent light...',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        activeConstraints: ['Avoid letter E', 'Shift Tone: Mystery -> Wonder'],
        injectedWords: ['Compass', 'Crystal', 'Oak'],
        wordCount: 145,
        creativityScore: 94.0,
      ),
    ];
  }
}

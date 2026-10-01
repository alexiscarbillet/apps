import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/cognitive_domains.dart';
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
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => ExerciseSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
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
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) =>
              LifestyleBiomarkerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
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
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => StoryCreationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveStories(List<StoryCreationModel> stories) async {
    final prefs = await SharedPreferences.getInstance();
    final list = stories.map((e) => e.toJson()).toList();
    await prefs.setString(_keyStories, jsonEncode(list));
  }

}

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/binaural_preset_model.dart';

class AudioSynthesizerService extends ChangeNotifier {
  BinauralPresetModel _activePreset = BinauralPresetModel.defaultPresets[0];
  bool _isPlaying = false;
  int _sessionDurationSeconds = 15 * 60; // 15 mins default
  int _elapsedSeconds = 0;
  Timer? _timer;
  double _volume = 0.75;
  bool _isIsochronicPulseEnabled = true;

  BinauralPresetModel get activePreset => _activePreset;
  bool get isPlaying => _isPlaying;
  int get sessionDurationSeconds => _sessionDurationSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  int get remainingSeconds =>
      (_sessionDurationSeconds - _elapsedSeconds).clamp(0, 999999);
  double get volume => _volume;
  bool get isIsochronicPulseEnabled => _isIsochronicPulseEnabled;

  void selectPreset(BinauralPresetModel preset) {
    _activePreset = preset;
    notifyListeners();
  }

  void setDurationMinutes(int minutes) {
    _sessionDurationSeconds = minutes * 60;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  void setVolume(double val) {
    _volume = val.clamp(0.0, 1.0);
    notifyListeners();
  }

  void toggleIsochronicPulse() {
    _isIsochronicPulseEnabled = !_isIsochronicPulseEnabled;
    notifyListeners();
  }

  void togglePlay() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void play() {
    _isPlaying = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsedSeconds < _sessionDurationSeconds) {
        _elapsedSeconds++;
        notifyListeners();
      } else {
        pause();
      }
    });
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    pause();
    _elapsedSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

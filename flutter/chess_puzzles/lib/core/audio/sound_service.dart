import 'package:flutter/services.dart';

class SoundService {
  static bool soundEnabled = true;
  static bool hapticsEnabled = true;

  static void playMoveSound() {
    if (hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  static void playCaptureSound() {
    if (hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  static void playCheckSound() {
    if (hapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  static void playVictorySound() {
    if (hapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  static void playMistakeSound() {
    if (hapticsEnabled) {
      HapticFeedback.vibrate();
    }
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }
}

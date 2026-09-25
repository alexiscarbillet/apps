import 'dart:async';
import 'package:flutter/material.dart';

class StretchRoutine {
  final String title;
  final String durationText;
  final String targetArea;
  final IconData icon;
  final List<String> steps;
  final String physiologicalBenefit;

  const StretchRoutine({
    required this.title,
    required this.durationText,
    required this.targetArea,
    required this.icon,
    required this.steps,
    required this.physiologicalBenefit,
  });
}

class MovementTimerController extends ChangeNotifier {
  int _intervalMinutes = 45;
  int get intervalMinutes => _intervalMinutes;

  int _remainingSeconds = 45 * 60;
  int get remainingSeconds => _remainingSeconds;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  bool _isBreakTime = false;
  bool get isBreakTime => _isBreakTime;

  int _breaksCompletedToday = 0;
  int get breaksCompletedToday => _breaksCompletedToday;

  Timer? _timer;

  int get activeRoutineIndex => _activeRoutineIndex;
  int _activeRoutineIndex = 0;

  static const List<StretchRoutine> routines = [
    StretchRoutine(
      title: 'Spinal Decompression & Posture Reset',
      durationText: '5 Minutes',
      targetArea: 'Thoracic Spine & Lower Back',
      icon: Icons.accessibility_new_rounded,
      steps: [
        'Stand tall with feet shoulder-width apart.',
        'Reach arms toward ceiling, clasping fingers together and extending upward for 30s.',
        'Gentle standing side bend left and right for 45s.',
        'Cat-cow movement against standing desk edge (10 repetitions).',
        'Standing hamstring and calf stretch against wall (60s each side).',
      ],
      physiologicalBenefit:
          'Re-hydrates intervertebral spinal discs and opens the chest cavity for full diaphragmatic oxygenation.',
    ),
    StretchRoutine(
      title: 'Micro-Walking & Glucose Clearance',
      durationText: '5 Minutes',
      targetArea: 'Lower Extremities & Vascular System',
      icon: Icons.directions_walk_rounded,
      steps: [
        'Brisk corridor or outdoor pacing for 3 minutes.',
        '20 standing calf raises (solus muscle pump activates blood return to heart).',
        '10 bodyweight air squats with deep breathing.',
        'Drink 1 glass of cold mineralized water.',
      ],
      physiologicalBenefit:
          'Activates the soleus muscle pump, clearing circulating blood glucose and restoring endothelial nitric oxide production.',
    ),
    StretchRoutine(
      title: 'Hip Flexor & Glute Activation',
      durationText: '5 Minutes',
      targetArea: 'Psoas, Iliopsoas & Hip Capsules',
      icon: Icons.fitness_center_rounded,
      steps: [
        'Standing lunge stretch with rear glute squeezed (45s each leg).',
        'Standing figure-4 hip stretch holding chair (45s each leg).',
        '15 glute bridges or standing glute kickbacks.',
        'Gentle pelvic tilts to neutralize lumbar lordosis.',
      ],
      physiologicalBenefit:
          'Unlocks chronically shortened hip flexors caused by seated posture, preventing chronic lower back strain.',
    ),
    StretchRoutine(
      title: '20-20-20 Eye & Suboccipital Relief',
      durationText: '3 Minutes',
      targetArea: 'Eyes, C-Spine & Trapezius',
      icon: Icons.remove_red_eye_rounded,
      steps: [
        'Look at an object at least 20 feet away for 20 seconds.',
        'Gentle chin tucks into chest to stretch suboccipital muscles (10 reps).',
        'Slow shoulder rolls backward (15 reps) and forward (15 reps).',
        'Slow neck ear-to-shoulder side tilts with light breath.',
      ],
      physiologicalBenefit:
          'Relaxes the ciliary eye muscles, relieves digital eye fatigue, and decompresses upper cervical nerve roots.',
    ),
  ];

  StretchRoutine get currentRoutine => routines[_activeRoutineIndex % routines.length];

  void setIntervalMinutes(int minutes) {
    _intervalMinutes = minutes;
    if (!_isRunning) {
      _remainingSeconds = minutes * 60;
    }
    notifyListeners();
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _isBreakTime = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        _isBreakTime = true;
        _activeRoutineIndex = (_activeRoutineIndex + 1) % routines.length;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    _isRunning = false;
    _timer?.cancel();
    _isBreakTime = false;
    _remainingSeconds = _intervalMinutes * 60;
    notifyListeners();
  }

  void completeBreak({Function()? onCompleted}) {
    _breaksCompletedToday++;
    _isBreakTime = false;
    _remainingSeconds = _intervalMinutes * 60;
    if (onCompleted != null) onCompleted();
    startTimer();
    notifyListeners();
  }

  void selectRoutine(int index) {
    _activeRoutineIndex = index;
    notifyListeners();
  }

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get progressFraction {
    final total = _intervalMinutes * 60;
    if (total <= 0) return 0;
    return (total - _remainingSeconds) / total;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

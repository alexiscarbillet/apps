class LifestyleBiomarkerModel {
  final DateTime date;
  final double sleepHours;
  final int deepSleepPercentage; // e.g. 20% for glymphatic clearance
  final int mindDietScore; // 0 to 15 (MIND diet adherence)
  final int aerobicBdnfMinutes; // Zone 2 / brisk cardio
  final int resistanceTrainingMinutes;
  final int novelSkillMinutes; // Learning language, instrument, non-routine motor
  final int socialConnectionRating; // 1 to 5
  final int stressManagementRating; // 1 to 5 (meditation, breathwork)

  const LifestyleBiomarkerModel({
    required this.date,
    required this.sleepHours,
    required this.deepSleepPercentage,
    required this.mindDietScore,
    required this.aerobicBdnfMinutes,
    required this.resistanceTrainingMinutes,
    required this.novelSkillMinutes,
    required this.socialConnectionRating,
    required this.stressManagementRating,
  });

  double get lifestyleLongevityScore {
    double score = 0;
    // Sleep (target 7-9h, deep > 15%)
    if (sleepHours >= 7 && sleepHours <= 9) score += 20;
    else if (sleepHours >= 6) score += 12;
    if (deepSleepPercentage >= 18) score += 10;
    else if (deepSleepPercentage >= 12) score += 6;

    // MIND Diet (target >= 10/15)
    score += (mindDietScore / 15.0) * 25.0;

    // BDNF Aerobic / Exercise (target 30+ mins)
    if (aerobicBdnfMinutes + resistanceTrainingMinutes >= 30) {
      score += 20;
    } else {
      score += ((aerobicBdnfMinutes + resistanceTrainingMinutes) / 30.0) * 20;
    }

    // Novel skill (target 15+ mins)
    if (novelSkillMinutes >= 15) score += 15;
    else score += (novelSkillMinutes / 15.0) * 15;

    // Social & Stress
    score += (socialConnectionRating / 5.0) * 5;
    score += (stressManagementRating / 5.0) * 5;

    return score.clamp(0.0, 100.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'sleepHours': sleepHours,
      'deepSleepPercentage': deepSleepPercentage,
      'mindDietScore': mindDietScore,
      'aerobicBdnfMinutes': aerobicBdnfMinutes,
      'resistanceTrainingMinutes': resistanceTrainingMinutes,
      'novelSkillMinutes': novelSkillMinutes,
      'socialConnectionRating': socialConnectionRating,
      'stressManagementRating': stressManagementRating,
    };
  }

  factory LifestyleBiomarkerModel.fromJson(Map<String, dynamic> json) {
    return LifestyleBiomarkerModel(
      date: DateTime.parse(json['date'] as String),
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 7.5,
      deepSleepPercentage: json['deepSleepPercentage'] as int? ?? 20,
      mindDietScore: json['mindDietScore'] as int? ?? 11,
      aerobicBdnfMinutes: json['aerobicBdnfMinutes'] as int? ?? 35,
      resistanceTrainingMinutes:
          json['resistanceTrainingMinutes'] as int? ?? 20,
      novelSkillMinutes: json['novelSkillMinutes'] as int? ?? 25,
      socialConnectionRating: json['socialConnectionRating'] as int? ?? 4,
      stressManagementRating: json['stressManagementRating'] as int? ?? 4,
    );
  }

  static LifestyleBiomarkerModel defaultToday() {
    return LifestyleBiomarkerModel(
      date: DateTime.now(),
      sleepHours: 7.8,
      deepSleepPercentage: 21,
      mindDietScore: 12,
      aerobicBdnfMinutes: 35,
      resistanceTrainingMinutes: 20,
      novelSkillMinutes: 30,
      socialConnectionRating: 4,
      stressManagementRating: 4,
    );
  }
}

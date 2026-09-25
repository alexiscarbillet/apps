class DailyHabitLog {
  final String dateKey; // yyyy-MM-dd
  final int leafyGreensServings; // Target: 3+
  final int noUpfMeals;          // Target: 3 clean meals
  final double alcoholUnits;     // Target: 0 units
  final int waterGlasses;        // Target: 8 glasses (250ml each)
  final int standingBreaks;      // Target: 6+ 5-min movement sessions
  final bool sunscreenApplied;   // UV protection adherence
  final bool resistanceTrained;  // Musculoskeletal longevity
  final String notes;

  const DailyHabitLog({
    required this.dateKey,
    this.leafyGreensServings = 0,
    this.noUpfMeals = 0,
    this.alcoholUnits = 0.0,
    this.waterGlasses = 0,
    this.standingBreaks = 0,
    this.sunscreenApplied = false,
    this.resistanceTrained = false,
    this.notes = '',
  });

  /// Calculates a daily preventative adherence score between 0% and 100%
  double get adherenceScore {
    double score = 0.0;
    
    // Leafy greens (up to 25 points)
    score += (leafyGreensServings.clamp(0, 3) / 3.0) * 25.0;

    // UPF-free clean nutrition (up to 20 points)
    score += (noUpfMeals.clamp(0, 3) / 3.0) * 20.0;

    // Alcohol-free / low alcohol (up to 15 points)
    if (alcoholUnits == 0) {
      score += 15.0;
    } else if (alcoholUnits <= 1) {
      score += 8.0;
    }

    // Hydration (up to 15 points)
    score += (waterGlasses.clamp(0, 8) / 8.0) * 15.0;

    // Movement & Sitting breaks (up to 15 points)
    score += (standingBreaks.clamp(0, 6) / 6.0) * 15.0;

    // UV Sunscreen (up to 10 points)
    if (sunscreenApplied) score += 10.0;

    return score.clamp(0.0, 100.0);
  }

  DailyHabitLog copyWith({
    String? dateKey,
    int? leafyGreensServings,
    int? noUpfMeals,
    double? alcoholUnits,
    int? waterGlasses,
    int? standingBreaks,
    bool? sunscreenApplied,
    bool? resistanceTrained,
    String? notes,
  }) {
    return DailyHabitLog(
      dateKey: dateKey ?? this.dateKey,
      leafyGreensServings: leafyGreensServings ?? this.leafyGreensServings,
      noUpfMeals: noUpfMeals ?? this.noUpfMeals,
      alcoholUnits: alcoholUnits ?? this.alcoholUnits,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      standingBreaks: standingBreaks ?? this.standingBreaks,
      sunscreenApplied: sunscreenApplied ?? this.sunscreenApplied,
      resistanceTrained: resistanceTrained ?? this.resistanceTrained,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'dateKey': dateKey,
    'leafyGreensServings': leafyGreensServings,
    'noUpfMeals': noUpfMeals,
    'alcoholUnits': alcoholUnits,
    'waterGlasses': waterGlasses,
    'standingBreaks': standingBreaks,
    'sunscreenApplied': sunscreenApplied,
    'resistanceTrained': resistanceTrained,
    'notes': notes,
  };

  factory DailyHabitLog.fromJson(Map<String, dynamic> json) => DailyHabitLog(
    dateKey: json['dateKey'] as String,
    leafyGreensServings: json['leafyGreensServings'] as int? ?? 0,
    noUpfMeals: json['noUpfMeals'] as int? ?? 0,
    alcoholUnits: (json['alcoholUnits'] as num?)?.toDouble() ?? 0.0,
    waterGlasses: json['waterGlasses'] as int? ?? 0,
    standingBreaks: json['standingBreaks'] as int? ?? 0,
    sunscreenApplied: json['sunscreenApplied'] as bool? ?? false,
    resistanceTrained: json['resistanceTrained'] as bool? ?? false,
    notes: json['notes'] as String? ?? '',
  );
}

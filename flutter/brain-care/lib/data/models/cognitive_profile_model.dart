import '../../core/constants/cognitive_domains.dart';

class CognitiveProfileModel {
  final String userName;
  final int age;
  final int streakDays;
  final int totalTrainingMinutes;
  final double cognitiveReserveIndex; // 0 to 100
  final Map<CognitiveDomainType, double> domainMastery; // 0 to 100
  final List<String> dailyCompletedExercises;
  final DateTime lastActiveDate;
  final String personalWhyMotivation;

  const CognitiveProfileModel({
    required this.userName,
    required this.age,
    required this.streakDays,
    required this.totalTrainingMinutes,
    required this.cognitiveReserveIndex,
    required this.domainMastery,
    required this.dailyCompletedExercises,
    required this.lastActiveDate,
    required this.personalWhyMotivation,
  });

  factory CognitiveProfileModel.initial() {
    return CognitiveProfileModel(
      userName: 'Brain Athlete',
      age: 42,
      streakDays: 5,
      totalTrainingMinutes: 240,
      cognitiveReserveIndex: 78.5,
      domainMastery: {
        CognitiveDomainType.crossModal: 74.0,
        CognitiveDomainType.spatialManipulation: 82.0,
        CognitiveDomainType.workingMemory: 70.0,
        CognitiveDomainType.taskSwitching: 85.0,
        CognitiveDomainType.divergentThinking: 78.0,
        CognitiveDomainType.motorPlasticity: 68.0,
      },
      dailyCompletedExercises: ['dual_n_back', 'divergent_associates'],
      lastActiveDate: DateTime.now(),
      personalWhyMotivation:
          'Proactively building synaptic density & cognitive reserve against familial neurodegeneration.',
    );
  }

  CognitiveProfileModel copyWith({
    String? userName,
    int? age,
    int? streakDays,
    int? totalTrainingMinutes,
    double? cognitiveReserveIndex,
    Map<CognitiveDomainType, double>? domainMastery,
    List<String>? dailyCompletedExercises,
    DateTime? lastActiveDate,
    String? personalWhyMotivation,
  }) {
    return CognitiveProfileModel(
      userName: userName ?? this.userName,
      age: age ?? this.age,
      streakDays: streakDays ?? this.streakDays,
      totalTrainingMinutes:
          totalTrainingMinutes ?? this.totalTrainingMinutes,
      cognitiveReserveIndex:
          cognitiveReserveIndex ?? this.cognitiveReserveIndex,
      domainMastery: domainMastery ?? this.domainMastery,
      dailyCompletedExercises:
          dailyCompletedExercises ?? this.dailyCompletedExercises,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      personalWhyMotivation:
          personalWhyMotivation ?? this.personalWhyMotivation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'age': age,
      'streakDays': streakDays,
      'totalTrainingMinutes': totalTrainingMinutes,
      'cognitiveReserveIndex': cognitiveReserveIndex,
      'domainMastery': domainMastery.map(
        (key, value) => MapEntry(key.name, value),
      ),
      'dailyCompletedExercises': dailyCompletedExercises,
      'lastActiveDate': lastActiveDate.toIso8601String(),
      'personalWhyMotivation': personalWhyMotivation,
    };
  }

  factory CognitiveProfileModel.fromJson(Map<String, dynamic> json) {
    final domainMap = <CognitiveDomainType, double>{};
    if (json['domainMastery'] != null) {
      final rawMap = json['domainMastery'] as Map<String, dynamic>;
      for (final entry in rawMap.entries) {
        final domainType = CognitiveDomainType.values.firstWhere(
          (e) => e.name == entry.key,
          orElse: () => CognitiveDomainType.crossModal,
        );
        domainMap[domainType] = (entry.value as num).toDouble();
      }
    } else {
      for (final type in CognitiveDomainType.values) {
        domainMap[type] = 70.0;
      }
    }

    return CognitiveProfileModel(
      userName: json['userName'] as String? ?? 'Brain Athlete',
      age: json['age'] as int? ?? 42,
      streakDays: json['streakDays'] as int? ?? 0,
      totalTrainingMinutes: json['totalTrainingMinutes'] as int? ?? 0,
      cognitiveReserveIndex:
          (json['cognitiveReserveIndex'] as num?)?.toDouble() ?? 70.0,
      domainMastery: domainMap,
      dailyCompletedExercises:
          (json['dailyCompletedExercises'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'] as String)
          : DateTime.now(),
      personalWhyMotivation: json['personalWhyMotivation'] as String? ??
          'Building neuroplastic cognitive reserve for lifelong vitality.',
    );
  }
}

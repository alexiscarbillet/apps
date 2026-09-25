import '../../core/constants/cognitive_domains.dart';

class ExerciseSessionModel {
  final String id;
  final String exerciseId;
  final String exerciseTitle;
  final CognitiveDomainType domain;
  final DateTime timestamp;
  final int durationSeconds;
  final double scorePercent; // 0 to 100
  final int noveltyPointsGained;
  final Map<String, dynamic> metadata;

  const ExerciseSessionModel({
    required this.id,
    required this.exerciseId,
    required this.exerciseTitle,
    required this.domain,
    required this.timestamp,
    required this.durationSeconds,
    required this.scorePercent,
    required this.noveltyPointsGained,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseTitle': exerciseTitle,
      'domain': domain.name,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
      'scorePercent': scorePercent,
      'noveltyPointsGained': noveltyPointsGained,
      'metadata': metadata,
    };
  }

  factory ExerciseSessionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseSessionModel(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      exerciseTitle: json['exerciseTitle'] as String,
      domain: CognitiveDomainType.values.firstWhere(
        (e) => e.name == json['domain'],
        orElse: () => CognitiveDomainType.crossModal,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      durationSeconds: json['durationSeconds'] as int? ?? 120,
      scorePercent: (json['scorePercent'] as num?)?.toDouble() ?? 80.0,
      noveltyPointsGained: json['noveltyPointsGained'] as int? ?? 100,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }
}

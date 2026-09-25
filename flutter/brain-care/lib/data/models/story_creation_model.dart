class StoryCreationModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final List<String> activeConstraints;
  final List<String> injectedWords;
  final int wordCount;
  final double creativityScore;

  const StoryCreationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.activeConstraints,
    required this.injectedWords,
    required this.wordCount,
    required this.creativityScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'activeConstraints': activeConstraints,
      'injectedWords': injectedWords,
      'wordCount': wordCount,
      'creativityScore': creativityScore,
    };
  }

  factory StoryCreationModel.fromJson(Map<String, dynamic> json) {
    return StoryCreationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      activeConstraints: (json['activeConstraints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      injectedWords: (json['injectedWords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      wordCount: json['wordCount'] as int? ?? 0,
      creativityScore:
          (json['creativityScore'] as num?)?.toDouble() ?? 85.0,
    );
  }
}

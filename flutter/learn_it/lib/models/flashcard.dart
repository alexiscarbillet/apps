class Flashcard {
  final String frontTitle;
  final String frontSubtitle;
  final String backTitle;
  final String backExplanation;
  final List<String>? bulletPoints;
  final String? codeSnippet;
  final bool isConcept;

  Flashcard({
    required this.frontTitle,
    required this.frontSubtitle,
    required this.backTitle,
    required this.backExplanation,
    this.bulletPoints,
    this.codeSnippet,
    required this.isConcept,
  });
}

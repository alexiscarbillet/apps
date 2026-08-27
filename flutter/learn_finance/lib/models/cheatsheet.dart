class CheatsheetSection {
  final String title;
  final String content;
  final List<String> bulletPoints;
  final String? codeSnippet;

  CheatsheetSection({
    required this.title,
    required this.content,
    required this.bulletPoints,
    this.codeSnippet,
  });
}

class Cheatsheet {
  final String category;
  final String summary;
  final List<CheatsheetSection> sections;

  Cheatsheet({
    required this.category,
    required this.summary,
    required this.sections,
  });
}

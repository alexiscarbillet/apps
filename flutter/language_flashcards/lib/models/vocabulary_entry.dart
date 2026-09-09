enum LanguageSection {
  russian,
  spanish,
}

extension LanguageSectionLabel on LanguageSection {
  String get label => switch (this) {
        LanguageSection.russian => 'Russian',
        LanguageSection.spanish => 'Spanish',
      };

  String get direction => switch (this) {
        LanguageSection.russian => 'English → Russian',
        LanguageSection.spanish => 'English → Spanish',
      };
}

class VocabularyEntry {
  const VocabularyEntry({
    required this.english,
    required this.translation,
    this.pronunciation,
  });

  final String english;
  final String translation;
  final String? pronunciation;
}

enum LanguageSection {
  russian,
  spanish,
  italian,
}

extension LanguageSectionLabel on LanguageSection {
  String get label => switch (this) {
        LanguageSection.russian => 'Russian',
        LanguageSection.spanish => 'Spanish',
        LanguageSection.italian => 'Italian',
      };

  String get direction => switch (this) {
        LanguageSection.russian => 'English → Russian',
        LanguageSection.spanish => 'English → Spanish',
        LanguageSection.italian => 'English → Italian',
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

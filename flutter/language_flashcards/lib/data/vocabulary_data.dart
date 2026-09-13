import 'dart:math';

import '../models/flashcard.dart';
import '../models/vocabulary_entry.dart';
import 'italian_vocabulary.dart';
import 'russian_vocabulary.dart';
import 'spanish_vocabulary.dart';

class VocabularyRepository {
  static final Map<LanguageSection, List<VocabularyEntry>> _entries = {
    LanguageSection.russian: _buildEntries(russianVocabulary),
    LanguageSection.spanish: _buildEntries(spanishVocabulary),
    LanguageSection.italian: _buildEntries(italianVocabulary),
  };

  static List<VocabularyEntry> _buildEntries(Map<String, String> dictionary) {
    final entries = <VocabularyEntry>[];
    for (final entry in dictionary.entries) {
      entries.add(
        VocabularyEntry(
          english: entry.key.trim(),
          translation: entry.value.trim(),
        ),
      );
    }
    entries.sort((a, b) => a.english.compareTo(b.english));
    return entries;
  }

  static List<VocabularyEntry> entries(LanguageSection section) {
    return [...(_entries[section] ?? const [])];
  }

  static List<Flashcard> buildDeck(LanguageSection section, {int count = 10}) {
    final source = _entries[section] ?? const [];
    final deck = <Flashcard>[];
    final random = Random();

    final pool = List<VocabularyEntry>.from(source);
    pool.shuffle(random);

    for (final entry in pool.take(count)) {
      deck.add(
        Flashcard(
          frontTitle: entry.english,
          frontSubtitle: section.label,
          backTitle: entry.translation,
          backExplanation: 'English: ${entry.english}\n${section.label}: ${entry.translation}',
          isConcept: true,
        ),
      );
    }

    return deck;
  }

  static List<String> suggestions(LanguageSection section, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return const [];
    }

    final matches = <String>[];
    for (final entry in _entries[section] ?? const []) {
      final englishWord = entry.english.toLowerCase();
      if (englishWord.startsWith(normalized) || englishWord.contains(normalized)) {
        matches.add(entry.english);
      }
    }

    matches.sort((a, b) {
      final scoreA = _rankSuggestion(a, normalized);
      final scoreB = _rankSuggestion(b, normalized);
      if (scoreA != scoreB) {
        return scoreA.compareTo(scoreB);
      }
      return a.compareTo(b);
    });

    return matches.take(8).toList();
  }

  static int _rankSuggestion(String word, String query) {
    final normalizedWord = word.toLowerCase();
    if (normalizedWord == query) {
      return 0;
    }

    final commonPriority = {
      'hello': 1,
      'goodbye': 2,
      'thank you': 3,
      'please': 4,
      'water': 5,
      'food': 6,
      'house': 7,
      'friend': 8,
      'family': 9,
      'language': 10,
    };

    final priority = commonPriority[normalizedWord] ?? 100;
    if (normalizedWord.startsWith(query)) {
      return priority;
    }

    return priority + 1000;
  }

  static VocabularyEntry? findByEnglish(String english, LanguageSection section) {
    final normalized = english.trim().toLowerCase();
    for (final entry in _entries[section] ?? const []) {
      if (entry.english.toLowerCase() == normalized) {
        return entry;
      }
    }
    return null;
  }
}

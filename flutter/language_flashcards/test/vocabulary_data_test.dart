import 'package:flutter_test/flutter_test.dart';
import 'package:language_flashcards/data/vocabulary_data.dart';
import 'package:language_flashcards/models/vocabulary_entry.dart';

void main() {
  group('VocabularyRepository', () {
    test('russian section contains many English words', () {
      final words = VocabularyRepository.entries(LanguageSection.russian);

      expect(words.length, greaterThan(25));
      expect(words.any((entry) => entry.english == 'hello'), isTrue);
    });

    test('spanish section contains many English words', () {
      final words = VocabularyRepository.entries(LanguageSection.spanish);

      expect(words.length, greaterThan(25));
      expect(words.any((entry) => entry.english == 'apple'), isTrue);
    });

    test('italian section contains many English words', () {
      final words = VocabularyRepository.entries(LanguageSection.italian);

      expect(words.length, greaterThan(25));
      expect(words.any((entry) => entry.english == 'hello'), isTrue);
      expect(words.any((entry) => entry.english == 'apple'), isTrue);
    });

    test('autocomplete suggestions match the typed English word', () {
      final suggestions = VocabularyRepository.suggestions(LanguageSection.russian, 'h');

      expect(suggestions, isNotEmpty);
      expect(suggestions.first, 'hello');
    });

    test('lookup is case-insensitive', () {
      final entry = VocabularyRepository.findByEnglish('HELLO', LanguageSection.russian);

      expect(entry, isNotNull);
      expect(entry!.translation, 'привет');

      final italianEntry = VocabularyRepository.findByEnglish('HELLO', LanguageSection.italian);
      expect(italianEntry, isNotNull);
      expect(italianEntry!.translation, 'ciao');
    });

    test('buildDeck creates a random ten-card flashcard set', () {
      final deck = VocabularyRepository.buildDeck(LanguageSection.spanish, count: 10);

      expect(deck.length, 10);
      expect(deck.every((card) => card.frontTitle.isNotEmpty), isTrue);
      expect(deck.every((card) => card.backTitle.isNotEmpty), isTrue);

      final italianDeck = VocabularyRepository.buildDeck(LanguageSection.italian, count: 10);
      expect(italianDeck.length, 10);
      expect(italianDeck.every((card) => card.frontTitle.isNotEmpty), isTrue);
      expect(italianDeck.every((card) => card.backTitle.isNotEmpty), isTrue);
    });
  });
}

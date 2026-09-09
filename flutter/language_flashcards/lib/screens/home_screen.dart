import 'package:flutter/material.dart';

import '../data/vocabulary_data.dart';
import '../models/flashcard.dart';
import '../models/vocabulary_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LanguageSection? _selectedLanguage;
  List<Flashcard> _deck = [];
  int _currentIndex = 0;
  bool _cardFlipped = false;

  void _startDeck(LanguageSection section) {
    final deck = VocabularyRepository.buildDeck(section, count: 10);
    setState(() {
      _selectedLanguage = section;
      _deck = deck;
      _currentIndex = 0;
      _cardFlipped = false;
    });
  }

  void _nextCard() {
    if (_currentIndex < _deck.length - 1) {
      setState(() {
        _currentIndex += 1;
        _cardFlipped = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex -= 1;
        _cardFlipped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedLanguage == null) {
      return _buildLanguagePicker();
    }

    final card = _deck[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_selectedLanguage!.label} Flashcards'),
        centerTitle: true,
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => setState(() => _selectedLanguage = null),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                '${_currentIndex + 1} / ${_deck.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _cardFlipped = !_cardFlipped),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _cardFlipped
                        ? _FlashcardFace(
                            key: const ValueKey('back'),
                            title: card.backTitle,
                            subtitle: _selectedLanguage == LanguageSection.russian
                                ? 'Russian'
                                : 'Spanish',
                            description: card.backExplanation,
                            accent: _selectedLanguage == LanguageSection.russian
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF0EA5E9),
                          )
                        : _FlashcardFace(
                            key: const ValueKey('front'),
                            title: card.frontTitle,
                            subtitle: 'English',
                            description: 'Tap to flip',
                            accent: const Color(0xFF111827),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousCard,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _nextCard,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguagePicker() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Flashcards'),
        centerTitle: true,
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a language',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Start a fresh deck of 10 random words and flip each card to learn the translation.',
                style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
              ),
              const SizedBox(height: 32),
              _LanguageTile(
                title: 'Russian',
                subtitle: 'English → Russian',
                color: const Color(0xFF7C3AED),
                onTap: () => _startDeck(LanguageSection.russian),
              ),
              const SizedBox(height: 18),
              _LanguageTile(
                title: 'Spanish',
                subtitle: 'English → Spanish',
                color: const Color(0xFF0EA5E9),
                onTap: () => _startDeck(LanguageSection.spanish),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F0F172A),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashcardFace extends StatelessWidget {
  const _FlashcardFace({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withAlpha(30),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}

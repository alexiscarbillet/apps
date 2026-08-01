import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'cheatsheet_screen.dart';
import 'flashcard_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String category;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const CategorySelectionScreen({
    super.key,
    required this.category,
    required this.description,
    required this.icon,
    required this.gradient,
  });

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? selectedLearningPath;

  final List<Map<String, dynamic>> learningPaths = [
    {
      'key': 'concept',
      'title': 'Concept Explorer',
      'subtitle': 'Learn through summaries, notes, and examples.',
      'icon': Icons.menu_book_rounded,
    },
    {
      'key': 'recall',
      'title': 'Recall Booster',
      'subtitle': 'Practice with flashcards and memory prompts.',
      'icon': Icons.style_rounded,
    },
    {
      'key': 'quiz',
      'title': 'Quiz Challenge',
      'subtitle': 'Test your knowledge with a short quiz.',
      'icon': Icons.quiz_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Category Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradient.first.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      widget.category,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Question / Prompt
              Text(
                selectedLearningPath == null
                    ? 'Choose your learning path'
                    : 'Choose how to apply the ${selectedLearningPath == 'concept' ? 'concepts' : selectedLearningPath == 'recall' ? 'recall practice' : 'quiz challenge'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Expanded(
                child: ListView(
                  children: selectedLearningPath == null
                      ? _buildLearningPathCards(context)
                      : _buildFollowUpOptions(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLearningPathCards(BuildContext context) {
    return learningPaths.map((path) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _buildOptionCard(
          context: context,
          title: path['title'] as String,
          subtitle: path['subtitle'] as String,
          cardIcon: path['icon'] as IconData,
          accentColor: widget.gradient.first,
          onTap: () {
            setState(() {
              selectedLearningPath = path['key'] as String;
            });
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildFollowUpOptions(BuildContext context) {
    final List<Widget> options = [];

    if (selectedLearningPath == 'concept') {
      options.addAll([
        _buildOptionCard(
          context: context,
          title: 'Read Cheatsheet',
          subtitle: 'Study summaries, bullets, and code examples.',
          cardIcon: Icons.menu_book_rounded,
          accentColor: widget.gradient.first,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheatsheetScreen(
                  category: widget.category,
                  gradient: widget.gradient,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context: context,
          title: 'Review Flashcards',
          subtitle: 'Reinforce concepts with quick flashcard review.',
          cardIcon: Icons.style_rounded,
          accentColor: Color.lerp(widget.gradient.first, widget.gradient.last, 0.5) ?? widget.gradient.first,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardScreen(
                  category: widget.category,
                  gradient: widget.gradient,
                ),
              ),
            );
          },
        ),
      ]);
    } else if (selectedLearningPath == 'recall') {
      options.addAll([
        _buildOptionCard(
          context: context,
          title: 'Flashcards',
          subtitle: 'Practice memory recall with interactive cards.',
          cardIcon: Icons.style_rounded,
          accentColor: Color.lerp(widget.gradient.first, widget.gradient.last, 0.5) ?? widget.gradient.first,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardScreen(
                  category: widget.category,
                  gradient: widget.gradient,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context: context,
          title: 'Quick Quiz',
          subtitle: 'Check retention with a short quiz.',
          cardIcon: Icons.quiz_rounded,
          accentColor: widget.gradient.last,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(category: widget.category),
              ),
            );
          },
        ),
      ]);
    } else if (selectedLearningPath == 'quiz') {
      options.addAll([
        _buildOptionCard(
          context: context,
          title: 'Practice Quiz',
          subtitle: 'Answer a randomized set of questions.',
          cardIcon: Icons.quiz_rounded,
          accentColor: widget.gradient.last,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(category: widget.category),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context: context,
          title: 'Flashcards',
          subtitle: 'Warm up with quick concept review before the quiz.',
          cardIcon: Icons.style_rounded,
          accentColor: Color.lerp(widget.gradient.first, widget.gradient.last, 0.5) ?? widget.gradient.first,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardScreen(
                  category: widget.category,
                  gradient: widget.gradient,
                ),
              ),
            );
          },
        ),
      ]);
      if (widget.category == 'GCP') {
        options.add(const SizedBox(height: 16));
        options.add(
          _buildOptionCard(
            context: context,
            title: 'GenAI Leader Certification',
            subtitle: 'Specialized questions for the GCP Generative AI Leader exam.',
            cardIcon: Icons.verified_user_rounded,
            accentColor: const Color(0xFF8B5CF6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(category: 'GCP GenAI Leader'),
                ),
              );
            },
          ),
        );
      }
    }

    options.add(const SizedBox(height: 24));
    options.add(
      _buildOptionCard(
        context: context,
        title: 'Choose a different path',
        subtitle: 'Go back and try another learning style.',
        cardIcon: Icons.swap_horiz_rounded,
        accentColor: Colors.white,
        onTap: () {
          setState(() {
            selectedLearningPath = null;
          });
        },
      ),
    );

    return options;
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData cardIcon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon space with circle container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                cardIcon,
                color: accentColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

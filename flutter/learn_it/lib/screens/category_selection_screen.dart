import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'cheatsheet_screen.dart';
import 'flashcard_screen.dart';
import 'decision_tree_screen.dart';

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
  void _navigateToCheatsheet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheatsheetScreen(
          category: widget.category,
          gradient: widget.gradient,
        ),
      ),
    );
  }

  void _navigateToFlashcards(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardScreen(
          category: widget.category,
          gradient: widget.gradient,
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(category: widget.category),
      ),
    );
  }

  void _navigateToDecisionTree(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DecisionTreeScreen(
          category: widget.category,
          gradient: widget.gradient,
        ),
      ),
    );
  }

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
              
              const Text(
                'How do you want to learn?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildOptionCard(
                      context: context,
                      title: 'Cheatsheet',
                      subtitle: 'Review summaries and key concepts.',
                      cardIcon: Icons.menu_book_rounded,
                      accentColor: widget.gradient.first,
                      onTap: () => _navigateToCheatsheet(context),
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      context: context,
                      title: 'Flashcards',
                      subtitle: 'Practice with active recall cards.',
                      cardIcon: Icons.style_rounded,
                      accentColor: Color.lerp(widget.gradient.first, widget.gradient.last, 0.5) ?? widget.gradient.first,
                      onTap: () => _navigateToFlashcards(context),
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      context: context,
                      title: 'Quiz',
                      subtitle: 'Test your knowledge with a short quiz.',
                      cardIcon: Icons.quiz_rounded,
                      accentColor: widget.gradient.last,
                      onTap: () => _navigateToQuiz(context),
                    ),
                    if (widget.category == 'GCP') ...[
                      const SizedBox(height: 16),
                      _buildOptionCard(
                        context: context,
                        title: 'Certification Prep',
                        subtitle: 'Practice the GCP Generative AI Leader certification questions.',
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
                    ],
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      context: context,
                      title: 'Decision Tree',
                      subtitle: 'Choose the best learning path for this category.',
                      cardIcon: Icons.account_tree_rounded,
                      accentColor: Colors.greenAccent,
                      onTap: () => _navigateToDecisionTree(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

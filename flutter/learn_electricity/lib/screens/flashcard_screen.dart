import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cheatsheet_data.dart';
import '../data/quiz_data.dart';
import '../models/flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  final String category;
  final List<Color> gradient;

  const FlashcardScreen({
    super.key,
    required this.category,
    required this.gradient,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  String? _selectedMode; // 'concepts', 'questions', 'all', or null
  List<Flashcard> _deck = [];
  List<bool> _cardFlippedStates = [];
  
  // Track user assessment for each card: true = Got It, false = Study Again, null = Unanswered
  List<bool?> _cardAssessments = [];
  
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSession(String mode, {List<Flashcard>? customDeck}) {
    List<Flashcard> cards = [];
    if (customDeck != null) {
      cards = List<Flashcard>.from(customDeck);
    } else {
      cards = _buildFlashcards(widget.category, mode);
    }

    // Shuffle the deck for learning
    cards.shuffle();

    setState(() {
      _selectedMode = mode;
      _deck = cards;
      _cardFlippedStates = List.generate(cards.length, (_) => false);
      _cardAssessments = List.generate(cards.length, (_) => null);
      _currentIndex = 0;
      _isFinished = false;
    });
    
    // Reset page controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  List<Flashcard> _buildFlashcards(String category, String mode) {
    List<Flashcard> cards = [];
    
    // 1. Extract concepts from Cheatsheet
    if (mode == 'concepts' || mode == 'all') {
      final cheatsheet = cheatsheetData[category];
      if (cheatsheet != null) {
        for (final sec in cheatsheet.sections) {
          cards.add(Flashcard(
            frontTitle: sec.title,
            frontSubtitle: 'CONCEPT STUDY',
            backTitle: sec.title,
            backExplanation: sec.content,
            bulletPoints: sec.bulletPoints,
            codeSnippet: sec.codeSnippet,
            isConcept: true,
          ));
        }
      }
    }
    
    // 2. Extract questions from Quiz Data
    if (mode == 'questions' || mode == 'all') {
      final questions = quizData[category];
      if (questions != null) {
        for (final q in questions) {
          final correctOption = q.options[q.correctAnswerIndex];
          cards.add(Flashcard(
            frontTitle: q.questionText,
            frontSubtitle: 'PRACTICE QUESTION',
            backTitle: 'Answer: $correctOption',
            backExplanation: q.explanation,
            isConcept: false,
          ));
        }
      }
    }
    
    return cards;
  }

  void _assessCard(bool gotIt) {
    setState(() {
      _cardAssessments[_currentIndex] = gotIt;
    });

    // Short delay to let the card flip back if needed or directly slide
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_currentIndex < _deck.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        setState(() {
          _isFinished = true;
        });
      }
    });
  }

  void _restartWeakCards() {
    // Collect all cards that were marked "Study Again" (false) or were skipped (null)
    List<Flashcard> weakCards = [];
    for (int i = 0; i < _deck.length; i++) {
      if (_cardAssessments[i] != true) {
        weakCards.add(_deck[i]);
      }
    }

    if (weakCards.isEmpty) {
      // If none, restart all
      _startSession(_selectedMode!);
    } else {
      _startSession(_selectedMode!, customDeck: weakCards);
    }
  }

  // Helper to copy code snippets
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
            SizedBox(width: 8),
            Text('Copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () {
            if (_selectedMode != null && !_isFinished) {
              // Return to mode selection
              setState(() {
                _selectedMode = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedMode == null ? 'Study Modes' : '${widget.category} Flashcards',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedMode == null) {
      return _buildModeSelectionView();
    }
    if (_isFinished) {
      return _buildFinishedView();
    }
    return _buildStudyView();
  }

  Widget _buildModeSelectionView() {
    final conceptCount = _buildFlashcards(widget.category, 'concepts').length;
    final questionCount = _buildFlashcards(widget.category, 'questions').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Study Deck',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Active recall and memory retrieval are the best ways to lock in technical concepts.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: ListView(
              children: [
                _buildModeCard(
                  title: 'Study Concepts',
                  subtitle: '$conceptCount Key Concepts',
                  description: 'Review summaries, detailed diagrams, bullet points, and code templates directly from the cheatsheet.',
                  icon: Icons.menu_book_rounded,
                  accentColor: widget.gradient.first,
                  onTap: () => _startSession('concepts'),
                  isEnabled: conceptCount > 0,
                ),
                const SizedBox(height: 20),
                _buildModeCard(
                  title: 'Study Quiz Questions',
                  subtitle: '$questionCount Active Recall Cards',
                  description: 'Test your knowledge using the randomized question pool. Reveal answers and check detailed breakdowns.',
                  icon: Icons.question_answer_rounded,
                  accentColor: widget.gradient.last,
                  onTap: () => _startSession('questions'),
                  isEnabled: questionCount > 0,
                ),
                const SizedBox(height: 20),
                _buildModeCard(
                  title: 'Mixed Mode',
                  subtitle: '${conceptCount + questionCount} Total Cards',
                  description: 'Combine both conceptual overviews and application questions for a fully integrated study session.',
                  icon: Icons.all_inclusive_rounded,
                  accentColor: Color.lerp(widget.gradient.first, widget.gradient.last, 0.5) ?? widget.gradient.first,
                  onTap: () => _startSession('all'),
                  isEnabled: conceptCount > 0 && questionCount > 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B), // Card background
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: 28,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF64748B),
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudyView() {
    if (_deck.isEmpty) {
      return const Center(
        child: Text(
          'No flashcards found for this deck.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final card = _deck[_currentIndex];
    final progress = _currentIndex / _deck.length;
    final gotItCount = _cardAssessments.where((element) => element == true).length;
    final studyAgainCount = _cardAssessments.where((element) => element == false).length;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Top Stats & Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card ${_currentIndex + 1} of ${_deck.length}',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  if (gotItCount > 0) ...[
                    const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('$gotItCount', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 12),
                  ],
                  if (studyAgainCount > 0) ...[
                    const Icon(Icons.replay_circle_filled_rounded, color: Colors.amberAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('$studyAgainCount', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(widget.gradient.first),
              minHeight: 6,
            ),
          ),
          
          // Flashcard Display Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Force navigation via buttons or tap to flip
                itemCount: _deck.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _deck[index];
                  return FlipCard(
                    isFlipped: _cardFlippedStates[index],
                    onTap: (flipped) {
                      setState(() {
                        _cardFlippedStates[index] = flipped;
                      });
                    },
                    front: _buildCardFront(item),
                    back: _buildCardBack(item),
                  );
                },
              ),
            ),
          ),

          // Bottom Buttons Panel
          _buildControlPanel(card),
        ],
      ),
    );
  }

  Widget _buildCardFront(Flashcard card) {
    return Container(
      key: const ValueKey('front'),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.gradient.first.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.gradient.first.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background design/glow
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.gradient.first.withValues(alpha: 0.15),
                    widget.gradient.first.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.gradient.first.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.gradient.first.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    card.frontSubtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: widget.gradient.first,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                
                // Question / Concept Text
                Text(
                  card.frontTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                
                const Spacer(),
                
                // Tap Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      color: widget.gradient.first.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TAP TO REVEAL ANSWER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Flashcard card) {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.gradient.last.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.gradient.last.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background glow
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.gradient.last.withValues(alpha: 0.15),
                    widget.gradient.last.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Subtitle
                    Text(
                      card.isConcept ? 'CONCEPT RECAP' : 'DETAILED ANSWER',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: widget.gradient.last,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Back Title
                    Text(
                      card.backTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: card.isConcept ? Colors.white : Colors.greenAccent,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 8),

                    // Content details
                    Text(
                      card.backExplanation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE2E8F0),
                        height: 1.45,
                      ),
                    ),

                    // Bullet Points
                    if (card.bulletPoints != null && card.bulletPoints!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ...card.bulletPoints!.map((pt) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Icon(Icons.arrow_right_alt_rounded, size: 14, color: widget.gradient.last),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                pt,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],

                    // Code Snippet
                    if (card.codeSnippet != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Snippet Reference:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.copy_rounded, color: Color(0xFF64748B), size: 16),
                            onPressed: () => _copyToClipboard(context, card.codeSnippet!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF090D16),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            card.codeSnippet!,
                            style: const TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 12,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(Flashcard card) {
    final isFlipped = _cardFlippedStates[_currentIndex];

    return Container(
      height: 90,
      margin: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: !isFlipped
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.swap_horizontal_circle_outlined, color: Color(0xFF64748B), size: 28),
                    const SizedBox(height: 4),
                    Text(
                      'Tap Card to Flip',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Study Again Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _assessCard(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D1F29), // Reddish Slate
                            foregroundColor: Colors.orangeAccent,
                            side: const BorderSide(color: Color(0xFF5D2D3E), width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay_rounded),
                              SizedBox(width: 8),
                              Text('Study Again', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Got It Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _assessCard(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF162E2E), // Greenish Slate
                            foregroundColor: Colors.greenAccent,
                            side: const BorderSide(color: Color(0xFF1B4E47), width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded),
                              SizedBox(width: 8),
                              Text('Got It', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFinishedView() {
    final totalCards = _deck.length;
    final gotItCount = _cardAssessments.where((element) => element == true).length;
    final studyAgainCount = totalCards - gotItCount;
    final successRate = totalCards == 0 ? 0.0 : (gotItCount / totalCards);
    final percentage = (successRate * 100).toInt();

    // High performance feedback titles
    String rankTitle = 'Study Session Done!';
    IconData rankIcon = Icons.emoji_events_rounded;
    Color rankColor = const Color(0xFFF59E0B); // Gold

    if (successRate == 1.0) {
      rankTitle = 'Flawless Recall!';
      rankIcon = Icons.workspace_premium_rounded;
    } else if (successRate >= 0.7) {
      rankTitle = 'Great Retention!';
      rankIcon = Icons.thumb_up_alt_rounded;
      rankColor = Colors.greenAccent;
    } else {
      rankTitle = 'Keep Practicing!';
      rankIcon = Icons.menu_book_rounded;
      rankColor = const Color(0xFF94A3B8);
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Celebration Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: rankColor.withValues(alpha: 0.2), width: 2),
            ),
            child: Icon(
              rankIcon,
              color: rankColor,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),

          // Completion Headers
          Text(
            rankTitle,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You completed the deck of $totalCards card${totalCards == 1 ? '' : 's'}.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 36),

          // Progress Circle or Stats Grid
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Percentage ring
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: successRate,
                            strokeWidth: 8,
                            backgroundColor: const Color(0xFF0F172A),
                            valueColor: AlwaysStoppedAnimation<Color>(rankColor),
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Mastery Rate', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                ),

                // Numerical breakdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$gotItCount Got It',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$studyAgainCount To Review',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedMode = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white10),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Modes', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _restartWeakCards,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.gradient.first,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    studyAgainCount > 0 ? 'Review Weak' : 'Study Again',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Exit Flashcards', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool isFlipped;
  final ValueChanged<bool> onTap;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(!widget.isFlipped);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final double value = _animation.value;
          final isBack = value > 0.5;
          final angle = value * pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015) // Perspective 3D
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi), // Unmirror the back text
                    child: widget.back,
                  )
                : widget.front,
          );
        },
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../data/flashcard_data.dart';
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

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  void _nextCard(int total) {
    if (_currentIndex < total - 1) {
      if (!_showFront) _flipCard();
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      if (!_showFront) _flipCard();
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Flashcard>? cards = flashcardData[widget.category];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.category} Flashcards',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: cards == null || cards.isEmpty
          ? const Center(
              child: Text(
                'No flashcards available for this category.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Progress Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Card ${_currentIndex + 1} of ${cards.length}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: widget.gradient.first.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            cards[_currentIndex].isConcept ? 'Concept' : 'Formula / Rule',
                            style: TextStyle(color: widget.gradient.first, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Flip Card
                    Expanded(
                      child: GestureDetector(
                        onTap: _flipCard,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            final angle = _animation.value * pi;
                            final isFront = angle < pi / 2;

                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isFront
                                  ? _buildFrontCard(cards[_currentIndex])
                                  : Transform(
                                      transform: Matrix4.identity()..rotateY(pi),
                                      alignment: Alignment.center,
                                      child: _buildBackCard(cards[_currentIndex]),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _currentIndex > 0 ? _prevCard : null,
                          iconSize: 40,
                          icon: Icon(
                            Icons.arrow_circle_left_rounded,
                            color: _currentIndex > 0 ? widget.gradient.first : Colors.white24,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _flipCard,
                          icon: const Icon(Icons.flip_rounded, color: Colors.white),
                          label: Text(_showFront ? 'Flip to Reveal' : 'Show Question'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: widget.gradient.first.withValues(alpha: 0.4)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _currentIndex < cards.length - 1 ? () => _nextCard(cards.length) : null,
                          iconSize: 40,
                          icon: Icon(
                            Icons.arrow_circle_right_rounded,
                            color: _currentIndex < cards.length - 1 ? widget.gradient.first : Colors.white24,
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

  Widget _buildFrontCard(Flashcard card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: widget.gradient.first.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app_rounded, color: widget.gradient.first, size: 40),
          const SizedBox(height: 24),
          Text(
            card.frontTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            card.frontSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.4),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tap card to flip',
            style: TextStyle(fontSize: 12, color: Colors.white38, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(Flashcard card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.gradient.first.withValues(alpha: 0.4)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.backTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.gradient.first),
            ),
            const SizedBox(height: 10),
            Text(
              card.backExplanation,
              style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
            ),
            if (card.bulletPoints != null && card.bulletPoints!.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...card.bulletPoints!.map(
                (bp) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          bp,
                          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (card.codeSnippet != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    card.codeSnippet!,
                    style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF6EE7B7), fontSize: 11),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

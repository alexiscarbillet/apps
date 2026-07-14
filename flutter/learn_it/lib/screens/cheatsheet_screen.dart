import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cheatsheet_data.dart';
import '../models/cheatsheet.dart';
import 'quiz_screen.dart';

class CheatsheetScreen extends StatefulWidget {
  final String category;
  final List<Color> gradient;

  const CheatsheetScreen({
    super.key,
    required this.category,
    required this.gradient,
  });

  @override
  State<CheatsheetScreen> createState() => _CheatsheetScreenState();
}

class _CheatsheetScreenState extends State<CheatsheetScreen> {
  late Cheatsheet _cheatsheet;
  String _selectedSectionFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Fallback if no cheatsheet data is available for a category
    _cheatsheet = cheatsheetData[widget.category] ?? Cheatsheet(
      category: widget.category,
      summary: 'Learn key concepts and prepare yourself for the ${widget.category} quiz.',
      sections: [],
    );
  }

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
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtered sections
    final displayedSections = _selectedSectionFilter == 'All'
        ? _cheatsheet.sections
        : _cheatsheet.sections.where((s) => s.title == _selectedSectionFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.category} Cheatsheet',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                _cheatsheet.summary,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            // Horizontal Navigation / Filter Pills
            if (_cheatsheet.sections.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _cheatsheet.sections.length + 1,
                  itemBuilder: (context, index) {
                    final sectionName = index == 0 ? 'All' : _cheatsheet.sections[index - 1].title;
                    final isSelected = _selectedSectionFilter == sectionName;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(sectionName),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedSectionFilter = sectionName;
                            });
                          }
                        },
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        selectedColor: widget.gradient.first,
                        backgroundColor: const Color(0xFF1E293B),
                        checkmarkColor: Colors.white,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Sections List
            Expanded(
              child: displayedSections.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book_rounded, size: 64, color: Colors.white.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          const Text(
                            'No concepts compiled for this section yet.',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      itemCount: displayedSections.length + 1,
                      itemBuilder: (context, index) {
                        // At the very end of the list, add the Quiz CTA card
                        if (index == displayedSections.length) {
                          return _buildQuizCTACard();
                        }

                        final section = displayedSections[index];
                        return _buildSectionCard(section, index + 1);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(CheatsheetSection section, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of Section Card
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Number Index Container
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.05),
          ),

          // Content body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Summary Paragraph
                Text(
                  section.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE2E8F0),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Bullet Points
                ...section.bulletPoints.map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Icon(
                              Icons.arrow_right_alt_rounded,
                              size: 16,
                              color: widget.gradient.first,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                // Code Snippet Block
                if (section.codeSnippet != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Quick Reference / Example:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Terminal Header Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Small dot indicator decorations
                              Row(
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                                ],
                              ),
                              // Copy Button
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  color: Color(0xFF64748B),
                                  size: 18,
                                ),
                                hoverColor: Colors.white10,
                                splashRadius: 16,
                                onPressed: () => _copyToClipboard(context, section.codeSnippet!),
                              ),
                            ],
                          ),
                        ),
                        // Code Content
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              section.codeSnippet!,
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 13,
                                color: Color(0xFF38BDF8), // Code cyan color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCTACard() {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 32.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.gradient.first.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ready to test yourself?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Challenge your understanding of these concepts with our interactive quiz. Track your score and unlock detailed feedback.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(category: widget.category),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: widget.gradient.first,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Practice Quiz',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.play_arrow_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

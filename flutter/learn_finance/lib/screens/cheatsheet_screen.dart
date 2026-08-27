import 'package:flutter/material.dart';
import '../data/cheatsheet_data.dart';
import '../models/cheatsheet.dart';

class CheatsheetScreen extends StatelessWidget {
  final String category;
  final List<Color> gradient;

  const CheatsheetScreen({
    super.key,
    required this.category,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final Cheatsheet? cheatsheet = cheatsheetData[category];

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
          '$category Reference',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: cheatsheet == null
          ? const Center(
              child: Text(
                'No cheatsheet content available yet.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  // Summary Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.first.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Executive Summary',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cheatsheet.summary,
                          style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sections
                  ...cheatsheet.sections.map((section) => _buildSectionCard(context, section)),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionCard(BuildContext context, CheatsheetSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            section.content,
            style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), height: 1.4),
          ),
          if (section.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...section.bulletPoints.map(
              (bp) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 16)),
                    Expanded(
                      child: Text(
                        bp,
                        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (section.codeSnippet != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  section.codeSnippet!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF6EE7B7),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

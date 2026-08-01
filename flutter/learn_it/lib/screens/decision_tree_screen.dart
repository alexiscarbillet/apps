import 'package:flutter/material.dart';
import '../data/decision_trees/decision_tree_data.dart';
import '../models/decision_tree.dart';
import 'cheatsheet_screen.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';

class DecisionTreeScreen extends StatefulWidget {
  final String category;
  final List<Color> gradient;

  const DecisionTreeScreen({
    super.key,
    required this.category,
    required this.gradient,
  });

  @override
  State<DecisionTreeScreen> createState() => _DecisionTreeScreenState();
}

class _DecisionTreeScreenState extends State<DecisionTreeScreen> {
  late final List<DecisionTreeNode> _nodes;
  String _currentNodeId = 'start';

  @override
  void initState() {
    super.initState();
    _nodes = decisionTreeData[widget.category] ?? [];
  }

  DecisionTreeNode? get _currentNode {
    if (_nodes.isEmpty) return null;
    return _nodes.firstWhere(
      (node) => node.id == _currentNodeId,
      orElse: () => _nodes.first,
    );
  }

  void _selectBranch(DecisionTreeBranch branch) {
    if (branch.action != null) {
      _launchAction(branch.action!);
      return;
    }

    setState(() {
      _currentNodeId = branch.nextNodeId;
    });
  }

  void _launchAction(String action) {
    Widget screen;

    switch (action) {
      case 'cheatsheet':
        screen = CheatsheetScreen(category: widget.category, gradient: widget.gradient);
        break;
      case 'flashcards':
        screen = FlashcardScreen(category: widget.category, gradient: widget.gradient);
        break;
      case 'quiz':
      default:
        screen = QuizScreen(category: widget.category);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = _currentNode;
    if (node == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Decision Tree')),
        body: const Center(child: Text('No decision tree available for this category.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Decision Tree'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Decision Tree',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.gradient.first,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      node.prompt,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: node.branches.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final branch = node.branches[index];
                    return _buildBranchCard(branch);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchCard(DecisionTreeBranch branch) {
    return InkWell(
      onTap: () => _selectBranch(branch),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                branch.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

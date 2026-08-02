import 'package:flutter/material.dart';
import '../data/decision_trees/decision_tree_data.dart';
import '../models/decision_tree.dart';

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
    setState(() {
      _currentNodeId = branch.nextNodeId;
    });
  }

  DecisionTreeNode? _findNode(String nodeId) {
    for (final node in _nodes) {
      if (node.id == nodeId) {
        return node;
      }
    }
    return null;
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
                      'Tree view',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: widget.gradient.first,
                      ),
                    ),
                    const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildNodeCard(node, isCurrent: true),
                    if (node.branches.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Text(
                          'This branch ends here.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ...node.branches.map((branch) {
                        final childNode = _findNode(branch.nextNodeId);
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
                          child: _buildBranchCard(branch, childNode),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodeCard(DecisionTreeNode node, {required bool isCurrent}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: isCurrent ? 0.12 : 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCurrent ? Icons.account_tree_rounded : Icons.subdirectory_arrow_right_rounded,
                color: isCurrent ? widget.gradient.first : const Color(0xFF94A3B8),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isCurrent ? 'Current node' : 'Next node',
                style: TextStyle(
                  color: isCurrent ? widget.gradient.first : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            node.prompt,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(DecisionTreeBranch branch, DecisionTreeNode? childNode) {
    return InkWell(
      onTap: () => _selectBranch(branch),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.turn_right_rounded, color: Color(0xFF94A3B8), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    branch.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            if (childNode != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 26.0),
                child: _buildNodeCard(childNode, isCurrent: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

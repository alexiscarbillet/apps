import 'package:flutter/material.dart';
import '../data/decision_tree_data.dart';
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
  String _currentNodeId = 'root';
  final List<String> _history = ['root'];

  void _selectBranch(DecisionTreeBranch branch) {
    if (branch.nextNodeId.isNotEmpty) {
      setState(() {
        _currentNodeId = branch.nextNodeId;
        _history.add(branch.nextNodeId);
      });
    }
  }

  void _resetTree() {
    setState(() {
      _currentNodeId = 'root';
      _history.clear();
      _history.add('root');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, DecisionTreeNode>? tree = decisionTreeData[widget.category];
    final DecisionTreeNode? currentNode = tree?[_currentNodeId];

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
          '${widget.category} Decision Tree',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70),
            onPressed: _resetTree,
            tooltip: 'Restart Tree',
          ),
        ],
      ),
      body: currentNode == null
          ? const Center(
              child: Text(
                'No decision tree available for this category.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Decision Prompt Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: widget.gradient.first.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradient.first.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_tree_rounded, color: widget.gradient.first, size: 24),
                              const SizedBox(width: 10),
                              const Text(
                                'Guided Financial Decision',
                                style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentNode.prompt,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Options / Branches
                    if (currentNode.branches.isNotEmpty) ...[
                      const Text(
                        'Select an option based on your situation:',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentNode.branches.length,
                          itemBuilder: (context, index) {
                            final branch = currentNode.branches[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: InkWell(
                                onTap: () => _selectBranch(branch),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          branch.label,
                                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: widget.gradient.first, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      // Terminal Node Action
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065F46),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF10B981)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Color(0xFF6EE7B7), size: 28),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Recommended Path Determined!',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _resetTree,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Start New Decision Path', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

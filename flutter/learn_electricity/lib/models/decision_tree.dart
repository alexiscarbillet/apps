class DecisionTreeNode {
  final String id;
  final String prompt;
  final List<DecisionTreeBranch> branches;

  DecisionTreeNode({
    required this.id,
    required this.prompt,
    required this.branches,
  });
}

class DecisionTreeBranch {
  final String label;
  final String nextNodeId;
  final String? action;

  DecisionTreeBranch({
    required this.label,
    required this.nextNodeId,
    this.action,
  });
}

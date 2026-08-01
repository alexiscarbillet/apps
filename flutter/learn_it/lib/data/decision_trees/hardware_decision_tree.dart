import '../../models/decision_tree.dart';

final hardwareDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What hardware topic would you like to study?',
    branches: [
      DecisionTreeBranch(label: 'CPU & memory', nextNodeId: 'cpu'),
      DecisionTreeBranch(label: 'Storage & I/O', nextNodeId: 'storage'),
      DecisionTreeBranch(label: 'Power & circuits', nextNodeId: 'power'),
    ],
  ),
  DecisionTreeNode(
    id: 'cpu',
    prompt: 'Review processor architecture, caches, and memory systems?',
    branches: [
      DecisionTreeBranch(label: 'Study concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'storage',
    prompt: 'Learn about disks, filesystems, and throughput?',
    branches: [
      DecisionTreeBranch(label: 'Review notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test with flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'power',
    prompt: 'Study voltage, current, and circuit fundamentals?',
    branches: [
      DecisionTreeBranch(label: 'Open cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Use flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Hardware cheatsheet for detailed learning.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Hardware flashcards for active recall practice.',
    branches: [],
  ),
];

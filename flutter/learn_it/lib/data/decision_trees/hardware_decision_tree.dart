import '../../models/decision_tree.dart';

final hardwareDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which hardware component or system do you want to study?',
    branches: [
      DecisionTreeBranch(label: 'CPU and memory', nextNodeId: 'cpu'),
      DecisionTreeBranch(label: 'Storage and I/O', nextNodeId: 'storage'),
      DecisionTreeBranch(label: 'Power and circuit parts', nextNodeId: 'power'),
    ],
  ),
  DecisionTreeNode(
    id: 'cpu',
    prompt: 'Review processor architecture, caches, and memory systems?',
    branches: [
      DecisionTreeBranch(label: 'Study the hardware cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice hardware recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'storage',
    prompt: 'Learn about disks, filesystems, and throughput?',
    branches: [
      DecisionTreeBranch(label: 'Review storage notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test with storage flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'power',
    prompt: 'Study voltage, current, and circuit fundamentals?',
    branches: [
      DecisionTreeBranch(label: 'Open the hardware cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Use component flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
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

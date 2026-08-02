import '../../models/decision_tree.dart';

final networkDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which networking topic do you want to explore?',
    branches: [
      DecisionTreeBranch(label: 'OSI and protocols', nextNodeId: 'protocols'),
      DecisionTreeBranch(label: 'Routing and switching', nextNodeId: 'routing'),
      DecisionTreeBranch(label: 'Security and services', nextNodeId: 'security'),
    ],
  ),
  DecisionTreeNode(
    id: 'protocols',
    prompt: 'Study network layers, TCP/IP, and packet flow?',
    branches: [
      DecisionTreeBranch(label: 'Review network protocol concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice protocol recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'routing',
    prompt: 'Learn routing, switching, and subnetting?',
    branches: [
      DecisionTreeBranch(label: 'Open the routing cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try routing quiz questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'security',
    prompt: 'Review VPNs, DNS, and firewall behavior?',
    branches: [
      DecisionTreeBranch(label: 'Use network security flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Take a network security quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Network cheatsheet to review the right details.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Network flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Network quiz to validate your knowledge.',
    branches: [],
  ),
];

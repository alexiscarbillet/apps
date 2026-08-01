import '../../models/decision_tree.dart';

final networkDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What networking path do you want?',
    branches: [
      DecisionTreeBranch(label: 'OSI & protocols', nextNodeId: 'protocols'),
      DecisionTreeBranch(label: 'Routing & switching', nextNodeId: 'routing'),
      DecisionTreeBranch(label: 'Security & services', nextNodeId: 'security'),
    ],
  ),
  DecisionTreeNode(
    id: 'protocols',
    prompt: 'Study network layers, TCP/IP, and packet flow?',
    branches: [
      DecisionTreeBranch(label: 'Review concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'routing',
    prompt: 'Learn routing, switching, and subnetting?',
    branches: [
      DecisionTreeBranch(label: 'Open cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try quiz questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'security',
    prompt: 'Review VPNs, DNS, and firewall behavior?',
    branches: [
      DecisionTreeBranch(label: 'Use flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Take a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Network cheatsheet to review details.',
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

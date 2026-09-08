import '../../models/decision_tree.dart';

final dockerDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which Docker topic would you like to explore?',
    branches: [
      DecisionTreeBranch(label: 'Images and containers', nextNodeId: 'images'),
      DecisionTreeBranch(label: 'Networking and storage', nextNodeId: 'networking'),
      DecisionTreeBranch(label: 'Compose and operations', nextNodeId: 'ops'),
    ],
  ),
  DecisionTreeNode(
    id: 'images',
    prompt: 'Review image layers, build steps, and container runtime basics?',
    branches: [
      DecisionTreeBranch(label: 'Open the Docker cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice Docker flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'networking',
    prompt: 'Study Docker networking, volumes, and port publishing?',
    branches: [
      DecisionTreeBranch(label: 'Review Docker networking notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Take a Docker quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'ops',
    prompt: 'Ready to review Compose, security, and troubleshooting practices?',
    branches: [
      DecisionTreeBranch(label: 'Use the Docker workflow guide', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Quiz yourself on Docker basics', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Docker cheatsheet for guided review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Docker flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Docker quiz to validate your knowledge.',
    branches: [],
  ),
];

import '../../models/decision_tree.dart';

final linuxDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which Linux concept or command area do you want to explore?',
    branches: [
      DecisionTreeBranch(label: 'System and filesystem concepts', nextNodeId: 'system'),
      DecisionTreeBranch(label: 'Commands and tools', nextNodeId: 'tools'),
      DecisionTreeBranch(label: 'Administration and permissions', nextNodeId: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'system',
    prompt: 'Review Linux internals, filesystems, and process behavior?',
    branches: [
      DecisionTreeBranch(label: 'Open the Linux cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice Linux recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'tools',
    prompt: 'Learn using commands, /proc, and shell examples?',
    branches: [
      DecisionTreeBranch(label: 'Review command examples', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice Linux flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'quiz',
    prompt: 'Ready for a Linux admin knowledge quiz?',
    branches: [
      DecisionTreeBranch(label: 'Take the Linux quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review Linux notes first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Linux cheatsheet for guided review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Linux flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Linux quiz to validate your knowledge.',
    branches: [],
  ),
];

import '../../models/decision_tree.dart';

final linuxDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What Linux learning approach do you prefer?',
    branches: [
      DecisionTreeBranch(label: 'System concepts', nextNodeId: 'system'),
      DecisionTreeBranch(label: 'Commands & tools', nextNodeId: 'tools'),
      DecisionTreeBranch(label: 'Administration quiz', nextNodeId: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'system',
    prompt: 'Review Linux internals, filesystems, and process behavior?',
    branches: [
      DecisionTreeBranch(label: 'Open cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'tools',
    prompt: 'Learn using commands, /proc, and shell examples?',
    branches: [
      DecisionTreeBranch(label: 'Review examples', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'quiz',
    prompt: 'Ready for a Linux quiz to check your admin skills?',
    branches: [
      DecisionTreeBranch(label: 'Take the quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review notes first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
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

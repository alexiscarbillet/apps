import '../../models/decision_tree.dart';

final pythonDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which Python concept or coding topic do you want to learn?',
    branches: [
      DecisionTreeBranch(label: 'Language fundamentals', nextNodeId: 'fundamentals'),
      DecisionTreeBranch(label: 'Code patterns and data structures', nextNodeId: 'patterns'),
      DecisionTreeBranch(label: 'Problem solving', nextNodeId: 'problems'),
    ],
  ),
  DecisionTreeNode(
    id: 'fundamentals',
    prompt: 'Review syntax, data types, and structures?',
    branches: [
      DecisionTreeBranch(label: 'Study Python notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice Python recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'patterns',
    prompt: 'Learn through common Python idioms and examples?',
    branches: [
      DecisionTreeBranch(label: 'Open the Python cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try Python quiz questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'problems',
    prompt: 'Ready to solve problems and test your skills?',
    branches: [
      DecisionTreeBranch(label: 'Take a Python quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review Python concepts first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Python cheatsheet for detailed review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Python flashcards for recall practice.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Python quiz to validate your knowledge.',
    branches: [],
  ),
];

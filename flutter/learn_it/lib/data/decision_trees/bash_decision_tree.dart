import '../../models/decision_tree.dart';

final bashDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'How do you want to learn Bash?',
    branches: [
      DecisionTreeBranch(label: 'Shell basics', nextNodeId: 'basics'),
      DecisionTreeBranch(label: 'Scripting practice', nextNodeId: 'scripting'),
      DecisionTreeBranch(label: 'Command recall', nextNodeId: 'recall'),
    ],
  ),
  DecisionTreeNode(
    id: 'basics',
    prompt: 'Review command syntax, variables, and I/O in Bash?',
    branches: [
      DecisionTreeBranch(label: 'Study the cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'scripting',
    prompt: 'Learn scripting patterns and command substitution?',
    branches: [
      DecisionTreeBranch(label: 'Review scripts and examples', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try quiz questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'recall',
    prompt: 'Want quick memory practice with Bash commands?',
    branches: [
      DecisionTreeBranch(label: 'Flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Bash cheatsheet for command and script review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Bash flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open a Bash quiz to test your skills.',
    branches: [],
  ),
];

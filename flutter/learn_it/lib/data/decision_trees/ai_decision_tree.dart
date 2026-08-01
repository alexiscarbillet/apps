import '../../models/decision_tree.dart';

final aiDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What AI learning route do you want?',
    branches: [
      DecisionTreeBranch(label: 'Concepts & theory', nextNodeId: 'concepts'),
      DecisionTreeBranch(label: 'Model practice', nextNodeId: 'practice'),
      DecisionTreeBranch(label: 'Quick quiz', nextNodeId: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'concepts',
    prompt: 'Study attention, transformers, and model building concepts?',
    branches: [
      DecisionTreeBranch(label: 'Yes, review concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Then test my recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'practice',
    prompt: 'Learn by solving model and architecture questions?',
    branches: [
      DecisionTreeBranch(label: 'Yes, use flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Yes, take a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'quiz',
    prompt: 'Ready for a knowledge check?',
    branches: [
      DecisionTreeBranch(label: 'Take the quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review concepts first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the AI cheatsheet and learn the underlying theories.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open AI flashcards for active recall and definitions.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the AI quiz to test your knowledge.',
    branches: [],
  ),
];

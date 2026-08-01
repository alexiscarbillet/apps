import '../../models/decision_tree.dart';

final electricityDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What electricity topic would you like to learn?',
    branches: [
      DecisionTreeBranch(label: 'Basic circuits', nextNodeId: 'circuits'),
      DecisionTreeBranch(label: 'AC vs DC', nextNodeId: 'acdc'),
      DecisionTreeBranch(label: 'Power systems', nextNodeId: 'power'),
    ],
  ),
  DecisionTreeNode(
    id: 'circuits',
    prompt: 'Study Ohm’s law, resistors, and circuit behavior?',
    branches: [
      DecisionTreeBranch(label: 'Review concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'acdc',
    prompt: 'Learn alternating current and direct current fundamentals?',
    branches: [
      DecisionTreeBranch(label: 'Open cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'power',
    prompt: 'Study voltage, current, and power conversion?',
    branches: [
      DecisionTreeBranch(label: 'Review notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test with a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Electricity cheatsheet for detailed review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Electricity flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Electricity quiz to reinforce concepts.',
    branches: [],
  ),
];

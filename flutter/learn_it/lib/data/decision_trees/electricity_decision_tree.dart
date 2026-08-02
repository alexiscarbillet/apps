import '../../models/decision_tree.dart';

final electricityDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which circuit or power concept do you want to study?',
    branches: [
      DecisionTreeBranch(label: 'Circuit basics', nextNodeId: 'circuits'),
      DecisionTreeBranch(label: 'AC and DC behavior', nextNodeId: 'acdc'),
      DecisionTreeBranch(label: 'Power and safety', nextNodeId: 'power'),
    ],
  ),
  DecisionTreeNode(
    id: 'circuits',
    prompt: 'Study Ohm’s law, resistors, and basic circuit behavior?',
    branches: [
      DecisionTreeBranch(label: 'Review circuit concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice circuit recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'acdc',
    prompt: 'Learn how alternating current and direct current differ?',
    branches: [
      DecisionTreeBranch(label: 'Open the AC/DC cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try AC/DC flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'power',
    prompt: 'Study voltage, current, power conversion, and electrical safety?',
    branches: [
      DecisionTreeBranch(label: 'Review power notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test yourself with a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Electricity cheatsheet for detailed circuit and power review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Electricity flashcards to reinforce core electrical concepts.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Electricity quiz to reinforce concepts and safety knowledge.',
    branches: [],
  ),
];

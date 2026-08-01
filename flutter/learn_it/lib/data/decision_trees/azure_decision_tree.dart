import '../../models/decision_tree.dart';

final azureDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What Azure path would you like to follow?',
    branches: [
      DecisionTreeBranch(label: 'Cloud architecture', nextNodeId: 'architecture'),
      DecisionTreeBranch(label: 'Tools and services', nextNodeId: 'services'),
      DecisionTreeBranch(label: 'Interview prep', nextNodeId: 'interview'),
    ],
  ),
  DecisionTreeNode(
    id: 'architecture',
    prompt: 'Review Azure networking, identity, and compute architecture?',
    branches: [
      DecisionTreeBranch(label: 'Yes, study concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Then quiz myself', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'services',
    prompt: 'Learn Azure through service examples and platform items?',
    branches: [
      DecisionTreeBranch(label: 'Yes, practice flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Yes, test with questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'interview',
    prompt: 'Prepare for Azure knowledge checks and real questions?',
    branches: [
      DecisionTreeBranch(label: 'Take a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review guided notes first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Azure cheatsheet for guided learning.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open the Azure flashcards for spaced recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Azure quiz to validate your knowledge.',
    branches: [],
  ),
];

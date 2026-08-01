import '../../models/decision_tree.dart';

final awsDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What kind of AWS learning path do you want?',
    branches: [
      DecisionTreeBranch(label: 'Core AWS Concepts', nextNodeId: 'core'),
      DecisionTreeBranch(label: 'Hands-on Tools', nextNodeId: 'tools'),
      DecisionTreeBranch(label: 'Exam Practice', nextNodeId: 'exam'),
    ],
  ),
  DecisionTreeNode(
    id: 'core',
    prompt: 'Focus on core AWS services and architecture?',
    branches: [
      DecisionTreeBranch(label: 'Yes, learn concepts', nextNodeId: 'end_concepts', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try memory recall', nextNodeId: 'end_recall', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'tools',
    prompt: 'Want to learn through practical CLI and service examples?',
    branches: [
      DecisionTreeBranch(label: 'Yes, practice commands', nextNodeId: 'end_practice', action: 'flashcards'),
      DecisionTreeBranch(label: 'Test with questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'exam',
    prompt: 'Prep for AWS certification style questions?',
    branches: [
      DecisionTreeBranch(label: 'Yes, take a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review fundamentals first', nextNodeId: 'end_concepts', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_concepts',
    prompt: 'Open the cheatsheet to review the selected AWS path.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_recall',
    prompt: 'Open flashcards to reinforce AWS concepts by recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_practice',
    prompt: 'Use a practical review path with AWS examples and flashcards.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Take a quiz to test your AWS knowledge.',
    branches: [],
  ),
];

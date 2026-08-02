import '../../models/decision_tree.dart';

final awsDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which AWS service or concept do you want to learn?',
    branches: [
      DecisionTreeBranch(label: 'Core AWS services', nextNodeId: 'core'),
      DecisionTreeBranch(label: 'Hands-on AWS tools', nextNodeId: 'tools'),
      DecisionTreeBranch(label: 'Exam-style knowledge', nextNodeId: 'exam'),
    ],
  ),
  DecisionTreeNode(
    id: 'core',
    prompt: 'Focus on EC2, S3, IAM, or broader cloud architecture?',
    branches: [
      DecisionTreeBranch(label: 'Review the AWS service cheatsheet', nextNodeId: 'end_concepts', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Reinforce it with AWS flashcards', nextNodeId: 'end_recall', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'tools',
    prompt: 'Want to learn through CLI commands and practical AWS examples?',
    branches: [
      DecisionTreeBranch(label: 'Practice AWS command recall', nextNodeId: 'end_practice', action: 'flashcards'),
      DecisionTreeBranch(label: 'Test your AWS knowledge', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'exam',
    prompt: 'Preparing for AWS certification-style questions?',
    branches: [
      DecisionTreeBranch(label: 'Take an AWS quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review AWS fundamentals first', nextNodeId: 'end_concepts', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_concepts',
    prompt: 'Open the AWS cheatsheet to review the selected services and concepts.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_recall',
    prompt: 'Open AWS flashcards to reinforce service concepts by recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_practice',
    prompt: 'Use AWS flashcards for practical service and CLI review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Take an AWS quiz to test your service and architecture knowledge.',
    branches: [],
  ),
];

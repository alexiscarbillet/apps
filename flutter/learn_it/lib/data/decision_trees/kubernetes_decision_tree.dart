import '../../models/decision_tree.dart';

final kubernetesDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What Kubernetes learning route do you want?',
    branches: [
      DecisionTreeBranch(label: 'Core concepts', nextNodeId: 'concepts'),
      DecisionTreeBranch(label: 'Deployment practice', nextNodeId: 'deployment'),
      DecisionTreeBranch(label: 'Troubleshooting quiz', nextNodeId: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'concepts',
    prompt: 'Learn about pods, services, and scheduling?',
    branches: [
      DecisionTreeBranch(label: 'Review concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Reinforce with flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'deployment',
    prompt: 'Study deployments, configs, and service networking?',
    branches: [
      DecisionTreeBranch(label: 'Use flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Try a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'quiz',
    prompt: 'Ready for a Kubernetes knowledge check?',
    branches: [
      DecisionTreeBranch(label: 'Take the quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review notes first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Kubernetes cheatsheet for detailed review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Kubernetes flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Kubernetes quiz to test your understanding.',
    branches: [],
  ),
];

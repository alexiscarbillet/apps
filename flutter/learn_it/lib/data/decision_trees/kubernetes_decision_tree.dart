import '../../models/decision_tree.dart';

final kubernetesDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which Kubernetes concept or workload do you want to learn?',
    branches: [
      DecisionTreeBranch(label: 'Pods and services', nextNodeId: 'concepts'),
      DecisionTreeBranch(label: 'Deployments and networking', nextNodeId: 'deployment'),
      DecisionTreeBranch(label: 'Troubleshooting and scaling', nextNodeId: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'concepts',
    prompt: 'Learn about pods, services, and scheduling?',
    branches: [
      DecisionTreeBranch(label: 'Review Kubernetes concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Reinforce with Kubernetes flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'deployment',
    prompt: 'Study deployments, configs, and service networking?',
    branches: [
      DecisionTreeBranch(label: 'Use deployment flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Try a Kubernetes quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'quiz',
    prompt: 'Ready for a Kubernetes troubleshooting knowledge check?',
    branches: [
      DecisionTreeBranch(label: 'Take the quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review the Kubernetes notes first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
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

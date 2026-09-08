import '../../models/decision_tree.dart';

final cybersecurityDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which cybersecurity domain do you want to study?',
    branches: [
      DecisionTreeBranch(label: 'Identity and access', nextNodeId: 'identity'),
      DecisionTreeBranch(label: 'Network and endpoint defense', nextNodeId: 'network'),
      DecisionTreeBranch(label: 'Application security and incidents', nextNodeId: 'application'),
    ],
  ),
  DecisionTreeNode(
    id: 'identity',
    prompt: 'Review IAM, MFA, and least-privilege controls?',
    branches: [
      DecisionTreeBranch(label: 'Open the cybersecurity cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice cybersecurity flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'network',
    prompt: 'Study firewalls, TLS, patching, and endpoint security?',
    branches: [
      DecisionTreeBranch(label: 'Review network security notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Take a cybersecurity quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'application',
    prompt: 'Explore secure development, incident response, and resilience?',
    branches: [
      DecisionTreeBranch(label: 'Review secure coding guidance', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Check your knowledge with a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the Cybersecurity cheatsheet for guided review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open Cybersecurity flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the Cybersecurity quiz to validate your knowledge.',
    branches: [],
  ),
];

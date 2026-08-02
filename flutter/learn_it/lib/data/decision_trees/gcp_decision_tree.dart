import '../../models/decision_tree.dart';

final gcpDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which GCP product or concept do you want to explore?',
    branches: [
      DecisionTreeBranch(label: 'Product and service basics', nextNodeId: 'products'),
      DecisionTreeBranch(label: 'Data and AI services', nextNodeId: 'data'),
      DecisionTreeBranch(label: 'Networking and security', nextNodeId: 'networking'),
    ],
  ),
  DecisionTreeNode(
    id: 'products',
    prompt: 'Want to learn about Compute Engine, App Engine, or Kubernetes Engine products?',
    branches: [
      DecisionTreeBranch(label: 'Review the GCP product cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test your recall with GCP flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'data',
    prompt: 'Want to study BigQuery, Pub/Sub, or data analytics services?',
    branches: [
      DecisionTreeBranch(label: 'Use the GCP service cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Try a GCP knowledge quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'networking',
    prompt: 'Review IAM, VPCs, and networking concepts for GCP?',
    branches: [
      DecisionTreeBranch(label: 'Open the networking cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice GCP security flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the GCP cheatsheet for structured product and service review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open the GCP flashcards to reinforce product knowledge.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the GCP quiz for certification-style practice.',
    branches: [],
  ),
];

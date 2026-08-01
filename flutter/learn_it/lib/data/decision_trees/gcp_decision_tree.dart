import '../../models/decision_tree.dart';

final gcpDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which GCP learning path fits your goal?',
    branches: [
      DecisionTreeBranch(label: 'Platform concepts', nextNodeId: 'concepts'),
      DecisionTreeBranch(label: 'Cloud tools and services', nextNodeId: 'tools'),
      DecisionTreeBranch(label: 'Certification prep', nextNodeId: 'cert'),
    ],
  ),
  DecisionTreeNode(
    id: 'concepts',
    prompt: 'Study GCP services and architecture at a conceptual level?',
    branches: [
      DecisionTreeBranch(label: 'Yes, review concepts', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Build recall with examples', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'tools',
    prompt: 'Want hands-on practice with GCP features and commands?',
    branches: [
      DecisionTreeBranch(label: 'Yes, flashcard practice', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Yes, try quiz questions', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'cert',
    prompt: 'Prepare specifically for GCP certification style questions?',
    branches: [
      DecisionTreeBranch(label: 'Yes, take a quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review the cheatsheet first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the GCP cheatsheet for structured concept review.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open the GCP flashcards for active recall.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the GCP quiz for certification-style practice.',
    branches: [],
  ),
];

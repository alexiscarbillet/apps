import '../../models/decision_tree.dart';

final aiDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which AI concept or model topic do you want to learn?',
    branches: [
      DecisionTreeBranch(label: 'Core AI concepts', nextNodeId: 'concepts'),
      DecisionTreeBranch(label: 'Model and training ideas', nextNodeId: 'practice'),
      DecisionTreeBranch(label: 'Prompt and reasoning topics', nextNodeId: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'concepts',
    prompt: 'Study transformers, embeddings, or generative AI concepts?',
    branches: [
      DecisionTreeBranch(label: 'Review the AI concept cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test your AI recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'practice',
    prompt: 'Learn through model behavior, training, and architecture questions?',
    branches: [
      DecisionTreeBranch(label: 'Use AI flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
      DecisionTreeBranch(label: 'Take an AI quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'quiz',
    prompt: 'Ready for a practical AI knowledge check?',
    branches: [
      DecisionTreeBranch(label: 'Take the quiz', nextNodeId: 'end_quiz', action: 'quiz'),
      DecisionTreeBranch(label: 'Review AI concepts first', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the AI cheatsheet to learn the underlying theories and terminology.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open AI flashcards for active recall and model definitions.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the AI quiz to test your knowledge.',
    branches: [],
  ),
];

import '../../models/decision_tree.dart';

final sqlDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'What SQL learning goal do you have?',
    branches: [
      DecisionTreeBranch(label: 'Query fundamentals', nextNodeId: 'queries'),
      DecisionTreeBranch(label: 'Schema design', nextNodeId: 'schema'),
      DecisionTreeBranch(label: 'Optimization tips', nextNodeId: 'optimization'),
    ],
  ),
  DecisionTreeNode(
    id: 'queries',
    prompt: 'Review SELECT, JOINs, GROUP BY, and filtering?',
    branches: [
      DecisionTreeBranch(label: 'Open cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'schema',
    prompt: 'Learn database design, normalization, and indexes?',
    branches: [
      DecisionTreeBranch(label: 'Study notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test with quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'optimization',
    prompt: 'Improve query speed and database performance?',
    branches: [
      DecisionTreeBranch(label: 'Review tips', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Reinforce with flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'end_cheatsheet',
    prompt: 'Open the SQL cheatsheet for practical guidance.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_flashcards',
    prompt: 'Open SQL flashcards for memory practice.',
    branches: [],
  ),
  DecisionTreeNode(
    id: 'end_quiz',
    prompt: 'Open the SQL quiz to validate your knowledge.',
    branches: [],
  ),
];

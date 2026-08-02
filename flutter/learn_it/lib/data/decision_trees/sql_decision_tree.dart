import '../../models/decision_tree.dart';

final sqlDecisionTree = <DecisionTreeNode>[
  DecisionTreeNode(
    id: 'start',
    prompt: 'Which SQL topic do you want to learn?',
    branches: [
      DecisionTreeBranch(label: 'Query fundamentals', nextNodeId: 'queries'),
      DecisionTreeBranch(label: 'Schema and design', nextNodeId: 'schema'),
      DecisionTreeBranch(label: 'Performance and optimization', nextNodeId: 'optimization'),
    ],
  ),
  DecisionTreeNode(
    id: 'queries',
    prompt: 'Review SELECT, JOINs, GROUP BY, and filtering?',
    branches: [
      DecisionTreeBranch(label: 'Open the SQL cheatsheet', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Practice SQL recall', nextNodeId: 'end_flashcards', action: 'flashcards'),
    ],
  ),
  DecisionTreeNode(
    id: 'schema',
    prompt: 'Learn database design, normalization, and indexes?',
    branches: [
      DecisionTreeBranch(label: 'Study schema notes', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Test with a SQL quiz', nextNodeId: 'end_quiz', action: 'quiz'),
    ],
  ),
  DecisionTreeNode(
    id: 'optimization',
    prompt: 'Improve query speed and database performance?',
    branches: [
      DecisionTreeBranch(label: 'Review optimization tips', nextNodeId: 'end_cheatsheet', action: 'cheatsheet'),
      DecisionTreeBranch(label: 'Reinforce with SQL flashcards', nextNodeId: 'end_flashcards', action: 'flashcards'),
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

import '../../models/decision_tree.dart';

final Map<String, DecisionTreeNode> capitalAllocationNodes = {
  'root': DecisionTreeNode(
    id: 'root',
    prompt: 'Do you have high-interest debt (e.g. Credit Cards > 7-8% APR) or an empty emergency fund?',
    branches: [
      DecisionTreeBranch(
        label: 'Yes, I have high-interest debt or zero cash buffer',
        nextNodeId: 'node_debt',
      ),
      DecisionTreeBranch(
        label: 'No, high-interest debt is paid off & emergency cash is ready',
        nextNodeId: 'node_investing_timeline',
      ),
    ],
  ),
  'node_debt': DecisionTreeNode(
    id: 'node_debt',
    prompt: 'Pay off high-interest debt immediately! Paying off 18% APR credit debt yields a guaranteed, tax-free 18% return that no stock market strategy can beat.',
    branches: [
      DecisionTreeBranch(
        label: 'Finished paying high-interest debt',
        nextNodeId: 'node_investing_timeline',
      ),
    ],
  ),
  'node_investing_timeline': DecisionTreeNode(
    id: 'node_investing_timeline',
    prompt: 'What is your time horizon for the capital you want to deploy?',
    branches: [
      DecisionTreeBranch(
        label: 'Short Term (< 3 Years)',
        nextNodeId: 'node_short_term',
      ),
      DecisionTreeBranch(
        label: 'Long Term (5+ Years)',
        nextNodeId: 'node_long_term',
      ),
    ],
  ),
  'node_short_term': DecisionTreeNode(
    id: 'node_short_term',
    prompt: 'Keep funds in Money Market Funds, High-Yield Savings Accounts (HYSA), or Short-Term Treasury Bills to protect principal capital from equity market volatility.',
    branches: [],
  ),
  'node_long_term': DecisionTreeNode(
    id: 'node_long_term',
    prompt: 'Deploy into broad index funds (VTI / VOO) or high-conviction value equities using Dollar-Cost Averaging.',
    branches: [],
  ),
};

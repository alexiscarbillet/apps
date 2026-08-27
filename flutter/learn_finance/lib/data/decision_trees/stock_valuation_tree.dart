import '../../models/decision_tree.dart';

final Map<String, DecisionTreeNode> stockValuationNodes = {
  'root': DecisionTreeNode(
    id: 'root',
    prompt: 'Does the company generate positive Free Cash Flow (FCF) and operating profits?',
    branches: [
      DecisionTreeBranch(
        label: 'Yes, strong positive Free Cash Flow',
        nextNodeId: 'node_fcf_positive',
      ),
      DecisionTreeBranch(
        label: 'No, un-profitable speculative growth',
        nextNodeId: 'node_unprofitable',
      ),
    ],
  ),
  'node_unprofitable': DecisionTreeNode(
    id: 'node_unprofitable',
    prompt: 'Caution: Value using Price/Sales or EV/Sales ratios and check cash burn rate runway. High-risk allocation (< 2% portfolio size).',
    branches: [],
  ),
  'node_fcf_positive': DecisionTreeNode(
    id: 'node_fcf_positive',
    prompt: 'Is current Stock Price below estimated DCF Intrinsic Value with at least a 20% Margin of Safety?',
    branches: [
      DecisionTreeBranch(
        label: 'Yes, trading below Intrinsic Value',
        nextNodeId: 'node_buy_candidate',
      ),
      DecisionTreeBranch(
        label: 'No, stock is trading at premium valuation',
        nextNodeId: 'node_watchlist',
      ),
    ],
  ),
  'node_buy_candidate': DecisionTreeNode(
    id: 'node_buy_candidate',
    prompt: 'Strong Value Accumulation Candidate! Initiate tranced purchases using DCA.',
    branches: [],
  ),
  'node_watchlist': DecisionTreeNode(
    id: 'node_watchlist',
    prompt: 'Place on Watchlist or sell cash-secured puts below current market price to collect premium while waiting for a pullback.',
    branches: [],
  ),
};

import '../../models/decision_tree.dart';
import 'decision_trees/capital_allocation_tree.dart';
import 'decision_trees/stock_valuation_tree.dart';

final Map<String, Map<String, DecisionTreeNode>> decisionTreeData = {
  'Investing Fundamentals': capitalAllocationNodes,
  'Stock Valuation': stockValuationNodes,
  'Portfolio Management': capitalAllocationNodes,
  'Macroeconomics': capitalAllocationNodes,
  'Personal Wealth': capitalAllocationNodes,
  'Options & Derivatives': stockValuationNodes,
  'Financial Coding': capitalAllocationNodes,
  'Risk Management': capitalAllocationNodes,
};

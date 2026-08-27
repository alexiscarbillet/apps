import '../models/cheatsheet.dart';
import 'cheatsheets/investing_fundamentals_cs.dart';
import 'cheatsheets/stock_valuation_cs.dart';
import 'cheatsheets/portfolio_management_cs.dart';
import 'cheatsheets/macroeconomics_cs.dart';
import 'cheatsheets/personal_wealth_cs.dart';
import 'cheatsheets/options_derivatives_cs.dart';
import 'cheatsheets/financial_coding_cs.dart';
import 'cheatsheets/risk_management_cs.dart';

final Map<String, Cheatsheet> cheatsheetData = {
  'Investing Fundamentals': investingFundamentalsCheatsheet,
  'Stock Valuation': stockValuationCheatsheet,
  'Portfolio Management': portfolioManagementCheatsheet,
  'Macroeconomics': macroeconomicsCheatsheet,
  'Personal Wealth': personalWealthCheatsheet,
  'Options & Derivatives': optionsDerivativesCheatsheet,
  'Financial Coding': financialCodingCheatsheet,
  'Risk Management': riskManagementCheatsheet,
};

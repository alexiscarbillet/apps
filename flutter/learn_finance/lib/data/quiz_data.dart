import '../models/question.dart';
import 'questions/investing_fundamentals_questions.dart';
import 'questions/stock_valuation_questions.dart';
import 'questions/portfolio_management_questions.dart';
import 'questions/macroeconomics_questions.dart';
import 'questions/personal_wealth_questions.dart';
import 'questions/options_derivatives_questions.dart';
import 'questions/financial_coding_questions.dart';
import 'questions/risk_management_questions.dart';

final Map<String, List<Question>> quizData = {
  'Investing Fundamentals': investingFundamentalsQuestions,
  'Stock Valuation': stockValuationQuestions,
  'Portfolio Management': portfolioManagementQuestions,
  'Macroeconomics': macroeconomicsQuestions,
  'Personal Wealth': personalWealthQuestions,
  'Options & Derivatives': optionsDerivativesQuestions,
  'Financial Coding': financialCodingQuestions,
  'Risk Management': riskManagementQuestions,
};

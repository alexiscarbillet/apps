import '../models/flashcard.dart';
import 'flashcards/investing_fundamentals_fc.dart';
import 'flashcards/stock_valuation_fc.dart';
import 'flashcards/portfolio_management_fc.dart';
import 'flashcards/macroeconomics_fc.dart';
import 'flashcards/personal_wealth_fc.dart';
import 'flashcards/options_derivatives_fc.dart';
import 'flashcards/financial_coding_fc.dart';
import 'flashcards/risk_management_fc.dart';

final Map<String, List<Flashcard>> flashcardData = {
  'Investing Fundamentals': investingFundamentalsFlashcards,
  'Stock Valuation': stockValuationFlashcards,
  'Portfolio Management': portfolioManagementFlashcards,
  'Macroeconomics': macroeconomicsFlashcards,
  'Personal Wealth': personalWealthFlashcards,
  'Options & Derivatives': optionsDerivativesFlashcards,
  'Financial Coding': financialCodingFlashcards,
  'Risk Management': riskManagementFlashcards,
};

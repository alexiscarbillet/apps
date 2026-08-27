import '../../models/flashcard.dart';

final List<Flashcard> portfolioManagementFlashcards = [
  Flashcard(
    frontTitle: 'Sharpe Ratio',
    frontSubtitle: 'Risk-adjusted return indicator',
    backTitle: 'Measuring Sharpe Ratio',
    backExplanation: 'Quantifies how much excess return you receive for the extra volatility endured holding a risky asset.',
    bulletPoints: [
      'Sharpe = (R_p - R_f) / Sigma_p.',
      'Sharpe > 1.0 is considered Good, > 2.0 Very Good, > 3.0 Excellent.',
      'Allows objective comparison between high-return high-risk vs steady moderate-return portfolios.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'Beta (Volatility Ratio)',
    frontSubtitle: 'Systematic market sensitivity',
    backTitle: 'Interpreting Stock Beta',
    backExplanation: 'Measures a stock\'s price movement sensitivity relative to a benchmark index (e.g. S&P 500 = 1.0).',
    bulletPoints: [
      'Beta = 1.0: Moves in sync with market.',
      'Beta > 1.0: Higher volatility (e.g., Tech/Growth stocks with Beta 1.4).',
      'Beta < 1.0: Defensive/Low volatility (e.g., Utilities/Consumer Staples with Beta 0.6).',
    ],
    isConcept: false,
  ),
];

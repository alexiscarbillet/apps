import '../../models/flashcard.dart';

final List<Flashcard> investingFundamentalsFlashcards = [
  Flashcard(
    frontTitle: 'Asset Allocation',
    frontSubtitle: 'The primary driver of portfolio return and volatility',
    backTitle: 'What is Asset Allocation?',
    backExplanation: 'Dividing an investment portfolio among different asset categories (stocks, bonds, cash, real estate, commodities).',
    bulletPoints: [
      'Determines over 90% of portfolio return variability according to empirical studies.',
      'Balances growth, income, and capital preservation based on risk tolerance and timeline.',
      'Requires periodic rebalancing to avoid asset drift.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'Expense Ratio (ER)',
    frontSubtitle: 'Annual fund management fee percentage',
    backTitle: 'Why Low Expense Ratios Matter',
    backExplanation: 'A small difference in fee percentage compounds into massive drag over multi-decade holding periods.',
    bulletPoints: [
      'Example: 0.03% ER (VTI) vs 1.00% ER (Active Mutual Fund).',
      'On a \$100,000 portfolio over 30 years at 8% return, a 1% ER costs over \$200,000 in lost growth.',
      'Passively managed index funds minimize operational friction.',
    ],
    isConcept: false,
  ),
  Flashcard(
    frontTitle: 'Dollar-Cost Averaging (DCA)',
    frontSubtitle: 'Systematic investment discipline',
    backTitle: 'How DCA Works',
    backExplanation: 'Investing a fixed dollar amount at regular intervals (e.g. \$500/month) regardless of market share price.',
    bulletPoints: [
      'Buys more shares when prices drop, fewer when prices rise.',
      'Removes emotional market-timing paralysis.',
      'Smooths average cost basis over market cycles.',
    ],
    isConcept: true,
  ),
];

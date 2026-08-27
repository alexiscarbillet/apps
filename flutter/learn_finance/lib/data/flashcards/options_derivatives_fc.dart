import '../../models/flashcard.dart';

final List<Flashcard> optionsDerivativesFlashcards = [
  Flashcard(
    frontTitle: 'Option Greeks Cheat Sheet',
    frontSubtitle: 'Delta, Gamma, Theta, Vega',
    backTitle: 'Option Price Sensitivity Drivers',
    backExplanation: 'The 4 primary Greeks govern how option contract prices react to market variables.',
    bulletPoints: [
      'Delta: Price sensitivity to \$1 move in underlying stock.',
      'Gamma: Rate of change of Delta.',
      'Theta: Daily time decay loss.',
      'Vega: Price sensitivity to 1% change in Implied Volatility (IV).',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'The Wheel Strategy',
    frontSubtitle: 'Options cash-flow strategy',
    backTitle: '2-Step Option Income Cycle',
    backExplanation: 'Selling Cash-Secured Puts to buy stock at a discount, then selling Covered Calls until assigned cash.',
    bulletPoints: [
      'Step 1: Sell OTM Put -> Collect Premium. (If assigned stock, move to Step 2).',
      'Step 2: Sell OTM Call against stock -> Collect Premium. (If assigned cash, restart Step 1).',
      'Generates steady yield on liquid high-conviction stocks.',
    ],
    isConcept: true,
  ),
];

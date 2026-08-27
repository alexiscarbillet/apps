import '../../models/flashcard.dart';

final List<Flashcard> riskManagementFlashcards = [
  Flashcard(
    frontTitle: 'Risk of Ruin & Kelly Criterion',
    frontSubtitle: 'Mathematical optimal position sizing',
    backTitle: 'Kelly Criterion Formula',
    backExplanation: 'Calculates optimal fraction of capital to wager on a trade with positive expected value.',
    bulletPoints: [
      'Kelly % = W - (1 - W) / R (where W = win probability, R = win/loss ratio).',
      'Fractional Kelly (e.g., Half-Kelly) is widely used in practice to avoid over-betting drawdown.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'Loss Aversion Bias',
    frontSubtitle: 'Behavioral finance trap',
    backTitle: 'Prospect Theory Insight',
    backExplanation: 'Pain of losing \$1,000 is emotionally felt 2x more strongly than joy of gaining \$1,000.',
    bulletPoints: [
      'Leads to holding losing positions too long (hoping to break even).',
      'Leads to selling winners too quickly (locking in micro gains).',
      'Remedied by algorithmic trading rules & automated stop losses.',
    ],
    isConcept: true,
  ),
];

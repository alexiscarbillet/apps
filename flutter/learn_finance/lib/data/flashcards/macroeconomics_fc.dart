import '../../models/flashcard.dart';

final List<Flashcard> macroeconomicsFlashcards = [
  Flashcard(
    frontTitle: 'Yield Curve Inversion',
    frontSubtitle: 'Recession warning signal',
    backTitle: 'Why Inversion Happens',
    backExplanation: 'Occurs when 2-year Treasury yields rise higher than 10-year Treasury yields.',
    bulletPoints: [
      'Indicates bond market expects future rate cuts due to economic contraction.',
      'Has preceded every US recession in the modern era with a 12-24 month lag.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'WACC (Cost of Capital)',
    frontSubtitle: 'Minimum hurdle rate for investments',
    backTitle: 'Weighted Average Cost of Capital',
    backExplanation: 'The average expected return a firm must yield to satisfy both debt holders and equity investors.',
    bulletPoints: [
      'WACC = (E/V * Cost of Equity) + (D/V * Cost of Debt * (1 - Tax Rate)).',
      'Used as discount rate in DCF models.',
    ],
    isConcept: true,
  ),
];

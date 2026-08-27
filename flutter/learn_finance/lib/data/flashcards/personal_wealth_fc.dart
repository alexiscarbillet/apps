import '../../models/flashcard.dart';

final List<Flashcard> personalWealthFlashcards = [
  Flashcard(
    frontTitle: 'Rule of 72',
    frontSubtitle: 'Doubling time mental math rule',
    backTitle: 'Compound Doubling Estimation',
    backExplanation: 'Years to Double = 72 / Annual Interest Rate.',
    bulletPoints: [
      'At 6% return: 72 / 6 = 12 years to double.',
      'At 10% return: 72 / 10 = 7.2 years to double.',
      'Highlighting the dramatic compounding impact of small yield increases.',
    ],
    isConcept: false,
  ),
  Flashcard(
    frontTitle: '4% Safe Withdrawal Rate',
    frontSubtitle: 'FIRE (Financial Independence) target metric',
    backTitle: 'The 25x Annual Expenses Rule',
    backExplanation: 'Withdrawing 4% of initial nest egg adjusted for inflation annually historically survives 30+ year retirement cycles.',
    bulletPoints: [
      'Target Portfolio = Annual Expenses * 25.',
      'Example: \$60,000 yearly spend * 25 = \$1,500,000 target nest egg.',
    ],
    isConcept: true,
  ),
];

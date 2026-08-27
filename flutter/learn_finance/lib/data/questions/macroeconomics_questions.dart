import '../../models/question.dart';

final List<Question> macroeconomicsQuestions = [
  Question(
    questionText: 'What does an Inverted Yield Curve (where short-term yields exceed long-term yields) historically signal?',
    options: [
      'An impending economic recession within 12 to 24 months',
      'Immediate rapid economic hypergrowth',
      'Zero inflation for the next decade',
      'An automatic spike in stock market price-to-earnings ratios',
    ],
    correctAnswerIndex: 0,
    explanation: 'Yield curve inversion occurs when investors expect central bank rate cuts due to anticipated economic slowdown or recession.',
  ),
  Question(
    questionText: 'How do interest rate increases by Central Banks generally impact bond prices?',
    options: [
      'Bond prices rise proportionally.',
      'Bond prices fall because existing bonds yield less than newly issued higher-rate bonds.',
      'Bond prices are completely unaffected by central bank rates.',
      'Bond yields drop to zero immediately.',
    ],
    correctAnswerIndex: 1,
    explanation: 'Bond prices and interest rates move in inverse directions. When rates rise, existing lower-yielding bonds lose secondary market value.',
  ),
  Question(
    questionText: 'What is the Weighted Average Cost of Capital (WACC)?',
    options: [
      'The average tax rate paid by a corporation across global jurisdictions',
      'The blended average cost of equity and debt financing required by capital providers',
      'The interest rate charged by commercial banks for credit cards',
      'The dividend payout ratio per share of common stock',
    ],
    correctAnswerIndex: 1,
    explanation: 'WACC reflects the minimum hurdle rate a enterprise must earn on existing assets to satisfy both debt holders and equity shareholders.',
  ),
  Question(
    questionText: 'Which scenario represents Share Buybacks adding long-term shareholder value?',
    options: [
      'When the company buys back shares when the stock is deeply undervalued relative to intrinsic value.',
      'When shares are repurchased at all-time highs using high-interest debt.',
      'When buybacks are used solely to offset massive management dilution regardless of valuation.',
      'When the company has negative operating cash flow.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Repurchasing shares below intrinsic value increases per-share ownership and future free cash flow per remaining share.',
  ),
];

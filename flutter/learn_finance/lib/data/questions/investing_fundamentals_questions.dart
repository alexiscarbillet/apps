import '../../models/question.dart';

final List<Question> investingFundamentalsQuestions = [
  Question(
    questionText: 'What is the primary trade-off depicted by the Capital Market Line in modern investment theory?',
    options: [
      'Liquidity vs. Tax efficiency',
      'Expected Return vs. Total Risk (Standard Deviation)',
      'Dividend Yield vs. Stock Buyback Rate',
      'Market Capitalization vs. P/E Ratio',
    ],
    correctAnswerIndex: 1,
    explanation: 'The Risk-Return trade-off states that higher potential return generally requires accepting higher uncertainty or volatility (Standard Deviation).',
  ),
  Question(
    questionText: 'Which asset class historically acts as a hedge against unexpected inflation due to its intrinsic asset value?',
    options: [
      'Long-term Treasury Bonds',
      'Corporate Paper',
      'Real Estate (REITs) and Commodities',
      'High-yield Junk Bonds',
    ],
    correctAnswerIndex: 2,
    explanation: 'Real assets like real estate (with cash flows tied to inflation via rent increases) and physical commodities tend to maintain real purchasing power during inflationary periods.',
  ),
  Question(
    questionText: 'What key metric measures an ETF\'s annual operational cost expressed as a percentage of total fund assets?',
    options: [
      'Turnover Ratio',
      'Expense Ratio',
      'Tracking Error',
      'Bid-Ask Spread',
    ],
    correctAnswerIndex: 1,
    explanation: 'The Expense Ratio directly reduces investor returns annually to cover fund management, administration, and marketing.',
  ),
  Question(
    questionText: 'Why is Dollar-Cost Averaging (DCA) effective for retail investors?',
    options: [
      'It guarantees buying at the absolute market bottom every time.',
      'It eliminates market risk completely.',
      'It reduces emotional biases by automatically purchasing more shares when prices drop and fewer when prices rise.',
      'It eliminates capital gains taxes on dividend distributions.',
    ],
    correctAnswerIndex: 2,
    explanation: 'DCA enforces systematic discipline, smoothing out purchase costs over time and avoiding market-timing anxiety.',
  ),
  Question(
    questionText: 'What distinguishes an Index Fund from an Actively Managed Mutual Fund?',
    options: [
      'Index funds aim to track a market benchmark at low cost, whereas active funds try to outperform a benchmark with higher fees.',
      'Index funds can only invest in government bonds.',
      'Active funds never charge management fees unless returns exceed 10%.',
      'Index funds trade only once every 5 years.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Index funds passively replicate benchmarks (like S&P 500), keeping turnover and management fees extremely low compared to active managers.',
  ),
];

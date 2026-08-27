import '../../models/question.dart';

final List<Question> portfolioManagementQuestions = [
  Question(
    questionText: 'What does the Sharpe Ratio measure?',
    options: [
      'Total net income generated per employee',
      'Excess return per unit of total risk (Standard Deviation)',
      'Dividend yield relative to corporate debt',
      'The average daily trading volume of a stock',
    ],
    correctAnswerIndex: 1,
    explanation: 'Sharpe Ratio = (Portfolio Return - Risk-Free Rate) / Portfolio Standard Deviation. Higher Sharpe ratios indicate superior risk-adjusted performance.',
  ),
  Question(
    questionText: 'What does a Beta of 1.5 indicate for a stock relative to the overall market (e.g. S&P 500)?',
    options: [
      'The stock is 50% less volatile than the benchmark.',
      'The stock is expected to be 50% more volatile than the market benchmark.',
      'The stock pays a 1.5% fixed dividend yield.',
      'The stock has negative correlation with the market index.',
    ],
    correctAnswerIndex: 1,
    explanation: 'Beta measures systematic market risk. Beta > 1 means amplified volatility compared to market index movements.',
  ),
  Question(
    questionText: 'According to Modern Portfolio Theory (MPT), what portfolio offers the highest expected return for a given level of risk?',
    options: [
      'An allocation contained on the Efficient Frontier',
      'A portfolio with 100% exposure to high-beta tech stocks',
      'A portfolio holding exclusively 30-year Treasury bonds',
      'An equal-weighted portfolio of penny stocks',
    ],
    correctAnswerIndex: 0,
    explanation: 'The Efficient Frontier represents optimal portfolios offering maximum expected return for a defined level of risk through asset correlation diversification.',
  ),
  Question(
    questionText: 'What is Alpha in portfolio performance measurement?',
    options: [
      'The maximum drawdown suffered during a recession.',
      'The risk-free rate of return set by central banks.',
      'The excess return of an investment relative to the return of a benchmark index.',
      'The total asset under management (AUM) of a hedge fund.',
    ],
    correctAnswerIndex: 2,
    explanation: 'Positive Alpha indicates that a manager or strategy outperformed the risk-adjusted benchmark expected return.',
  ),
  Question(
    questionText: 'Why is systematic rebalancing beneficial over long holding horizons?',
    options: [
      'It enforces buying low (underperforming assets) and selling high (overperforming assets) to maintain risk tolerance.',
      'It guarantees zero tax liability on all sales.',
      'It eliminates the need to hold cash reserves.',
      'It doubles compound interest automatically every 3 years.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Rebalancing resets portfolio weights to target risk profiles, systematically trimming winner assets and accumulating undervalued allocations.',
  ),
];

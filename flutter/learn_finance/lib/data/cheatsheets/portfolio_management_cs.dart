import '../../models/cheatsheet.dart';

final Cheatsheet portfolioManagementCheatsheet = Cheatsheet(
  category: 'Portfolio Management',
  summary: 'Modern Portfolio Theory, Sharpe/Sortino ratios, Beta, Alpha, and tactical asset rebalancing.',
  sections: [
    CheatsheetSection(
      title: 'Modern Portfolio Theory (MPT) & Diversification',
      content: 'MPT proves that combining uncorrelated assets reduces overall portfolio variance without sacrificing expected return.',
      bulletPoints: [
        'Correlation (r) ranges from -1.0 to +1.0.',
        'Negative or zero correlation offers maximum diversification benefits.',
        'The Efficient Frontier plots portfolios maximizing return per unit of volatility.',
      ],
    ),
    CheatsheetSection(
      title: 'Risk-Adjusted Performance Metrics',
      content: 'Evaluating raw returns is misleading without accounting for risk exposure.',
      bulletPoints: [
        'Sharpe Ratio = (Return_p - RiskFree) / StdDev_p.',
        'Sortino Ratio = (Return_p - RiskFree) / DownsideDeviation (Ignores upside volatility).',
        'Treynor Ratio = (Return_p - RiskFree) / Beta_p (Focuses on systematic risk).',
      ],
    ),
  ],
);

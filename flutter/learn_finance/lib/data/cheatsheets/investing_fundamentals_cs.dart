import '../../models/cheatsheet.dart';

final Cheatsheet investingFundamentalsCheatsheet = Cheatsheet(
  category: 'Investing Fundamentals',
  summary: 'Core asset classes, allocation strategies, ETF dynamics, and risk-return trade-offs.',
  sections: [
    CheatsheetSection(
      title: 'Major Asset Classes Overview',
      content: 'Building a wealth strategy requires allocating capital across asset classes with complementary risk and return characteristics.',
      bulletPoints: [
        'Equities (Stocks): High long-term real growth (~7-10% historical CAGR), higher volatility.',
        'Fixed Income (Bonds): Lower volatility, steady cash flow yields, inversely correlated with rate cycles.',
        'Real Estate (REITs): Real asset exposure, inflation hedge, rental income distributions.',
        'Cash & Short-Term Treasuries: Maximum liquidity, zero capital loss risk, eroded by inflation long-term.',
      ],
    ),
    CheatsheetSection(
      title: 'Dollar-Cost Averaging & Indexing',
      content: 'Low-cost indexing combined with systematic DCA removes market-timing errors.',
      bulletPoints: [
        'Systematic purchasing buys more asset units when market drops.',
        'Total Market ETFs (e.g., VTI, VOO, QQQ) provide instant diversification across hundreds of equities.',
        'Expense Ratios under 0.10% are essential for minimizing compounding drag.',
      ],
    ),
  ],
);

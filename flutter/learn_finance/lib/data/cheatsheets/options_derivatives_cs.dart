import '../../models/cheatsheet.dart';

final Cheatsheet optionsDerivativesCheatsheet = Cheatsheet(
  category: 'Options & Derivatives',
  summary: 'Calls, Puts, option Greeks, risk curves, covered calls, and cash-secured puts.',
  sections: [
    CheatsheetSection(
      title: 'Calls vs Puts Fundamental Definitions',
      content: 'Option contracts grant the right (not obligation) to buy or sell 100 shares of stock at a fixed Strike Price before Expiration.',
      bulletPoints: [
        'Call Option: Right to BUY stock at Strike. (Bullish).',
        'Put Option: Right to SELL stock at Strike. (Bearish or Downside Hedge).',
        'In-The-Money (ITM): Intrinsic value > 0.',
        'Out-Of-The-Money (OTM): Price consists purely of Extrinsic / Time Value.',
      ],
    ),
    CheatsheetSection(
      title: 'Option Income Strategies',
      content: 'Generating recurring yield from stock portfolios using low-risk option strategies.',
      bulletPoints: [
        'Covered Call: Own 100 shares + Sell 1 OTM Call. Monetizes stock holdings.',
        'Cash-Secured Put: Hold collateral cash + Sell 1 OTM Put. Gets paid to place limit buy orders.',
      ],
    ),
  ],
);

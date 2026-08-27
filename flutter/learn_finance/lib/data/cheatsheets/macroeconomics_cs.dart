import '../../models/cheatsheet.dart';

final Cheatsheet macroeconomicsCheatsheet = Cheatsheet(
  category: 'Macroeconomics',
  summary: 'Central bank policy, yield curves, inflation dynamics, corporate capital structure, and economic cycles.',
  sections: [
    CheatsheetSection(
      title: 'Central Bank Policy & Rates',
      content: 'Federal Reserve rate hikes or cuts ripple directly through borrowing costs, asset valuations, and discount rates.',
      bulletPoints: [
        'Higher Interest Rates -> Higher discount rates -> Compression of growth stock valuation multiples.',
        'Lower Interest Rates -> Cheaper capital -> Expansion of credit and asset prices.',
        'Quantitative Tightening (QT) drains liquidity from bank reserves.',
      ],
    ),
    CheatsheetSection(
      title: 'Yield Curve Dynamics',
      content: 'The yield curve plots Treasury bond rates across maturities (1M to 30Y).',
      bulletPoints: [
        'Normal Curve: Upward sloping (Longer maturity = higher yield for lockup risk).',
        'Inverted Curve: Short rates higher than long rates -> Strong signal of economic contraction.',
      ],
    ),
  ],
);

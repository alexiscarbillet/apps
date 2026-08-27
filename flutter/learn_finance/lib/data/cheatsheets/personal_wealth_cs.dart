import '../../models/cheatsheet.dart';

final Cheatsheet personalWealthCheatsheet = Cheatsheet(
  category: 'Personal Wealth',
  summary: 'Wealth growth formulas, compound math, FIRE principles, and tax optimization.',
  sections: [
    CheatsheetSection(
      title: 'The Math of Compounding Wealth',
      content: 'Future Value formula dictates how monthly savings transform into multi-million dollar portfolios.',
      bulletPoints: [
        'FV = P * (1 + r/n)^(nt) + PMT * [((1 + r/n)^(nt) - 1) / (r/n)].',
        'Starting 10 years earlier doubles final accumulated nest egg at standard 8% returns.',
        'Savings Rate % = (Income - Expenses) / Income (The #1 accelerator to financial freedom).',
      ],
    ),
    CheatsheetSection(
      title: 'FIRE (Financial Independence) Framework',
      content: 'Achieving financial freedom means portfolio dividends/gains cover 100% of living costs.',
      bulletPoints: [
        'FI Number = Annual Expenses / Safe Withdrawal Rate (e.g. \$50k / 0.04 = \$1.25M).',
        'Trinity Study benchmark: 4% withdrawal rate survives 95%+ of historical 30-year market periods.',
      ],
    ),
  ],
);

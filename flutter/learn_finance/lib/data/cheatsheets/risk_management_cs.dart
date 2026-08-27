import '../../models/cheatsheet.dart';

final Cheatsheet riskManagementCheatsheet = Cheatsheet(
  category: 'Risk Management',
  summary: 'Cognitive biases, position sizing formulas, drawdown limits, and tail risk management.',
  sections: [
    CheatsheetSection(
      title: 'Behavioral Finance Biases',
      content: 'Cognitive errors destroy portfolio returns faster than bad stock selection.',
      bulletPoints: [
        'Loss Aversion: Holding losers hoping for a breakeven, leading to catastrophic drawdowns.',
        'FOMO (Fear of Missing Out): Chasing parabolic price movements at peak valuations.',
        'Anchoring: Fixing expectation on past purchase price rather than current intrinsic value.',
      ],
    ),
    CheatsheetSection(
      title: 'Position Sizing & Capital Preservation',
      content: 'Never risk more than 1-2% of total portfolio capital on a single position or stop loss.',
      bulletPoints: [
        'Position Size = Total Capital Risked (\$) / Stop Loss Distance (\$).',
        'Prevents consecutive losing trades from creating a drawdown spiral.',
      ],
    ),
  ],
);

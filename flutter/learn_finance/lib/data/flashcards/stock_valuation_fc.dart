import '../../models/flashcard.dart';

final List<Flashcard> stockValuationFlashcards = [
  Flashcard(
    frontTitle: 'Discounted Cash Flow (DCF)',
    frontSubtitle: 'Intrinsic value calculation method',
    backTitle: 'DCF Core Formula & Logic',
    backExplanation: 'Valuing a business by discounting its projected future Free Cash Flows back to present value using a discount rate (WACC).',
    bulletPoints: [
      'Present Value = FCF_1 / (1 + r)^1 + FCF_2 / (1 + r)^2 + ... + Terminal Value.',
      'Sensitive to discount rate (r) and terminal growth rate assumptions.',
      'Helps determine if stock trades at a margin of safety.',
    ],
    codeSnippet: '''
# Simplified Python DCF Formula
def calculate_dcf(fcf_list, wacc, terminal_growth):
    pv_fcf = sum([fcf / ((1 + wacc) ** i) for i, fcf in enumerate(fcf_list, 1)])
    terminal_val = (fcf_list[-1] * (1 + terminal_growth)) / (wacc - terminal_growth)
    pv_terminal = terminal_val / ((1 + wacc) ** len(fcf_list))
    return pv_fcf + pv_terminal
''',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'Free Cash Flow (FCF)',
    frontSubtitle: 'Actual cash generated after CapEx',
    backTitle: 'Free Cash Flow vs Net Income',
    backExplanation: 'Net Income includes non-cash accounting items. FCF measures real cash usable for dividends, buybacks, or debt repayment.',
    bulletPoints: [
      'FCF = Operating Cash Flow - Capital Expenditures (CapEx).',
      'High FCF Conversion (FCF / Net Income > 1.0) signals strong earnings quality.',
      'Harder to manipulate than accounting Net Income.',
    ],
    isConcept: true,
  ),
];

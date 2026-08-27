import '../../models/question.dart';

final List<Question> stockValuationQuestions = [
  Question(
    questionText: 'In Discounted Cash Flow (DCF) analysis, what does the Discount Rate (typically WACC) represent?',
    options: [
      'The inflation rate of consumer goods',
      'The required rate of return or hurdle rate reflecting the risk of the cash flows',
      'The historical dividend growth rate',
      'The company\'s gross profit margin percentage',
    ],
    correctAnswerIndex: 1,
    explanation: 'The discount rate accounts for the time value of money and the riskiness of future cash flows. Higher risk requires a higher discount rate, lowering present value.',
  ),
  Question(
    questionText: 'How is Free Cash Flow (FCF) calculated from operating cash flow?',
    options: [
      'FCF = Net Income - Dividends Paid',
      'FCF = Operating Cash Flow - Capital Expenditures (CapEx)',
      'FCF = Total Revenue - Total Operating Expenses',
      'FCF = Gross Profit - Interest Expense',
    ],
    correctAnswerIndex: 1,
    explanation: 'Free Cash Flow is the cash left over after paying for operational expenses and necessary capital investments (CapEx) to maintain/expand the business.',
  ),
  Question(
    questionText: 'What financial statement reports a company\'s assets, liabilities, and shareholder equity at a specific point in time?',
    options: [
      'Income Statement',
      'Statement of Cash Flows',
      'Balance Sheet',
      'Statement of Retained Earnings',
    ],
    correctAnswerIndex: 2,
    explanation: 'The Balance Sheet is a snapshot of financial position, satisfying the accounting equation: Assets = Liabilities + Shareholders\' Equity.',
  ),
  Question(
    questionText: 'What does Benjamin Graham\'s concept of "Margin of Safety" mean in value investing?',
    options: [
      'Only buying stocks that have federal government guarantees.',
      'Purchasing securities at a significant discount to their intrinsic value to absorb errors in valuation or bad market conditions.',
      'Holding 90% of your portfolio in physical gold cash reserves.',
      'Using 2x leverage on dividend aristocrat stocks.',
    ],
    correctAnswerIndex: 1,
    explanation: 'Margin of safety protects investor capital when analytical assumptions prove overly optimistic or unexpected negative shocks occur.',
  ),
  Question(
    questionText: 'If Company A has a P/E of 30 and Company B has a P/E of 12 in the same industry, what does this generally indicate?',
    options: [
      'Company A is guaranteed to be 3x more profitable next year.',
      'Investors expect Company A to grow earnings much faster than Company B, or Company A is overvalued.',
      'Company B has 0 debt on its balance sheet.',
      'Company A pays higher dividends than Company B.',
    ],
    correctAnswerIndex: 1,
    explanation: 'Higher P/E multiples reflect higher market growth expectations or premium pricing relative to current net earnings.',
  ),
];

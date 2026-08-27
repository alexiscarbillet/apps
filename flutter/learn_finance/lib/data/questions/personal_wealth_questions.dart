import '../../models/question.dart';

final List<Question> personalWealthQuestions = [
  Question(
    questionText: 'According to the Rule of 72, roughly how many years will it take for an investment to double at an 8% annual return rate?',
    options: [
      '5.5 years',
      '9.0 years (72 / 8 = 9)',
      '12.0 years',
      '14.4 years',
    ],
    correctAnswerIndex: 1,
    explanation: 'Divide 72 by the annual expected interest rate (72 / 8 = 9 years) for a fast estimate of doubling time.',
  ),
  Question(
    questionText: 'In FIRE (Financial Independence, Retire Early) planning, what does the 4% Safe Withdrawal Rate (SWR) imply?',
    options: [
      'You need a portfolio equal to 25x your annual living expenses (100 / 4 = 25).',
      'You must invest 4% of your income into crypto assets.',
      'Your portfolio will run out of cash in exactly 4 years.',
      'You must pay 4% annual tax on total net worth.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Based on the Trinity Study, withdrawing 4% inflation-adjusted annually from a balanced portfolio historically gives a high probability of capital longevity over 30+ years.',
  ),
  Question(
    questionText: 'What is Tax-Loss Harvesting?',
    options: [
      'Paying extra income taxes to avoid audits',
      'Selling investments at a loss to offset realized capital gains and reduce taxable income',
      'Holding stocks in a non-taxable overseas offshore shell company',
      'Converting traditional 401(k) funds to cash during a market breakdown',
    ],
    correctAnswerIndex: 1,
    explanation: 'Tax-loss harvesting allows investors to offset capital gains dollar-for-dollar (plus up to \$3,000 against ordinary income in the US), boosting tax efficiency.',
  ),
  Question(
    questionText: 'Why is compound interest considered "the 8th wonder of the world"?',
    options: [
      'It allows returns to earn returns on previous accumulated interest exponential curve over time.',
      'It requires zero starting capital.',
      'It is guaranteed by central bank insurance.',
      'It only applies to real estate transactions.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Compound growth accelerates exponentially over long time horizons because gains generate additional secondary gains.',
  ),
];

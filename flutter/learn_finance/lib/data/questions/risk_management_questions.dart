import '../../models/question.dart';

final List<Question> riskManagementQuestions = [
  Question(
    questionText: 'What is Loss Aversion in behavioral finance?',
    options: [
      'The psychological phenomenon where investors feel the pain of a financial loss roughly twice as strongly as the pleasure of an equivalent gain.',
      'A regulatory requirement preventing banks from taking risks.',
      'A trading strategy that guarantees 0 losses.',
      'The tendency to sell winning investments too slowly.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Discovered by Kahneman and Tversky, loss aversion leads investors to make irrational decisions like holding losing stocks to avoid locking in pain.',
  ),
  Question(
    questionText: 'What does Maximum Drawdown (MDD) measure in risk analysis?',
    options: [
      'The average annual profit of a portfolio',
      'The maximum observed loss from a historical peak to a trough before a new peak is attained',
      'The total tax paid over a decade',
      'The maximum cash dividend paid by a company',
    ],
    correctAnswerIndex: 1,
    explanation: 'Max Drawdown measures peak-to-trough downside risk, indicating structural downside exposure during severe stress events.',
  ),
  Question(
    questionText: 'Why is Position Sizing crucial in long-term wealth preservation?',
    options: [
      'It prevents a single unexpected failure or black swan event from destroying your net worth (Risk of Ruin).',
      'It maximizes broker transaction fees.',
      'It ensures you hold equal amounts of gold and silver.',
      'It guarantees 100% annual compound growth.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Limiting individual position size (e.g. max 2-5% risk per allocation) ensures survival through extreme unexpected market volatility.',
  ),
  Question(
    questionText: 'What is Recency Bias in investor decision making?',
    options: [
      'Over-weighting recent market performance or recent news events while ignoring long-term historical fundamentals.',
      'Only investing in companies founded in the last 12 months.',
      'Checking your portfolio balance every 5 minutes.',
      'Investing exclusively in real estate.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Recency bias causes investors to assume current bull or bear market trends will persist indefinitely into the future.',
  ),
];

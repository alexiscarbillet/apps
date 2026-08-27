import '../../models/question.dart';

final List<Question> financialCodingQuestions = [
  Question(
    questionText: 'When calculating Exponential Moving Averages (EMA) vs Simple Moving Averages (SMA) in quantitative code, what is the main difference?',
    options: [
      'SMA requires machine learning models; EMA uses basic addition.',
      'EMA places greater weight and significance on recent price data points, reducing lag compared to SMA.',
      'SMA can only be calculated on hourly data frames.',
      'EMA cannot be implemented in Python or Dart.',
    ],
    correctAnswerIndex: 1,
    explanation: 'EMA applies an exponential smoothing multiplier to give higher priority to recent price action, reacting faster to market trends.',
  ),
  Question(
    questionText: 'What is Look-Ahead Bias in quantitative backtesting code?',
    options: [
      'Using future data points (e.g. tomorrow\'s closing price) that would not have been available at the decision timestamp.',
      'Running backtests on computers with fast CPUs.',
      'Setting stop-loss triggers too close to current price.',
      'Using 10 years of historical data instead of 5 years.',
    ],
    correctAnswerIndex: 0,
    explanation: 'Look-ahead bias distorts historical trading backtest performance by relying on future information that wasn\'t accessible in real-time execution.',
  ),
  Question(
    questionText: 'In financial technical analysis code, what does an RSI (Relative Strength Index) value above 70 typically indicate?',
    options: [
      'The asset is severely undervalued and oversold.',
      'The asset is in an overbought condition and potentially prone to a pullback or consolidation.',
      'The company has doubled its annual revenue.',
      'The trading volume has dropped to zero.',
    ],
    correctAnswerIndex: 1,
    explanation: 'RSI ranges from 0 to 100. RSI > 70 signals overbought momentum, while RSI < 30 signals oversold momentum.',
  ),
  Question(
    questionText: 'Which Python pandas function is commonly used to compute percentage change returns between consecutive trading days?',
    options: [
      'df["Close"].pct_change()',
      'df["Close"].cumsum()',
      'df["Close"].dropna()',
      'df["Close"].rolling_mean()',
    ],
    correctAnswerIndex: 0,
    explanation: '`pct_change()` computes `(Price[t] - Price[t-1]) / Price[t-1]`, giving daily fractional returns.',
  ),
];

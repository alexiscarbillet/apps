import '../../models/cheatsheet.dart';

final Cheatsheet financialCodingCheatsheet = Cheatsheet(
  category: 'Financial Coding',
  summary: 'Quantitative indicators, backtesting logic, financial data processing in Python & Dart.',
  sections: [
    CheatsheetSection(
      title: 'Technical Indicators Algorithms',
      content: 'Code algorithms for momentum and trend-following indicators.',
      bulletPoints: [
        'SMA: Simple average over N rolling windows.',
        'EMA: Exponential weighting factor K = 2 / (N + 1).',
        'Bollinger Bands: Middle Band = 20 SMA; Upper/Lower Bands = Middle +/- (2 * StdDev).',
      ],
      codeSnippet: '''
# Python Bollinger Bands calculation
def bollinger_bands(df, window=20, num_std=2):
    rolling_mean = df['Close'].rolling(window=window).mean()
    rolling_std = df['Close'].rolling(window=window).std()
    upper_band = rolling_mean + (rolling_std * num_std)
    lower_band = rolling_mean - (rolling_std * num_std)
    return upper_band, rolling_mean, lower_band
''',
    ),
  ],
);

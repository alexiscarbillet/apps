import '../../models/flashcard.dart';

final List<Flashcard> financialCodingFlashcards = [
  Flashcard(
    frontTitle: 'RSI Calculation (Python)',
    frontSubtitle: 'Relative Strength Index algo logic',
    backTitle: 'RSI Indicator Implementation',
    backExplanation: 'RSI measures velocity and magnitude of directional price movements.',
    bulletPoints: [
      'RS = Average Gain / Average Loss over N periods (usually 14).',
      'RSI = 100 - (100 / (1 + RS)).',
      'Over 70 = Overbought, Under 30 = Oversold.',
    ],
    codeSnippet: '''
import pandas as pd

def compute_rsi(df, window=14):
    delta = df['Close'].diff()
    gain = (delta.where(delta > 0, 0)).rolling(window=window).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(window=window).mean()
    rs = gain / loss
    return 100 - (100 / (1 + rs))
''',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'Simple vs Exponential Moving Average',
    frontSubtitle: 'SMA vs EMA in quantitative code',
    backTitle: 'Smoothing Price Trends',
    backExplanation: 'SMA applies equal weights; EMA applies exponentially decaying weights.',
    bulletPoints: [
      'SMA = sum(Price_t) / N.',
      'EMA_t = Price_t * Multiplier + EMA_{t-1} * (1 - Multiplier).',
      'EMA reacts faster to recent breakout signals.',
    ],
    isConcept: false,
  ),
];

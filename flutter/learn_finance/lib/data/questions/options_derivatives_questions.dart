import '../../models/question.dart';

final List<Question> optionsDerivativesQuestions = [
  Question(
    questionText: 'What does Option Theta represent?',
    options: [
      'Sensitivity of option price to underlying stock price changes (Delta derivative)',
      'Time decay: the daily rate of decline in option premium value as expiration approaches',
      'Volatility change impact (Vega)',
      'Interest rate sensitivity (Rho)',
    ],
    correctAnswerIndex: 1,
    explanation: 'Theta measures time decay. As an option approaches expiration, its time value erodes at an accelerating rate.',
  ),
  Question(
    questionText: 'What is a Covered Call strategy?',
    options: [
      'Buying a call option while shorting 100 shares of stock',
      'Holding at least 100 shares of underlying stock while selling a call option against it to generate premium income',
      'Selling naked call options without owning the underlying equity',
      'Buying puts and calls simultaneously at the same strike price',
    ],
    correctAnswerIndex: 1,
    explanation: 'A Covered Call yields steady income from option premiums while providing downside protection equal to the premium collected.',
  ),
  Question(
    questionText: 'What is Option Delta?',
    options: [
      'The expected dollar change in option price per \$1 movement in the underlying asset price',
      'The percentage dividend payout',
      'The total commission charged by options brokers',
      'The probability of a stock going bankrupt',
    ],
    correctAnswerIndex: 0,
    explanation: 'Delta ranges from 0 to 1.0 for Calls (and 0 to -1.0 for Puts), serving as a hedge ratio and approximate probability of expiring in-the-money.',
  ),
  Question(
    questionText: 'In "The Wheel" option income strategy, what option do you sell first?',
    options: [
      'An Out-Of-The-Money (OTM) Cash-Secured Put',
      'An In-The-Money Call option',
      'A long LEAPS call option',
      'An iron condor spread',
    ],
    correctAnswerIndex: 0,
    explanation: 'The Wheel begins by selling Cash-Secured Puts to collect premium until assigned stock, then selling Covered Calls until assigned cash.',
  ),
];

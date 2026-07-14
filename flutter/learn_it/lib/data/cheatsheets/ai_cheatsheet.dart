import '../../models/cheatsheet.dart';

final Cheatsheet aiCheatsheet = Cheatsheet(
  category: 'AI',
  summary: 'Artificial Intelligence and Machine Learning form the basis of modern intelligent applications. Here are the core categories, metrics, and models.',
  sections: [
    CheatsheetSection(
      title: 'Supervised vs. Unsupervised Learning',
      content: 'Machine learning is broadly categorized into systems that learn from labeled datasets (Supervised) and systems that find hidden structures in raw data (Unsupervised).',
      bulletPoints: [
        'Supervised: Includes Regression (predicting a continuous value, e.g. price) and Classification (predicting discrete labels, e.g. spam/ham).',
        'Unsupervised: Includes Clustering (grouping similar items together, e.g. K-Means) and Dimensionality Reduction (simplifying features, e.g. PCA).',
        'Reinforcement Learning: Learning to make decisions by performing actions in an environment to maximize a reward.',
      ],
      codeSnippet: '# Typical supervised flow in python\nfrom sklearn.linear_model import LinearRegression\nmodel = LinearRegression()\nmodel.fit(X_train, y_train)\npredictions = model.predict(X_test)',
    ),
    CheatsheetSection(
      title: 'Neural Networks & Deep Learning',
      content: 'Deep learning uses artificial neural networks inspired by human brains to capture complex, non-linear relationships in data.',
      bulletPoints: [
        'Neurons & Layers: Network structure containing Input, Hidden, and Output layers of nodes.',
        'Activation Functions: Introduces non-linearity (e.g., ReLU f(x)=max(0,x), Sigmoid, Tanh, Softmax).',
        'Backpropagation: The mathematical mechanism that calculates the gradient of the error function to update weights.',
        'Optimizer: Algorithms like Gradient Descent, Adam, or RMSprop that adjust weights to minimize loss.',
      ],
      codeSnippet: '# Basic neural network node output\noutput = activation_function(sum(weights * inputs) + bias)',
    ),
    CheatsheetSection(
      title: 'Transformers & Large Language Models',
      content: 'Transformers revolutionized Natural Language Processing (NLP) by replacing sequential RNN architectures with parallel attention-based processing.',
      bulletPoints: [
        'Self-Attention: Mechanism letting the model weight the importance of different words in a sentence relative to each other.',
        'Encoder-Decoder: Standard architecture where encoder processes input sequence and decoder generates output.',
        'LLM Lifecycle: Pre-training (unsupervised learning on huge text corpora) followed by Fine-Tuning (supervised adaptation for specific tasks).',
      ],
      codeSnippet: '# Calculating Self-Attention\nAttention(Q, K, V) = softmax( (Q * K^T) / sqrt(d_k) ) * V',
    ),
    CheatsheetSection(
      title: 'Evaluation Metrics & Pitfalls',
      content: 'Measuring model performance properly is crucial to prevent pitfalls like overfitting, where a model memorizes training noise.',
      bulletPoints: [
        'Precision vs Recall: Precision = TP / (TP+FP) [minimize false positives]; Recall = TP / (TP+FN) [minimize false negatives].',
        'F1-Score: The harmonic mean of Precision and Recall.',
        'Overfitting vs Underfitting: Overfitting (low training error, high test error); Underfitting (high training and test error).',
        'Bias-Variance Tradeoff: High bias leads to underfitting (too simple); High variance leads to overfitting (too sensitive to training data).',
      ],
      codeSnippet: 'Precision = TruePositives / (TruePositives + FalsePositives)\nRecall = TruePositives / (TruePositives + FalseNegatives)\nF1 = 2 * (Precision * Recall) / (Precision + Recall)',
    ),
  ],
);

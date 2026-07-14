import 'dart:math';
import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _quizQuestions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _isFinished = false;
  
  // Track user answers for the review screen
  // Key: Question index, Value: Selected option index
  final Map<int, int> _userAnswers = {};

  @override
  void initState() {
    super.initState();
    _setupQuiz();
  }

  void _setupQuiz() {
    final rng = Random();
    final rawQuestions = quizData[widget.category] ?? [];
    final shuffledQuestions = List<Question>.from(rawQuestions)..shuffle(rng);
    final selectedQuestions = shuffledQuestions.take(10).toList();

    // Shuffle the options of each question and update the correctAnswerIndex
    _quizQuestions = selectedQuestions.map((q) {
      final correctAnswer = q.options[q.correctAnswerIndex];
      final shuffledOptions = List<String>.from(q.options)..shuffle(rng);
      final newCorrectIndex = shuffledOptions.indexOf(correctAnswer);
      return Question(
        questionText: q.questionText,
        options: shuffledOptions,
        correctAnswerIndex: newCorrectIndex,
        explanation: q.explanation,
      );
    }).toList();

    _currentIndex = 0;
    _score = 0;
    _isAnswered = false;
    _selectedAnswerIndex = null;
    _isFinished = false;
    _userAnswers.clear();
  }

  void _handleAnswerSelection(int index) {
    if (_isAnswered) return; // Prevent changing answers

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      _userAnswers[_currentIndex] = index;
      if (index == _quizQuestions[_currentIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < _quizQuestions.length - 1) {
        _currentIndex++;
        _isAnswered = false;
        _selectedAnswerIndex = null;
      } else {
        _isFinished = true;
      }
    });
  }

  Widget _buildResultsView() {
    final percentage = _quizQuestions.isEmpty ? 0.0 : _score / _quizQuestions.length;
    
    // Performance assessment
    String title;
    String subtitle;
    IconData rankIcon;
    Color rankColor;
    
    if (_score == _quizQuestions.length) {
      title = 'Perfect Master!';
      subtitle = 'You have completely mastered ${widget.category}.';
      rankIcon = Icons.workspace_premium_rounded;
      rankColor = const Color(0xFFF59E0B); // Gold
    } else if (_score >= 8) {
      title = 'Tech Specialist';
      subtitle = 'Excellent job! Deep knowledge in ${widget.category}.';
      rankIcon = Icons.military_tech_rounded;
      rankColor = const Color(0xFF3B82F6); // Blue
    } else if (_score >= 5) {
      title = 'Tech Practitioner';
      subtitle = 'Good effort. Solid basics in ${widget.category}.';
      rankIcon = Icons.verified_user_rounded;
      rankColor = const Color(0xFF10B981); // Emerald
    } else {
      title = 'Aspiring Learner';
      subtitle = 'Keep studying! Review the details below to improve.';
      rankIcon = Icons.menu_book_rounded;
      rankColor = const Color(0xFFEF4444); // Red
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Results Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Circular progress score gauge
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: percentage,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.08),
                            valueColor: AlwaysStoppedAnimation<Color>(rankColor),
                          ),
                        ),
                        Text(
                          '$_score/${_quizQuestions.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(rankIcon, color: rankColor, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: rankColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Title for Review Area
              Row(
                children: [
                  const Icon(Icons.psychology_outlined, color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Review and Learn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Scrollable Review Area
              Expanded(
                child: ListView.separated(
                  itemCount: _quizQuestions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final question = _quizQuestions[index];
                    final userAnswerIndex = _userAnswers[index];
                    final isCorrect = userAnswerIndex == question.correctAnswerIndex;
                    
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        unselectedWidgetColor: const Color(0xFF94A3B8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCorrect 
                                ? Colors.green.withValues(alpha: 0.15) 
                                : Colors.red.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ExpansionTile(
                          backgroundColor: Colors.transparent,
                          collapsedBackgroundColor: Colors.transparent,
                          title: Text(
                            'Question ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            question.questionText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isCorrect 
                                  ? Colors.green.withValues(alpha: 0.1) 
                                  : Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCorrect ? Icons.check_rounded : Icons.close_rounded,
                              color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                              size: 18,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(color: Colors.white10),
                                  const SizedBox(height: 8),
                                  Text(
                                    question.questionText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // User Answer vs Correct Answer
                                  ...List.generate(question.options.length, (optIdx) {
                                    final optionText = question.options[optIdx];
                                    final isOptionCorrect = optIdx == question.correctAnswerIndex;
                                    final isOptionUserChoice = optIdx == userAnswerIndex;
                                    
                                    Color itemColor = Colors.transparent;
                                    BorderSide borderSide = BorderSide(color: Colors.white.withValues(alpha: 0.05));
                                    Widget? trailingIcon;
                                    
                                    if (isOptionCorrect) {
                                      itemColor = Colors.green.withValues(alpha: 0.15);
                                      borderSide = const BorderSide(color: Colors.greenAccent, width: 1);
                                      trailingIcon = const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16);
                                    } else if (isOptionUserChoice && !isCorrect) {
                                      itemColor = Colors.red.withValues(alpha: 0.15);
                                      borderSide = const BorderSide(color: Colors.redAccent, width: 1);
                                      trailingIcon = const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 16);
                                    }

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: itemColor,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.fromBorderSide(borderSide),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              optionText,
                                              style: TextStyle(
                                                color: isOptionCorrect || isOptionUserChoice ? Colors.white : const Color(0xFF94A3B8),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          // ignore: use_null_aware_elements
                                          if (trailingIcon != null) trailingIcon,
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                  
                                  // Explanation Box
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.info_outline, color: Colors.blueAccent, size: 16),
                                            SizedBox(width: 6),
                                            Text(
                                              'Explanation:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          question.explanation,
                                          style: const TextStyle(
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 12,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back to Menu',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _setupQuiz();
                          });
                        },
                        child: const Text(
                          'Play Again',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final currentQuestion = _quizQuestions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          '${widget.category} Quiz',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Confirm quit
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1E293B),
                title: const Text('Quit Quiz?', style: TextStyle(color: Colors.white)),
                content: const Text('Your current progress will be lost.', style: TextStyle(color: Color(0xFFCBD5E1))),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Return to dashboard
                    },
                    child: const Text('Quit', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${_quizQuestions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Animated progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _quizQuestions.isEmpty ? 0.0 : (_currentIndex + 1) / _quizQuestions.length,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 28),

              // Question Text inside custom card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Text(
                  currentQuestion.questionText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Multiple Choice Options List
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    final optionText = currentQuestion.options[index];
                    
                    Color itemColor = const Color(0xFF1E293B);
                    BorderSide borderSide = BorderSide(color: Colors.white.withValues(alpha: 0.06));
                    Widget? feedbackIcon;
                    
                    if (_isAnswered) {
                      final isCorrect = index == currentQuestion.correctAnswerIndex;
                      final isUserChoice = index == _selectedAnswerIndex;
                      
                      if (isCorrect) {
                        itemColor = Colors.green.withValues(alpha: 0.15);
                        borderSide = const BorderSide(color: Colors.greenAccent, width: 1.5);
                        feedbackIcon = const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 20);
                      } else if (isUserChoice) {
                        itemColor = Colors.red.withValues(alpha: 0.15);
                        borderSide = const BorderSide(color: Colors.redAccent, width: 1.5);
                        feedbackIcon = const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 20);
                      } else {
                        // Fade out other non-selected, non-correct choices
                        itemColor = const Color(0xFF1E293B).withValues(alpha: 0.5);
                      }
                    } else if (_selectedAnswerIndex == index) {
                      borderSide = const BorderSide(color: Colors.blueAccent, width: 1.5);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () => _handleAnswerSelection(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          decoration: BoxDecoration(
                            color: itemColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.fromBorderSide(borderSide),
                          ),
                          child: Row(
                            children: [
                              // Option indicator circle (A, B, C, D)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              if (feedbackIcon != null) ...[
                                const SizedBox(width: 10),
                                feedbackIcon,
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Explanation Box & Next Button Area
              if (_isAnswered) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blueAccent, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Explanation',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentQuestion.explanation,
                        style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _nextQuestion,
                    child: Text(
                      _currentIndex == _quizQuestions.length - 1 ? 'Finish Quiz' : 'Next Question',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_quizQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          title: Text(widget.category, style: const TextStyle(color: Colors.white)), 
          backgroundColor: Colors.transparent, 
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'No questions available for this topic yet!',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    if (_isFinished) {
      return _buildResultsView();
    }

    return _buildQuizView();
  }
}

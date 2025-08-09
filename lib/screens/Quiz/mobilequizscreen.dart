import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:children_cs_awareness_quiz/screens/Navigation/MobileNavigation.dart';
import 'package:children_cs_awareness_quiz/screens/badges/mobilebadges.dart';
import '../../Widgets/colors.dart';
import '../../provider/quiz_provider.dart';

class MobileQuizScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const MobileQuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<MobileQuizScreen> createState() => _MobileQuizScreenState();
}

class _MobileQuizScreenState extends State<MobileQuizScreen> {
  int selectedIndex = -1;
  bool hasSubmitted = false;
  bool _isLoading = false;
  int _timeElapsed = 0;
  late DateTime _questionStartTime;

  @override
  void initState() {
    super.initState();
    _startQuestion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      if (provider.currentQuestion == null) {
        provider.startQuiz(widget.categoryId);
      }
    });
  }

  void _startQuestion() {
    _questionStartTime = DateTime.now();
    setState(() {
      selectedIndex = -1;
      hasSubmitted = false;
    });
  }

  void _onAnswerTap(int index) {
    if (hasSubmitted || _isLoading) return;
    setState(() {
      selectedIndex = index;
    });
  }

  void _submitAnswer() async {
    if (selectedIndex == -1 || hasSubmitted || _isLoading) return;

    setState(() {
      hasSubmitted = true;
      _isLoading = true;
      _timeElapsed = DateTime.now().difference(_questionStartTime).inSeconds;
    });

    try {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      final question = provider.currentQuestion!;
      final selectedOption = question.options[selectedIndex];

      final result = await provider.submitAnswer(
        selectedOption.id,
        _timeElapsed,
      );

      if (result != null && mounted) {
        // Check for new badges
        if (result.newBadges.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MobileBadges()),
          );
        } else {
          _showFeedback(result.isCorrect, result.explanation);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting answer: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showFeedback(bool isCorrect, String explanation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isCorrect ? '🎉 Great job!' : '😊 Good try!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isCorrect
                  ? 'assets/images/happy_mascot.png'
                  : 'assets/images/sad_mascot.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  isCorrect ? Icons.celebration : Icons.lightbulb,
                  size: 120,
                  color: isCorrect ? Colors.green : Colors.orange,
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              explanation,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainNavigationScreen()),
              );
            },
            child: Text(
              "Exit",
              style: TextStyle(color: AppColors.inactiveColor, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Get next question
              final provider = Provider.of<QuizProvider>(
                context,
                listen: false,
              );
              await provider.getNextQuestion();

              if (provider.currentQuestion != null) {
                _startQuestion();
              } else {
                // No more questions - show completion
                _showCompletion();
              }
            },
            child: Text(
              isCorrect ? '➡️ Next Question' : '➡️ Got it! Next',
              style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '🎊 Category Complete!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Great job completing ${widget.categoryName}!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainNavigationScreen()),
              );
            },
            child: Text(
              "Continue Learning",
              style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: Text(widget.categoryName),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your personalized question...'),
                ],
              ),
            );
          }

          if (provider.currentQuestion == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'No more questions available!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainNavigationScreen(),
                        ),
                      );
                    },
                    child: Text('Back to Categories'),
                  ),
                ],
              ),
            );
          }

          final question = provider.currentQuestion!;
          final user = provider.currentUser;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header with progress and stats
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Adaptive Learning Active',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ],
                      ),
                      if (user != null)
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '🏆 ${user.totalPoints} pts',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '🔥 ${user.currentStreak}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Question type indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      'Question Type: ${question.typeName.replaceAll('_', ' ').toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Question image (if available)
                  if (question.imageUrl != null)
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade100,
                      ),
                      child: Image.network(
                        question.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue.shade50,
                      ),
                      child: Icon(
                        Icons.quiz,
                        size: 60,
                        color: Colors.blue.shade300,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Question text
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      question.questionText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Answer options
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.options.length,
                      itemBuilder: (context, i) {
                        final option = question.options[i];
                        final isSelected = selectedIndex == i;

                        Color bgColor = Colors.white;
                        if (isSelected && !hasSubmitted) {
                          bgColor = Colors.blue.shade50;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () => _onAnswerTap(i),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: question.typeName == 'true_false'
                                  ? 80
                                  : 70,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue.shade400
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.1),
                                    blurRadius: isSelected ? 8 : 4,
                                    offset: Offset(0, isSelected ? 4 : 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.shade100
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        bottomLeft: Radius.circular(14),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        option.icon ?? '📱',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      option.optionText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.blue.shade800
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed:
                          (selectedIndex != -1 && !hasSubmitted && !_isLoading)
                          ? _submitAnswer
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit Answer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  // Hint section
                  if (question.hintText != null)
                    Text(
                      '💡 Hint: ${question.hintText}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

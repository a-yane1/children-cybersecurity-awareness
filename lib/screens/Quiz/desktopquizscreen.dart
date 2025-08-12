import 'package:children_cs_awareness_quiz/models/badges.dart';
import 'package:children_cs_awareness_quiz/screens/Categories/desktopcategoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:children_cs_awareness_quiz/screens/Navigation/MobileNavigation.dart';
import '../../Widgets/colors.dart';
import '../../Widgets/desktop_question_display.dart';
import '../../Widgets/quiz_header.dart';
import '../../provider/quiz_provider.dart';

class DesktopQuizScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const DesktopQuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<DesktopQuizScreen> createState() => _DesktopQuizScreenState();
}

class _DesktopQuizScreenState extends State<DesktopQuizScreen> {
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
        provider.loadCategories();
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

  void _onAnswerSelected(int index) {
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
        // Always show feedback, even with new badges
        _showFeedback(result.isCorrect, result.explanation, result.newBadges);
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

  void _showFeedback(
    bool isCorrect,
    String explanation, [
    List<Badges>? newBadges,
  ]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: isCorrect
            ? const Color.fromARGB(255, 230, 247, 230)
            : const Color.fromARGB(255, 245, 227, 225),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isCorrect ? '🎉 Great job!' : '😊 Good try!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCorrect ? AppColors.successColor : AppColors.errorColor,
          ),
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

            // Show badge celebration if new badges were earned
            if (newBadges != null && newBadges.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      '🏆 New Badge${newBadges.length > 1 ? 's' : ''} Earned!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...newBadges
                        .map(
                          (badge) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  badge.icon,
                                  style: TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  badge.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => DesktopCategoryScreen()),
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
            onPressed: () async {
              final provider = Provider.of<QuizProvider>(
                context,
                listen: false,
              );
              await provider.refreshCategories();

              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => DesktopCategoryScreen()),
                );
              }
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
  void dispose() {
    // Clear current question when leaving the screen
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.clearCurrentQuestion();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = Provider.of<QuizProvider>(context, listen: false);
        provider.clearCurrentQuestion();
        return true; // Allow back navigation
      },
      child: Scaffold(
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
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DesktopCategoryScreen(),
                        ),
                      ),
                      child: Text('Back to Categories'),
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    QuizHeader(user: provider.currentUser),
                    const SizedBox(height: 24),
                    Expanded(
                      child: DesktopQuestionDisplay(
                        question: provider.currentQuestion!,
                        selectedIndex: selectedIndex,
                        onAnswerSelected: _onAnswerSelected,
                        onSubmit: _submitAnswer,
                        isLoading: _isLoading,
                        hasSubmitted: hasSubmitted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

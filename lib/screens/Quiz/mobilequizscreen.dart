import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:children_cs_awareness_quiz/screens/Navigation/MobileNavigation.dart';
import 'package:children_cs_awareness_quiz/screens/badges/mobilebadges.dart';
import '../../Widgets/colors.dart';
import '../../Widgets/feedback_dialog.dart';
import '../../Widgets/question_display.dart';
import '../../Widgets/quiz_header.dart';
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
      builder: (_) => FeedbackDialog(
        isCorrect: isCorrect,
        explanation: explanation,
        onContinue: _continueToNextQuestion,
        onExit: () async {
          // Clear current question and refresh categories
          final provider = Provider.of<QuizProvider>(context, listen: false);
          provider.clearCurrentQuestion();
          await provider.refreshCategories();

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainNavigationScreen()),
            );
          }
        },
      ),
    );
  }

  void _continueToNextQuestion() async {
    Navigator.pop(context); // Close dialog

    final provider = Provider.of<QuizProvider>(context, listen: false);
    await provider.getNextQuestion();

    if (provider.currentQuestion != null) {
      _startQuestion();
    } else {
      _showCompletion();
    }
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
                  MaterialPageRoute(builder: (_) => MainNavigationScreen()),
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
                          builder: (_) => MainNavigationScreen(),
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
                      child: QuestionDisplay(
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

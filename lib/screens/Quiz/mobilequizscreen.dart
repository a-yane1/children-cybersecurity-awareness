import 'package:children_cs_awareness_quiz/screens/Navigation/MobileNavigation.dart';
import 'package:children_cs_awareness_quiz/screens/badges/mobilebadges.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../Widgets/colors.dart';
import '../../utility/checkforbadges.dart';

class MobileQuizScreen extends StatefulWidget {
  final String topic;
  final String userName;

  const MobileQuizScreen({
    super.key,
    required this.topic,
    required this.userName,
  });

  @override
  State<MobileQuizScreen> createState() => _MobileQuizScreenState();
}

class _MobileQuizScreenState extends State<MobileQuizScreen> {
  int selectedIndex = -1;
  bool hasSubmitted = false;
  int currentQuestionIndex = 0;
  int score = 0;
  int currentStreak = 0;
  int maxStreak = 0;

  int correctAnswersThisTopic = 0; // tracks correct answers for current topic

  late Box box;
  late Set<String> earnedBadges;

  @override
  void initState() {
    super.initState();
    box = Hive.box('userBox');
    earnedBadges = Set<String>.from(
      List<String>.from(box.get('badges', defaultValue: <String>[])),
    );
  }

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Someone calls asking for the numbers mom just got. What should you do?',
      'options': [
        {'icon': '📞', 'text': 'Give them the numbers', 'isCorrect': false},
        {'icon': '👩', 'text': 'Tell mom about the call', 'isCorrect': true},
        {'icon': '🔇', 'text': 'Hang up and ignore', 'isCorrect': false},
      ],
      'image': 'assets/images/Password.png',
    },
    {
      'question':
          'Someone calls asking for the numbers mom just got. What should you do?',
      'options': [
        {'icon': '📞', 'text': 'Give them the numbers', 'isCorrect': false},
        {'icon': '👩', 'text': 'Tell mom about the call', 'isCorrect': true},
        {'icon': '🔇', 'text': 'Hang up and ignore', 'isCorrect': false},
      ],
      'image': 'assets/images/Password.png',
    },
    // Add more questions later
  ];

  void _onAnswerTap(int index) {
    if (hasSubmitted) return;
    setState(() {
      selectedIndex = index;
    });
  }

  void _submitAnswer() {
    if (selectedIndex == -1 || hasSubmitted) return;

    setState(() {
      hasSubmitted = true;
    });

    final isCorrect =
        questions[currentQuestionIndex]['options'][selectedIndex]['isCorrect'];
    setState(() {
      if (isCorrect) {
        score += 2;
        currentStreak++;

        // Save to Hive
        final box = Hive.box('userBox');
        box.put('score', score);

        // Update topic progress
        final progressKey =
            'progress_${widget.topic.toLowerCase().replaceAll(' ', '_')}';
        final currentProgress = box.get(progressKey, defaultValue: 0);
        box.put(progressKey, currentProgress + 1);
      } else {
        currentStreak = 0; // 🧨 FIXED
      }
    });

    checkForBadges(
      topic: widget.topic,
      currentStreak: currentStreak,
      correctAnswersInTopic: correctAnswersThisTopic,
      totalQuestionsInTopic: questions.length,
      unlockedBadgeIds: earnedBadges,
      onUnlock: (id, name, desc) {
        earnedBadges.add(id);
        box.put(
          'badges',
          earnedBadges.toList(),
        ); // Add to unlocked list (we’ll persist with Hive later)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MobileBadges()),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _showFeedback(isCorrect);
    });
  }

  void _showFeedback(bool isCorrect) {
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
            ),
            const SizedBox(height: 12),
            Text(
              isCorrect
                  ? 'That\'s right! Never give phone numbers to strangers. Always tell a grown-up first!'
                  : 'Never give codes to strangers on the phone! Always ask a grown-up first.',
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
              "exit",
              style: TextStyle(color: AppColors.inactiveColor, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (currentQuestionIndex + 1 < questions.length) {
                setState(() {
                  currentQuestionIndex++;
                  selectedIndex = -1;
                  hasSubmitted = false;
                });
              } else {
                // Later: Handle end of quiz (e.g., show results or restart)
              }
            },
            child: Text(
              isCorrect ? '➡️ Next Question' : '➡️ Got it! Next',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestionIndex];
    final totalQuestions = questions.length;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(backgroundColor: AppColors.surfaceColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: LinearProgressIndicator(
                          value: currentQuestionIndex / totalQuestions,
                          borderRadius: BorderRadius.circular(5),
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Question ${currentQuestionIndex + 1} of $totalQuestions',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '🏆 $score pts',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '🔥 Streak: $currentStreak',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Question image
              Image.asset(q['image'], height: 180),

              const SizedBox(height: 20),

              // Question text
              Text(
                q['question'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Options
              ...List.generate(q['options'].length, (i) {
                final opt = q['options'][i];
                final isSelected = selectedIndex == i;
                final isCorrect = opt['isCorrect'];

                Color bgColor = Colors.white;

                if (hasSubmitted) {
                  bgColor = isCorrect
                      ? AppColors.secondaryColor
                      : (isSelected ? const Color(0xFFFFC107) : Colors.white);
                } else if (isSelected) {
                  bgColor = const Color(0xFFBBDEFB); // soft blue for selection
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: () => _onAnswerTap(i),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(
                            opt['icon'],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              opt['text'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              Spacer(),
              ElevatedButton(
                onPressed: (selectedIndex != -1 && !hasSubmitted)
                    ? _submitAnswer
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '💡 Need a hint?',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

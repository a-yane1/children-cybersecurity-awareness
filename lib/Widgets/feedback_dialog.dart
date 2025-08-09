import 'package:flutter/material.dart';
import '../../../Widgets/colors.dart';

class FeedbackDialog extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final VoidCallback onContinue;
  final VoidCallback onExit;

  const FeedbackDialog({
    super.key,
    required this.isCorrect,
    required this.explanation,
    required this.onContinue,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          onPressed: onExit,
          child: Text(
            "Exit",
            style: TextStyle(color: AppColors.inactiveColor, fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: onContinue,
          child: Text(
            isCorrect ? '➡️ Next Question' : '➡️ Got it! Next',
            style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}

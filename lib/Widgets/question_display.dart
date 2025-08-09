import 'package:children_cs_awareness_quiz/Widgets/answer_option.dart';
import 'package:flutter/material.dart';
import '../../../models/questions.dart';
import '../../../Widgets/colors.dart';

class QuestionDisplay extends StatelessWidget {
  final Question question;
  final int selectedIndex;
  final Function(int) onAnswerSelected;
  final VoidCallback onSubmit;
  final bool isLoading;
  final bool hasSubmitted; // Make sure this is here

  const QuestionDisplay({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onAnswerSelected,
    required this.onSubmit,
    required this.isLoading,
    required this.hasSubmitted, // Make sure this is here
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

        // Question image
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
                return Icon(Icons.image, size: 50, color: Colors.grey);
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
            child: Icon(Icons.quiz, size: 60, color: Colors.blue.shade300),
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
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: AnswerPicks(
                  option: question.options[index],
                  isSelected: selectedIndex == index,
                  questionType: question.typeName,
                  onTap: () => onAnswerSelected(index),
                  isDisabled: hasSubmitted || isLoading,
                  hasSubmitted: hasSubmitted,
                ),
              );
            },
          ),
        ),

        // Submit button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: (selectedIndex != -1 && !hasSubmitted && !isLoading)
                ? onSubmit
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isLoading
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
    );
  }
}

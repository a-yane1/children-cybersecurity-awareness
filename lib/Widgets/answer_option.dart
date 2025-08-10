import 'package:children_cs_awareness_quiz/Widgets/colors.dart';
import 'package:children_cs_awareness_quiz/models/questions.dart';
import 'package:flutter/material.dart';

class AnswerPicks extends StatelessWidget {
  final AnswerOption option;
  final bool isSelected;
  final String questionType;
  final VoidCallback onTap;
  final bool isDisabled;
  final bool hasSubmitted;

  const AnswerPicks({
    super.key,
    required this.option,
    required this.isSelected,
    required this.questionType,
    required this.onTap,
    this.isDisabled = false,
    this.hasSubmitted = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    // int borderWidth = 1;

    if (isSelected && !isDisabled) {
      // Before submission - neutral selection color
      bgColor = Colors.grey.shade100;
      borderColor = Colors.grey.shade400;
      // borderWidth = 2;
    }

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: questionType == 'true_false' ? 80 : 70,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.hovercolor
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
                color: isSelected ? Colors.blue.shade100 : Colors.grey.shade50,
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
          ],
        ),
      ),
    );
  }
}

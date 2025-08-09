import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../provider/quiz_provider.dart';
import 'colors.dart';

class TopicCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const TopicCard({Key? key, required this.category, required this.onTap})
    : super(key: key);

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Reset Progress',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to reset your progress for "${category.name}"? This will remove all your answers and points for this category.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.inactiveColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCategoryProgress(context);
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _resetCategoryProgress(BuildContext context) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    try {
      await quizProvider.resetCategoryProgress(category.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progress reset for ${category.name}'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset progress: $e'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with icon and menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(category.icon, style: TextStyle(fontSize: 24)),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.inactiveColor,
                    size: 20,
                  ),
                  onSelected: (String value) {
                    if (value == 'reset') {
                      _showResetDialog(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'reset',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Reset Progress',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12),

            // Category name
            Text(
              category.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            // Progress bar
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: category.progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: category.isCompleted
                        ? Colors.green
                        : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            SizedBox(height: 6),

            // Progress text
            Text(
              '${category.questionsAnswered}/${category.totalQuestions} completed',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),

            // Completion badge
            if (category.isCompleted)
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Complete! ✓',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

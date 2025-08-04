import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'colors.dart';

class TopicCard extends StatelessWidget {
  final String topicName;
  final String icon;
  final VoidCallback onTap;
  final int totalQuestions; // Pass total questions per topic

  const TopicCard({
    super.key,
    required this.topicName,
    required this.icon,
    required this.onTap,
    required this.totalQuestions,
  });

  String get _progressKey =>
      'progress_${topicName.toLowerCase().replaceAll(' ', '_')}';

  void _resetProgress(BuildContext context) async {
    final box = Hive.box('userBox');
    await box.put(_progressKey, 0); // 💡 overwrite with 0 instead of delete
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('userBox');
    // final progressKey =
    //     'progress_${topicName.toLowerCase().replaceAll(' ', '_')}';
    // final currentProgress = box.get(_progressKey, defaultValue: 0);
    // final double progressRatio = totalQuestions == 0
    //     ? 0
    //     : currentProgress / totalQuestions;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {
                final currentProgress = box.get(_progressKey, defaultValue: 0);
                final double progressRatio = totalQuestions == 0
                    ? 0
                    : currentProgress / totalQuestions;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(icon, style: const TextStyle(fontSize: 60)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topicName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(3),
                      value: progressRatio.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: AppColors.hovercolor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currentProgress.clamp(0, totalQuestions)} of $totalQuestions answered',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.inactiveColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3-dot menu
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'reset') _resetProgress(context);
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'reset',
                  child: Text('Reset Progress'),
                ),
              ],
              icon: const Icon(
                Icons.more_vert,
                size: 20,
                color: AppColors.inactiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

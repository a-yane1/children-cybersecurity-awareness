import 'package:children_cs_awareness_quiz/Widgets/topiccard.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../Widgets/colors.dart' show AppColors;
import '../Quiz/mobilequizscreen.dart';

class MobileCategoryScreen extends StatelessWidget {
  MobileCategoryScreen({super.key});
  static const routeName = 'mobile-category';

  final name = Hive.box('userBox').get('name', defaultValue: 'Friend');
  final progress = Hive.box(
    'userBox',
  ).get('progress_passwords', defaultValue: 0);

  void _onTopicSelected(BuildContext context, String topic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Selected: $topic"),
        duration: Duration(seconds: 1),
        dismissDirection: DismissDirection.down,
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MobileQuizScreen(topic: topic, userName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'icon': '📱', 'label': 'Phone Safety'},
      {'icon': '🔐', 'label': 'Passwords'},
      {'icon': '🖱️', 'label': 'Safe Clicking'},
      {'icon': '👤', 'label': 'Stranger Danger'},
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi $name! 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "What do you want to learn about?",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.inactiveColor,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16,
                  children: topics.map((topic) {
                    return TopicCard(
                      topicName: topic['label']!,
                      icon: topic['icon']!,
                      onTap: () => _onTopicSelected(context, topic['label']!),
                      totalQuestions: 50,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final randomTopic = topics.toList()..shuffle();
                  _onTopicSelected(context, randomTopic.first['label']!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "🎲 Surprise Me!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

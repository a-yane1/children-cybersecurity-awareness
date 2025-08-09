import 'package:children_cs_awareness_quiz/screens/Quiz/desktopquizscreen.dart';
import 'package:children_cs_awareness_quiz/screens/Quiz/mobilequizscreen.dart';
import 'package:flutter/material.dart';

class ResponsiveQuizScreen extends StatelessWidget {
  const ResponsiveQuizScreen({super.key});

  static const String routeName = '/responsive-Quiz';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return const DesktopQuizScreen();
        } else {
          return MobileQuizScreen(categoryId: 0, categoryName: '');
        }
      },
    );
  }
}

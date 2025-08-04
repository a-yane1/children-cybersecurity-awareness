import 'package:children_cs_awareness_quiz/Widgets/colors.dart';
import 'package:children_cs_awareness_quiz/screens/Categories/mobilecategoryscreen.dart';
import 'package:children_cs_awareness_quiz/screens/badges/mobilebadges.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  static const routeName = 'Main-Navigation';

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [MobileCategoryScreen(), MobileBadges()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.appbarColor,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.inactiveColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events, size: 24),
            label: 'Badges',
          ),
        ],
      ),
    );
  }
}

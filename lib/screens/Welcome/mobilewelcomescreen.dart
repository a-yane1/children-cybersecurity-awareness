import 'package:children_cs_awareness_quiz/screens/Navigation/MobileNavigation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../Widgets/colors.dart';

class MobileWelcomeScreen extends StatefulWidget {
  const MobileWelcomeScreen({super.key});

  @override
  State<MobileWelcomeScreen> createState() => _MobileWelcomeScreenState();
}

class _MobileWelcomeScreenState extends State<MobileWelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _startQuiz() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final box = Hive.box('userBox');
      await box.put('name', name);

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              '🛡️ Stay Safe Online!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/mascot.png',
              height: screenSize.height * 0.3,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              "What's your name?",
              style: TextStyle(fontSize: 20, color: const Color(0xFF333333)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Your name here',
                hintStyle: TextStyle(fontSize: 18),
                filled: true,
                fillColor: AppColors.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                elevation: 2,
                foregroundColor: WidgetStateColor.resolveWith((states) {
                  return states.contains(WidgetState.hovered)
                      ? AppColors.textColor
                      : AppColors.secondarytextColor;
                }),
                overlayColor: WidgetStateColor.resolveWith((states) {
                  return states.contains(WidgetState.hovered)
                      ? AppColors.hovercolor
                      : Colors.transparent;
                }),

                backgroundColor: AppColors.primaryColor,

                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Text("🚀", style: TextStyle(fontSize: 20)),
              label: Text(
                "Let's Start!",
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
    );
  }
}

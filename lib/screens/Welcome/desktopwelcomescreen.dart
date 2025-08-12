import 'package:children_cs_awareness_quiz/screens/Categories/desktopcategoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/colors.dart';
import '../../provider/quiz_provider.dart';
import '../../Widgets/appsizes.dart';

class DesktopWelcomeScreen extends StatefulWidget {
  const DesktopWelcomeScreen({super.key});

  @override
  State<DesktopWelcomeScreen> createState() => _DesktopWelcomeScreenState();
}

class _DesktopWelcomeScreenState extends State<DesktopWelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void _startQuiz() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your name')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      await quizProvider.createUser(name);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DesktopCategoryScreen(),
          ), // CHANGED: Desktop navigation
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create user: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Center(
        // CHANGED: Center the content for desktop
        child: Container(
          width:
              AppSizes.width(context) * 0.4, // CHANGED: Fixed width for desktop
          padding: const EdgeInsets.all(40), // CHANGED: Larger padding
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // CHANGED: Center vertically
            children: [
              Text(
                '🛡️ Stay Safe Online!',
                style: TextStyle(
                  fontSize: AppSizes.largeHeader(
                    context,
                  ), // CHANGED: Larger font for desktop
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32), // CHANGED: More spacing
              Image.asset(
                'assets/images/mascot.png',
                height:
                    AppSizes.height(context) *
                    0.25, // CHANGED: Fixed height for desktop
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              Text(
                "What's your name?",
                style: TextStyle(
                  fontSize: AppSizes.header(context), // CHANGED: Larger font
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                height: AppSizes.buttonHeight(context),
                // CHANGED: Better styling for desktop
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderColor),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _nameController,
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSizes.body(context),
                  ), // CHANGED: Larger text
                  decoration: InputDecoration(
                    hintText: "Type your name here...",
                    hintStyle: TextStyle(
                      color: AppColors.inactiveColor,
                      fontSize: AppSizes.smallBody(context),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20, // CHANGED: More padding
                    ),
                  ),
                  onSubmitted: (_) => _startQuiz(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // CHANGED: Fixed width button
                width: AppSizes.width(context) * 0.4,
                height: AppSizes.buttonHeight(
                  context,
                ), // CHANGED: Taller button
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3, // CHANGED: Add elevation
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: AppColors.surfaceColor)
                      : Text(
                          "Let's Start! 🚀",
                          style: TextStyle(
                            fontSize: AppSizes.body(
                              context,
                            ), // CHANGED: Larger font
                            fontWeight: FontWeight.w500,
                          ),
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

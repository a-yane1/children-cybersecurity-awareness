import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:children_cs_awareness_quiz/Widgets/topiccard.dart';
import '../../Widgets/colors.dart';
import '../../provider/quiz_provider.dart';
import '../Quiz/mobilequizscreen.dart';

class MobileCategoryScreen extends StatefulWidget {
  const MobileCategoryScreen({super.key});
  static const routeName = 'mobile-category';

  @override
  State<MobileCategoryScreen> createState() => _MobileCategoryScreenState();
}

class _MobileCategoryScreenState extends State<MobileCategoryScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to logout?'),
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
                _logout(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.clearUser(); // We'll need to add this method to QuizProvider

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: Text(
          "Categories",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textColor),
            onSelected: (String value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.textColor),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              final user = quizProvider.currentUser;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi ${user?.name ?? 'Friend'}! 👋",
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
                  const SizedBox(height: 16),

                  // User stats
                  if (user != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${user.totalPoints}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              Text('Points', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.blue.shade200,
                          ),
                          Column(
                            children: [
                              Text(
                                '${user.currentStreak}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              Text('Streak', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.blue.shade200,
                          ),
                          Column(
                            children: [
                              Text(
                                '${user.bestStreak}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              Text('Best', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: quizProvider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : quizProvider.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Error loading categories',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  quizProvider.error!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      quizProvider.loadCategories(),
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.8,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: quizProvider.categories.length,
                            itemBuilder: (context, index) {
                              final category = quizProvider.categories[index];
                              return TopicCard(
                                category: category,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MobileQuizScreen(
                                        categoryId: category.id,
                                        categoryName: category.name,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Surprise me button
                  ElevatedButton(
                    onPressed: quizProvider.categories.isNotEmpty
                        ? () {
                            final randomCategory = (List.from(
                              quizProvider.categories,
                            )..shuffle()).first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MobileQuizScreen(
                                  categoryId: randomCategory.id,
                                  categoryName: randomCategory.name,
                                ),
                              ),
                            );
                          }
                        : null,
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
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:children_cs_awareness_quiz/Widgets/desktop_topic_card.dart';
import 'package:children_cs_awareness_quiz/screens/badges/desktopbadges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/appsizes.dart';
import '../../Widgets/colors.dart';
import '../../provider/quiz_provider.dart';
import '../Quiz/desktopquizscreen.dart';

class DesktopCategoryScreen extends StatelessWidget {
  const DesktopCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Padding(
        padding: const EdgeInsets.all(
          32,
        ), // CHANGED: Larger padding for desktop
        child: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            final user = quizProvider.currentUser;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header Section
                Row(
                  // CHANGED: Horizontal layout for desktop
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi ${user?.name ?? 'Friend'}! 👋",
                            style: TextStyle(
                              fontSize: AppSizes.largeHeader(
                                context,
                              ), // CHANGED: Larger font
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "What do you want to learn about?",
                            style: TextStyle(
                              fontSize: AppSizes.body(
                                context,
                              ), // CHANGED: Larger font
                              color: AppColors.inactiveColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.width(context) * 0.3,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(
                                  width: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: AppSizes.body(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DesktopBadges(),
                                ),
                              );
                            },
                            child: Text(
                              'Badges',
                              style: TextStyle(
                                color: AppColors.inactiveColor,
                                fontSize: AppSizes.body(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // User stats moved to the right
                    if (user != null)
                      Container(
                        width:
                            AppSizes.width(context) *
                            0.3, // CHANGED: Fixed width for desktop
                        padding: EdgeInsets.all(24), // CHANGED: More padding
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // CHANGED: Larger radius
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
                                    fontSize: AppSizes.mediumHeader(
                                      context,
                                    ), // CHANGED: Larger font
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  'Total Points',
                                  style: TextStyle(
                                    fontSize: AppSizes.smallBody(
                                      context,
                                    ), // CHANGED: Larger font
                                    color: AppColors.inactiveColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50, // CHANGED: Taller divider
                              width: 1,
                              color: Colors.blue.shade300,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${user.currentStreak}',
                                  style: TextStyle(
                                    fontSize: AppSizes.mediumHeader(
                                      context,
                                    ), // CHANGED: Larger font
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.successColor,
                                  ),
                                ),
                                Text(
                                  'Day Streak',
                                  style: TextStyle(
                                    fontSize: AppSizes.smallBody(
                                      context,
                                    ), // CHANGED: Larger font
                                    color: AppColors.inactiveColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50, // CHANGED: Taller divider
                              width: 1,
                              color: Colors.blue.shade300,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${user.bestStreak}',
                                  style: TextStyle(
                                    fontSize: AppSizes.mediumHeader(context),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                Text(
                                  'Best',
                                  style: TextStyle(
                                    fontSize: AppSizes.smallBody(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40), // CHANGED: More spacing
                // Categories Grid
                Expanded(
                  child: FutureBuilder(
                    future: quizProvider.categories.isEmpty
                        ? quizProvider.loadCategories()
                        : Future.value(),
                    builder: (context, snapshot) {
                      if (quizProvider.isLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading categories...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      if (quizProvider.categories.isEmpty) {
                        return Center(
                          child: Text(
                            'No categories available',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return GridView.builder(
                        // CHANGED: Better grid for desktop
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              4, // CHANGED: More columns for desktop
                          childAspectRatio: 1, // CHANGED: Better aspect ratio
                          crossAxisSpacing: 24, // CHANGED: More spacing
                          mainAxisSpacing: 24,
                        ),
                        itemCount: quizProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = quizProvider.categories[index];
                          return DesktopTopicCard(
                            category: category,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DesktopQuizScreen(
                                    categoryId: category.id,
                                    categoryName: category.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

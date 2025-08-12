import 'package:children_cs_awareness_quiz/Widgets/appsizes.dart';
import 'package:children_cs_awareness_quiz/screens/Categories/desktopcategoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:children_cs_awareness_quiz/Widgets/colors.dart';
import '../../models/badges.dart';
import '../../provider/quiz_provider.dart';

class DesktopBadges extends StatefulWidget {
  const DesktopBadges({super.key});

  @override
  State<DesktopBadges> createState() => _DesktopBadgesState();
}

class _DesktopBadgesState extends State<DesktopBadges> {
  List<Badges> allBadges = [];
  List<Badges> earnedBadges = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    try {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final userId = quizProvider.currentUser?.id;

      if (userId != null) {
        final progress = await quizProvider.loadProgress();
        if (progress != null) {
          setState(() {
            earnedBadges = progress.earnedBadges;
            allBadges = progress.allBadges;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Padding(
        // CHANGED: Remove AppBar, use body padding
        padding: const EdgeInsets.all(
          32,
        ), // CHANGED: Larger padding for desktop
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              // CHANGED: Horizontal layout with stats
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: AppSizes.width(context) * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Badges 🏆',
                        style: GoogleFonts.sofiaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.mediumHeader(
                            context,
                          ), // CHANGED: Larger font
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Collect badges by completing quizzes and achieving milestones!',
                        style: TextStyle(
                          fontSize: AppSizes.smallBody(
                            context,
                          ), // CHANGED: Larger font
                          color: AppColors.inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: AppSizes.width(context) * 0.3,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DesktopCategoryScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: AppColors.inactiveColor,
                            fontSize: AppSizes.body(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),

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
                          'Badges',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: AppSizes.body(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge stats
                Container(
                  padding: EdgeInsets.all(24), // CHANGED: More padding
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${earnedBadges.length}/${allBadges.length}',
                        style: TextStyle(
                          fontSize: 28, // CHANGED: Larger font
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        'Badges Earned',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32), // CHANGED: More spacing
            // Content
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 6,
                          ), // CHANGED: Thicker
                          SizedBox(height: 24),
                          Text(
                            'Loading badges...',
                            style: TextStyle(
                              fontSize: 18,
                            ), // CHANGED: Larger font
                          ),
                        ],
                      ),
                    )
                  : error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80, // CHANGED: Larger icon
                            color: AppColors.errorColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error loading badges',
                            style: TextStyle(
                              fontSize: 20, // CHANGED: Larger font
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            error!,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : allBadges.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 80,
                            color: AppColors.inactiveColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No badges available yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complete quizzes to start earning badges!',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      // CHANGED: Better grid layout for desktop
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // CHANGED: More columns for desktop
                        childAspectRatio: 1.2, // CHANGED: Better aspect ratio
                        crossAxisSpacing: 24, // CHANGED: More spacing
                        mainAxisSpacing: 24,
                      ),
                      itemCount: allBadges.length,
                      itemBuilder: (context, index) {
                        final badge = allBadges[index];
                        final isEarned = earnedBadges.any(
                          (earned) => earned.id == badge.id,
                        );

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isEarned
                                  ? Colors.green.shade200
                                  : AppColors.borderColor,
                              width: isEarned ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: isEarned ? 8 : 4,
                                offset: Offset(0, isEarned ? 4 : 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(
                            20,
                          ), // CHANGED: More padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Badge icon/emoji
                              Container(
                                width: 80, // CHANGED: Larger for desktop
                                height: 80,
                                decoration: BoxDecoration(
                                  color: isEarned
                                      ? Colors.green.shade100
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    badge.icon ?? '🏆',
                                    style: TextStyle(
                                      fontSize: 40, // CHANGED: Larger emoji
                                      color: isEarned ? null : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16), // CHANGED: More spacing
                              // Badge name
                              Text(
                                badge.name,
                                style: TextStyle(
                                  fontSize: AppSizes.body(
                                    context,
                                  ), // CHANGED: Larger font
                                  fontWeight: FontWeight.bold,
                                  color: isEarned
                                      ? AppColors.textColor
                                      : AppColors.inactiveColor,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: 8),

                              // Badge description
                              Text(
                                badge.description,
                                style: TextStyle(
                                  fontSize: AppSizes.smallBody(context),
                                  color: isEarned
                                      ? AppColors.inactiveColor
                                      : Colors.grey.shade400,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: 12),

                              // Earned indicator
                              if (isEarned)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'EARNED',
                                    style: TextStyle(
                                      fontSize: AppSizes.littleBody(context),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'LOCKED',
                                    style: TextStyle(
                                      fontSize: AppSizes.littleBody(context),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

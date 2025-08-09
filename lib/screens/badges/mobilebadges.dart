import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:children_cs_awareness_quiz/Widgets/colors.dart';

import '../../models/badges.dart';
import '../../provider/quiz_provider.dart';

class MobileBadges extends StatefulWidget {
  const MobileBadges({super.key});

  @override
  State<MobileBadges> createState() => _MobileBadgesState();
}

class _MobileBadgesState extends State<MobileBadges> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Badges',
          style: GoogleFonts.sofiaSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appbarColor,

        // Show different actions based on context
      ),
      backgroundColor: AppColors.surfaceColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading badges'),
                  SizedBox(height: 8),
                  Text(error!, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed: _loadBadges, child: Text('Retry')),
                ],
              ),
            )
          : Column(
              children: [
                // Celebration banner for new badges
                if (earnedBadges.isNotEmpty)
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 40)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Congratulations!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.surfaceColor,
                                ),
                              ),
                              Text(
                                'You\'ve earned ${earnedBadges.length} badge${earnedBadges.length == 1 ? '' : 's'}!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.surface1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Stats header
                Container(
                  margin: EdgeInsets.all(16),
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
                            '${earnedBadges.length}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          Text('Earned', style: TextStyle(fontSize: 12)),
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
                            '${allBadges.length}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text('Total', style: TextStyle(fontSize: 12)),
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
                            '${allBadges.isEmpty ? 0 : ((earnedBadges.length / allBadges.length) * 100).round()}%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text('Complete', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Badges grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allBadges.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemBuilder: (_, index) {
                      final badge = allBadges[index];
                      final isEarned = badge.isEarned;

                      return Container(
                        decoration: BoxDecoration(
                          color: isEarned
                              ? Colors.yellow.shade50
                              : AppColors.surface1,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isEarned
                                ? Colors.yellow.shade300
                                : AppColors.borderColor,
                            width: isEarned ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isEarned
                                  ? Colors.yellow.withOpacity(0.2)
                                  : Colors.black12,
                              blurRadius: isEarned ? 8 : 4,
                              offset: Offset(0, isEarned ? 4 : 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Badge icon
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isEarned
                                    ? Colors.yellow.shade100
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  badge.icon,
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: isEarned ? null : Colors.grey,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Badge name
                            Text(
                              badge.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isEarned
                                    ? AppColors.textColor
                                    : AppColors.inactiveColor,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Badge description
                            Expanded(
                              child: Text(
                                badge.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isEarned
                                      ? AppColors.textColor
                                      : AppColors.inactiveColor,
                                ),
                              ),
                            ),

                            // Earned date (if earned)
                            if (isEarned && badge.earnedAt != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Earned!',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Keep learning!',
                                  style: TextStyle(
                                    fontSize: 10,
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
    );
  }
}

import 'package:children_cs_awareness_quiz/Widgets/colors.dart';
import 'package:children_cs_awareness_quiz/models/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/badgedata.dart';

class MobileBadges extends StatefulWidget {
  const MobileBadges({super.key});

  @override
  State<MobileBadges> createState() => _MobileBadgesState();
}

class _MobileBadgesState extends State<MobileBadges> {
  List<Badges> allBadges = [];

  @override
  void initState() {
    super.initState();
    final unlocked =
        Hive.box('userBox').get('badges', defaultValue: <String>[]) as List;

    allBadges = defaultBadges
        .map(
          (b) => Badges(
            id: b.id,
            name: b.name,
            image: b.image,
            description: b.description,
            isUnlocked: unlocked.contains(b.id),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Badges',
          style: GoogleFonts.sofiaSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appbarColor,
      ),
      backgroundColor: AppColors.surfaceColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allBadges.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (_, index) {
          final badge = allBadges[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/${badge.image}.png',
                    height: 80,
                    color: badge.isUnlocked ? null : AppColors.inactiveColor,
                  ),
                  const Spacer(),
                  Text(
                    badge.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: badge.isUnlocked
                          ? AppColors.textColor
                          : AppColors.inactiveColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: badge.isUnlocked
                          ? AppColors.textColor
                          : AppColors.inactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:children_cs_awareness_quiz/screens/badges/desktopbadges.dart';
import 'package:children_cs_awareness_quiz/screens/badges/mobilebadges.dart';
import 'package:flutter/material.dart';

class ResponsiveBadges extends StatelessWidget {
  const ResponsiveBadges({super.key});

  static const String routeName = '/responsive-Badges';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return const DesktopBadges();
        } else {
          return MobileBadges();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'mobilewelcomescreen.dart';
import 'desktopwelcomescreen.dart';

class ResponsiveWelcomeScreen extends StatelessWidget {
  const ResponsiveWelcomeScreen({super.key});

  static const String routeName = '/responsive-Welcome';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return const DesktopWelcomeScreen();
        } else {
          return const MobileWelcomeScreen();
        }
      },
    );
  }
}

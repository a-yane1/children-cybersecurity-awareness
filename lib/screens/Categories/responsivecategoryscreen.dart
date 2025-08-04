import 'package:flutter/material.dart';
import 'desktopcategoryscreen.dart';
import 'mobilecategoryscreen.dart';

class ResponsiveCategoryScreen extends StatelessWidget {
  const ResponsiveCategoryScreen({super.key});

  static const String routeName = '/responsive-Category';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return const DesktopCategoryScreen();
        } else {
          return MobileCategoryScreen();
        }
      },
    );
  }
}

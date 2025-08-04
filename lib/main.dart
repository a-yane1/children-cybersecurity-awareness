import 'package:children_cs_awareness_quiz/screens/Categories/mobilecategoryscreen.dart';
import 'package:children_cs_awareness_quiz/screens/Categories/responsivecategoryscreen.dart';
import 'package:children_cs_awareness_quiz/screens/Quiz/responsivequizscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'screens/Welcome/responsivewelcomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox'); // Single box for user data
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HackAware',
      theme: ThemeData(
        textTheme: GoogleFonts.signikaTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => ResponsiveWelcomeScreen(),
        ResponsiveCategoryScreen.routeName: (context) =>
            ResponsiveCategoryScreen(),
        ResponsiveQuizScreen.routeName: (context) => ResponsiveQuizScreen(),
        MobileCategoryScreen.routeName: (context) => MobileCategoryScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';

class AppSizes {
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double largeHeader(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.05;
  static double mediumHeader(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.04;
  static double header(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.03;
  static double body(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.025;
  static double smallBody(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.02;
  static double littleBody(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.015;
  static double buttonHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.08;
}

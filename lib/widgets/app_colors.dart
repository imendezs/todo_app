import 'package:flutter/material.dart';

class AppColors {
  static late Color colorOne;
  static late Color colorTwo;
  static late Color colorThree;
  static late Color colorFour;
  static late Color title;
  static late Color subtitle;
  static late Color subtitle2;
  static late Color alertRed;
  static late Color alertGreen;
  static late Color alertAmber;

  static void initializeColors(ThemeMode themeMode) {
    bool isDarkMode = themeMode == ThemeMode.dark;

    colorOne = isDarkMode ? Color(0xFF1b263b) : Colors.white;
    colorTwo = const Color(0xFF00BF6D);
    colorThree = isDarkMode ? Colors.white : Colors.black;
    colorFour = Colors.white;
    title = isDarkMode ? Colors.white54 : Colors.black54;
    subtitle = isDarkMode ? Colors.white38 : Colors.black38;
    subtitle2 = isDarkMode ? Colors.white24 : Colors.black26;
    alertRed = Colors.redAccent;
    alertGreen = const Color(0xFF00BF6D);
    alertAmber = Colors.amber;
  }
}

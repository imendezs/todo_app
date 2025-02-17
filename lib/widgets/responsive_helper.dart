import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;
  late double screenWidth;
  late double screenHeight;
  late bool isTablet;
  late bool isLargeScreen;

  ResponsiveHelper(this.context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    isTablet = screenWidth > 600;
    isLargeScreen = screenWidth > 900;
  }

  // Tamaños de texto
  double get textSmall => isLargeScreen ? 18 : screenWidth * 0.035;
  double get textMedium => isLargeScreen ? 22 : screenWidth * 0.045;
  double get textLarge => isLargeScreen ? 28 : screenWidth * 0.055;
  double get textExtraLarge => isLargeScreen ? 34 : screenWidth * 0.07;

  // Espaciados y márgenes
  double get paddingSmall => screenWidth * 0.02;
  double get paddingMedium => screenWidth * 0.04;
  double get paddingLarge => screenWidth * 0.06;

  // Tamaños de contenedores
  double get containerSmall => screenHeight * 0.1;
  double get containerMedium => screenHeight * 0.2;
  double get containerLarge => screenHeight * 0.3;

  double get containerWidthSmall => screenWidth * 0.3;
  double get containerWidthMedium => screenWidth * 0.5;
  double get containerWidthLarge => screenWidth * 0.8;

  double get containerHeightSmall => screenHeight * 0.1;
  double get containerHeightMedium => screenHeight * 0.2;
  double get containerHeightLarge => screenHeight * 0.3;

  // Radio de bordes
  double get borderRadiusSmall => 8;
  double get borderRadiusMedium => 16;
  double get borderRadiusLarge => 24;

  // Tamaño de iconos
  double get iconSmall => isLargeScreen ? 30 : 20;
  double get iconMedium => isLargeScreen ? 40 : 28;
  double get iconLarge => isLargeScreen ? 50 : 36;
  double get iconLogo => isLargeScreen ? 100 : 200;

  // Altura de botones
  double get buttonHeightSmall => isLargeScreen ? 50 : 40;
  double get buttonHeightMedium => isLargeScreen ? 60 : 50;
  double get buttonHeightLarge => isLargeScreen ? 70 : 60;

  // Espaciado entre elementos
  double get spacingSmall => screenWidth * 0.015;
  double get spacingMedium => screenWidth * 0.03;
  double get spacingLarge => screenWidth * 0.05;

  // Método de escala general
  double scale(double size) => isLargeScreen ? size * 1.2 : size;
}

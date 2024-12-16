import 'package:flutter/material.dart';

class KNavigationBarTheme {
  KNavigationBarTheme._();

  // Light navigation bar theme
  static NavigationBarThemeData kLightNavigationBarTheme =
      const NavigationBarThemeData(
    height: 60,
    indicatorColor: Colors.transparent,
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );

  // Dark navigation bar theme
  static NavigationBarThemeData kDarkNavigationBarTheme =
      const NavigationBarThemeData(
    height: 60,
    indicatorColor: Colors.transparent,
    backgroundColor: Color(0xFF111111),
    elevation: 0,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );
}
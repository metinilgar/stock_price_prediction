import 'package:flutter/material.dart';

class KAppBarTheme {
  KAppBarTheme._();

  // Light AppBar theme
  static AppBarTheme kLightAppBarTheme = const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    surfaceTintColor: Colors.transparent,
  );

  // Dark AppBar theme
  static AppBarTheme kDarkAppBarTheme = const AppBarTheme(
    backgroundColor: Color(0xFF111111),
    surfaceTintColor: Colors.transparent,
  );
}

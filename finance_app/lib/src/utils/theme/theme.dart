import 'package:finance_app/src/utils/constants/colors.dart';
import 'package:finance_app/src/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:flutter/material.dart';

class KAppTheme {
  KAppTheme._();

  // Light theme
  static ThemeData kLightTheme = ThemeData.light(useMaterial3: true).copyWith(
    // Scaffold background color
    scaffoldBackgroundColor: KColors.kLightColor,

    // Color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: KColors.kLightColor,
      brightness: Brightness.light,
    ),

    // AppBar theme
    // appBarTheme: KAppBarTheme.kLightAppBarTheme,

    // Navigation bar theme
    // navigationBarTheme: KNavigationBarTheme.kLightNavigationBarTheme,

    // ElevatedButton theme
    elevatedButtonTheme: KElevatedButtonTheme.kLightElevatedButtonTheme,
  );

  // Dark theme
  static ThemeData kDarkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    // Scaffold background color
    scaffoldBackgroundColor: KColors.kDarkColor,

    // Color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: KColors.kDarkColor,
      brightness: Brightness.dark,
    ),

    // AppBar theme
    // appBarTheme: KAppBarTheme.kDarkAppBarTheme,

    // Navigation bar theme
    // navigationBarTheme: KNavigationBarTheme.kDarkNavigationBarTheme,

    // ElevatedButton theme
    elevatedButtonTheme: KElevatedButtonTheme.kDarkElevatedButtonTheme,
  );
}

import 'package:finance_app/src/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class KElevatedButtonTheme {
  KElevatedButtonTheme._();

  // Light ElevatedButtonTheme
  static ElevatedButtonThemeData kLightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // Shape
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),

      // Elevation
      elevation: 0,

      // Colors
      backgroundColor: KColors.kDarkColor,
      foregroundColor: KColors.kLightColor,
    ),
  );

  // Dark ElevatedButtonTheme
  static ElevatedButtonThemeData kDarkElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // Shape
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),

      // Elevation
      elevation: 0,

      // Colors
      backgroundColor: KColors.kLightColor,
      foregroundColor: KColors.kDarkColor,
    ),
  );
}
import 'package:finance_app/src/features/stock_chart/presentation/stock_chart_screen.dart';
import 'package:finance_app/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Light theme
      theme: KAppTheme.kLightTheme,

      // Dark theme
      darkTheme: KAppTheme.kDarkTheme,

      home: const StockChartScreen(),
    );
  }
}

import 'package:finance_app/src/screens/stock_chart_page.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StockChartPage(),
    );
  }
}

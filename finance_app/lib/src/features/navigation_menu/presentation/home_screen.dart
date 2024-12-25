import 'package:finance_app/src/features/navigation_menu/presentation/widgets/followed_stocks.dart';
import 'package:finance_app/src/features/navigation_menu/presentation/widgets/home_slider.dart';
import 'package:finance_app/src/features/navigation_menu/presentation/widgets/market_overview.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          // Home Slider
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: HomeSlider(),
            ),
          ),

          // Market Overview and Followed Stocks
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Market Overview
                  MarketOverview(),
                  SizedBox(height: 24),

                  // Followed Stocks
                  FollowedStocks(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

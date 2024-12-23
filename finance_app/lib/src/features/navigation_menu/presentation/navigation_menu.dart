import 'package:finance_app/src/features/navigation_menu/presentation/controllers/navigation_controller.dart';
import 'package:finance_app/src/features/navigation_menu/presentation/home_screen.dart';
import 'package:finance_app/src/features/search_stocks/presentation/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationMenu extends ConsumerWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    int selectedIndex = ref.watch(navigationControllerProvider);

    const List<Widget> screens = [
      HomeScreen(),
      SearchScreen(),
    ];

    const List<NavigationDestination> destinations = [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.search),
        selectedIcon: Icon(
          Icons.search,
          shadows: <Shadow>[Shadow(blurRadius: 2.0)],
        ),
        label: 'Search',
      ),
    ];

    return Scaffold(
      appBar: selectedIndex == 0
          ? AppBar(
              title: const Text("FinTech App"),
            )
          : null,

      // Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(navigationControllerProvider.notifier).changeScreen(index);
        },
        destinations: destinations,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
    );
  }
}

import 'package:finance_app/src/features/authentication/data/auth_repository.dart';
import 'package:finance_app/src/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:finance_app/src/features/stock_chart/presentation/stock_chart_screen.dart';
import 'package:finance_app/src/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Light theme
      theme: KAppTheme.kLightTheme,

      // Dark theme
      darkTheme: KAppTheme.kDarkTheme,

      home: StreamBuilder<User?>(
        stream: authRepository.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state (opsiyonel)
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // Kullanıcı giriş yapmışsa StockChartScreen göster
            return const StockChartScreen();
          } else {
            // Kullanıcı giriş yapmamışsa SignInScreen göster
            return const SignInScreen();
          }
        },
      ),
    );
  }
}

// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'utils/constants.dart';

// Variables used in this file
// WidgetsFlutterBinding.ensureInitialized - Ensures that the Flutter framework is properly initialized
// runApp - Starts the Flutter application
// LaborMarketplaceApp - Root widget configuring theme and navigation

/// 🚀 Main application entry point.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LaborMarketplaceApp());
}

/// 🎯 LaborMarketplaceApp: Root widget configuring theme and navigation.
class LaborMarketplaceApp extends StatelessWidget {
  const LaborMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labor Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.accentOrange,
        ),
        scaffoldBackgroundColor: AppColors.backgroundGray,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text(
              'Route ${settings.name} not found 🚧',
              style: const TextStyle(color: AppColors.errorRed),
            ),
          ),
        ),
      ),
    );
  }
}

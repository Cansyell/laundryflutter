import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'screens/home/home_screen.dart';

void main() => runApp(const LalaLaundryApp());

class LalaLaundryApp extends StatelessWidget {
  const LalaLaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lala Laundry',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
          primary: AppColors.primary,
        ),
      ),
      home: const HomeScreen(),
      // optional routes:
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}

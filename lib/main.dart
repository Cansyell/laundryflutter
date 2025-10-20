import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
// import 'screens/auth/auth_service.dart';

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
      home: const AuthMiddleware(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const WelcomePage(),
      },
    );
  }
}

// 🧭 Middleware Auth
class AuthMiddleware extends StatefulWidget {
  const AuthMiddleware({super.key});

  @override
  State<AuthMiddleware> createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends State<AuthMiddleware> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sementara tampilkan splash/loading
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

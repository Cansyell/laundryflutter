// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

// Import controllers
import 'controllers/login_controller.dart'; 
import 'controllers/forgot_password_controller.dart'; 
import 'controllers/register_controller.dart'; 

// Import screens
import 'screens/splash/splash_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/forgot_password_page.dart';
import 'screens/auth/register_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    debugPrint('Error loading .env: $e');
  }

  // ✅ Daftarkan controller secara lazy
  Get.lazyPut<LoginController>(() => LoginController());

  runApp(const WashInApp());
}

class WashInApp extends StatelessWidget {
  const WashInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'wash.in',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D5A80),
          background: Colors.white,
          primary: const Color(0xFF3D5A80),
        ),
      ),
      
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginPage()), // ✅
    
        GetPage(name: '/home', page: () => const HomeScreen()),
        

        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordPage(),
          binding: BindingsBuilder(() {
            Get.put<ForgotPasswordController>(ForgotPasswordController());
          }),
        ),

        GetPage(
          name: '/register',
          page: () => const RegisterPage(),
          binding: BindingsBuilder(() {
            Get.put<RegisterController>(RegisterController());
          }),
        ),

      ],
    );
  }
}

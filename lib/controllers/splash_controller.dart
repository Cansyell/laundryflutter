// lib/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Simulasi delay splash (opsional, bisa dihapus jika tidak perlu)
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;

    // Navigasi berdasarkan status login
    if (_isLoggedIn.value) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/welcome');
    }
  }
}
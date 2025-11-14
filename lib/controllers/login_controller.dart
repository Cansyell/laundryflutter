import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../screens/home/home_screen.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  var obscurePassword = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Validasi Gagal",
        "Email dan password tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Validasi Gagal",
        "Format email tidak valid",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    isLoading(true);
    try {
      final response = await _apiService.login(email, password);

      if (response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', response['data']['token'] ?? '');
        await prefs.setString('userEmail', response['data']['user']['email'] ?? '');
        await prefs.setString('userName', response['data']['user']['name'] ?? '');
        await prefs.setInt('user_id', response['data']['user']['id'] ?? 0); // <- PENTING

        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar(
          "Login Gagal",
          response['message'] ?? "Email atau password salah",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal terhubung ke server. Periksa koneksi internet Anda",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
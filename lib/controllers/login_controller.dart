// lib/controllers/login_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../screens/home/home_screen.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  // UI State
  var obscurePassword = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading state
  var isLoading = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Login logic
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validasi input
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

    // Validasi format email
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

      // Print response untuk debugging
      print('=== LOGIN RESPONSE ===');
      print('Full Response: $response');
      print('Success: ${response['success']}');
      print('Message: ${response['message']}');
      print('Token: ${response['data']['token']}');
      print('User: ${response['data']['user']}');
      print('======================');

      if (response['success'] == true) {
        // Simpan data ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', response['data']['token'] ?? '');
        await prefs.setString('userEmail', response['data']['user']['email'] ?? '');
        await prefs.setString('userName', response['data']['user']['name'] ?? '');

        print('=== DATA SAVED ===');
        print('Token saved: ${response['data']['token']}');
        print('Email saved: ${response['data']['user']['email']}');
        print('Name saved: ${response['data']['user']['name']}');
        print('==================');

        // Navigasi ke HomeScreen
        Get.offAll(() => const HomeScreen());
      } 
      else {
        // Login gagal - print detail error
        print('=== LOGIN FAILED ===');
        print('Reason: ${response['message']}');
        print('====================');
        
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
      // Error koneksi atau server
      print('=== LOGIN EXCEPTION ===');
      print('Error: $e');
      print('Error Type: ${e.runtimeType}');
      print('=======================');
      
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
// lib/controllers/register_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validasi
    if (name.isEmpty) {
      Get.snackbar('Peringatan', 'Nama lengkap tidak boleh kosong');
      return;
    }
    if (email.isEmpty) {
      Get.snackbar('Peringatan', 'Email tidak boleh kosong');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Peringatan', 'Format email tidak valid');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      Get.snackbar('Peringatan', 'Password minimal 6 karakter');
      return;
    }

    isLoading.value = true;
    update();

    try {
      // TODO: Panggil API registrasi (misal ke Laravel /register)
      // Contoh: await ApiService().register(name, email, password);

      await Future.delayed(const Duration(seconds: 2)); // Simulasi

      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat! Silakan login.',
        backgroundColor: const Color(0xFF3D5A80),
        colorText: Colors.white,
      );

      // Arahkan ke login
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendaftar: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
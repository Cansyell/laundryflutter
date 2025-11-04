// lib/controllers/forgot_password_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> sendResetLink() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Peringatan', 'Email tidak boleh kosong');
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Peringatan', 'Format email tidak valid');
      return;
    }

    isLoading.value = true;
    update();

    try {
      // TODO: Panggil API untuk kirim reset password (misalnya ke Laravel)
      // Contoh: await ApiService().sendPasswordResetEmail(emailController.text);

      await Future.delayed(const Duration(seconds: 2)); // Simulasi API

      Get.snackbar(
        'Berhasil',
        'Link reset kata sandi telah dikirim ke email Anda',
        backgroundColor: const Color(0xFF3D5A80),
        colorText: Colors.white,
      );

      // Opsional: kembali ke halaman login
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim link reset: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
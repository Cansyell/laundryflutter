// lib/controllers/category_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../model/category_model.dart';

class CategoryController extends GetxController {
  final ApiService _apiService = ApiService();

  final nameController = TextEditingController();
  var selectedUnit = ''.obs;
  var isSubmitting = false.obs;

  // Untuk halaman daftar
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  final List<String> units = ['PCS', 'KG', 'METER', 'LOAD'];

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        Get.snackbar("Error", "Token tidak ditemukan. Silakan login ulang.");
        return;
      }

      final List<CategoryModel> data = await _apiService.getCategories(token);
      categories.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat kategori: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> createCategory() async {
    final name = nameController.text.trim();
    final type = selectedUnit.value;

    if (name.isEmpty || type.isEmpty) {
      Get.snackbar("Validasi", "Nama dan satuan wajib diisi");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar("Error", "Token tidak ditemukan. Silakan login ulang.");
      return;
    }

    isSubmitting(true);
    try {
      final category = CategoryModel(name: name, type: type);
      await _apiService.createCategory(category, token);
      
      await fetchCategories(); // refresh list
      Get.back(); 
      Get.snackbar("Sukses", "Kategori berhasil ditambahkan", backgroundColor: const Color.fromARGB(255, 14, 44, 75), colorText: Colors.white);// kembali ke halaman daftar
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> updateCategory(String id) async {
    final name = nameController.text.trim();
    final type = selectedUnit.value;

    if (name.isEmpty || type.isEmpty) {
      Get.snackbar("Validasi", "Nama dan satuan wajib diisi");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar("Error", "Token tidak ditemukan. Silakan login ulang.");
      return;
    }

    isSubmitting(true);
    try {
      final category = CategoryModel(id: id, name: name, type: type);
      await _apiService.updateCategory(category, token);
      
      await fetchCategories(); // refresh list
      Get.back(); // kembali ke halaman daftar
      Get.snackbar("Sukses", "Kategori berhasil diperbarui", backgroundColor: const Color.fromARGB(255, 14, 44, 75), colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui kategori: $e", backgroundColor: const Color.fromARGB(255, 42, 10, 5), colorText: Colors.white);
    } finally {
      isSubmitting(false);
    }
  }

  // Tambahkan method ini di dalam class CategoryController

  Future<void> deleteCategory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar("Error", "Token tidak ditemukan. Silakan login ulang.");
      return;
    }

    try {
      await _apiService.deleteCategory(id, token);
      await fetchCategories(); // refresh list
      Get.back(); // kembali ke halaman daftar
      Get.snackbar("Berhasil", "Kategori berhasil dihapus", backgroundColor: const Color.fromARGB(255, 14, 44, 75), colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus kategori: $e", backgroundColor: const Color.fromARGB(255, 42, 10, 5), colorText: Colors.white);
    }
  }
  // Opsional: reset form
  void resetForm() {
    nameController.clear();
    selectedUnit.value = '';
  }
}
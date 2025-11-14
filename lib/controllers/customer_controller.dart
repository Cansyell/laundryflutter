// lib/controllers/customer_controller.dart
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';
import '../model/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerController extends GetxController {
  final ApiService _apiService = ApiService();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  var isSubmitting = false.obs;

  // Untuk halaman daftar
  var customers = <CustomerModel>[].obs;
  var isLoading = false.obs;

  // 🔹 Tambahkan variabel pencarian sebagai RxString
  var searchQuery = ''.obs;

  // 🔹 Getter untuk hasil pencarian
  List<CustomerModel> get filteredCustomers => searchQuery.isEmpty
      ? customers
      : customers.where((customer) {
          final name = (customer.name ?? '').toLowerCase();
          final phone = (customer.phone ?? '').toLowerCase();
          final address = (customer.address ?? '').toLowerCase();
          final query = searchQuery.value.toLowerCase();
          return name.contains(query) ||
              phone.contains(query) ||
              address.contains(query);
        }).toList();

  @override
  void onInit() {
    fetchCustomers();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchCustomers() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        Get.snackbar("Error", "Token tidak ditemukan. Silakan login ulang.");
        return;
      }

      final List<CustomerModel> data = await _apiService.getCustomers(token);
      customers.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Gagal memuat data pelanggan: ${e.toString().split(':').first}",
        backgroundColor: const Color.fromARGB(255, 42, 10, 5),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> createCustomer() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Validasi", "Nama wajib diisi");
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
      final customer = CustomerModel(
        name: name,
        phone: phone.isNotEmpty ? phone : null,
        address: address.isNotEmpty ? address : null,
      );
      await _apiService.createCustomer(customer, token);

      await fetchCustomers();
      
      resetForm();
      // 🔹 Lebih aman: kembali ke halaman sebelumnya, bukan `Get.back()` langsung
      if (Get.isDialogOpen!) Get.back(); // tutup dialog dulu jika ada
      Get.back(); // kembali dari form

      Get.snackbar(
        "✅ Sukses",
        "Pelanggan berhasil ditambahkan",
        backgroundColor: const Color.fromARGB(255, 14, 44, 75),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "❌ Error",
        "Gagal menyimpan: ${e.toString().split(':').first}",
        backgroundColor: const Color.fromARGB(255, 42, 10, 5),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> updateCustomer(String id) async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Validasi", "Nama wajib diisi");
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
      final customer = CustomerModel(
        id: id,
        name: name,
        phone: phone.isNotEmpty ? phone : null,
        address: address.isNotEmpty ? address : null,
      );
      await _apiService.updateCustomer(customer, token);

      await fetchCustomers();
      resetForm();

      if (Get.isDialogOpen!) Get.back();
      Get.back();

      Get.snackbar(
        "✅ Sukses",
        "Pelanggan berhasil diperbarui",
        backgroundColor: const Color.fromARGB(255, 14, 44, 75),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "❌ Error",
        "Gagal memperbarui: ${e.toString().split(':').first}",
        backgroundColor: const Color.fromARGB(255, 42, 10, 5),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> deleteCustomer(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar("Error", "Token tidak ditemukan. Silakan login ulang.");
      return;
    }

    try {
      await _apiService.deleteCustomer(id, token);
      await fetchCustomers();

      Get.snackbar(
        "✅ Berhasil",
        "Pelanggan berhasil dihapus",
        backgroundColor: const Color.fromARGB(255, 14, 44, 75),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "❌ Error",
        "Gagal menghapus: ${e.toString().split(':').first}",
        backgroundColor: const Color.fromARGB(255, 42, 10, 5),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }
}
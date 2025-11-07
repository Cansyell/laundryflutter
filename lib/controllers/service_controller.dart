// lib/controllers/service_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../model/service_model.dart';
import '../model/category_model.dart';

class ServiceController extends GetxController {
  final ApiService _apiService = ApiService();

  // Form controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final minOrderController = TextEditingController();
  final estimateNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observables
  var selectedCategory = Rxn<CategoryModel>();
  var selectedEstimateUnit = 'Hari'.obs;
  var isSubmitting = false.obs;

  // Untuk halaman daftar
  var services = <ServiceModel>[].obs;
  var isLoading = false.obs;

  // Untuk dropdown kategori
  var categories = <CategoryModel>[].obs;
  var isCategoriesLoading = false.obs;

  final List<String> estimateUnits = ['Hari', 'Jam'];

  @override
  void onInit() {
    fetchServices();
    fetchCategoriesForDropdown();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    discountController.dispose();
    minOrderController.dispose();
    estimateNumberController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Helper function untuk safe parsing double
  double _parseDouble(String? value, {double defaultValue = 0.0}) {
    if (value == null || value.isEmpty) return defaultValue;
    
    // Remove any whitespace and convert comma to dot
    final cleanValue = value.trim().replaceAll(',', '.');
    
    try {
      return double.parse(cleanValue);
    } catch (e) {
      print('Error parsing double from "$value": $e');
      return defaultValue;
    }
  }

  // Helper function untuk safe parsing int
  int _parseInt(String? value, {int defaultValue = 1}) {
    if (value == null || value.isEmpty) return defaultValue;
    
    try {
      return int.parse(value.trim());
    } catch (e) {
      print('Error parsing int from "$value": $e');
      return defaultValue;
    }
  }

  Future<void> fetchServices() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        Get.snackbar(
          "Error", 
          "Token tidak ditemukan. Silakan login ulang.",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final List<ServiceModel> data = await _apiService.getServices(token);
      services.assignAll(data);
      print('✅ Successfully loaded ${data.length} services');
    } catch (e) {
      print('❌ Error fetching services: $e');
      Get.snackbar(
        "Error", 
        "Gagal memuat layanan: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategoriesForDropdown() async {
    isCategoriesLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        Get.snackbar(
          "Error", 
          "Token tidak ditemukan. Silakan login ulang.",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final List<CategoryModel> data = await _apiService.getCategories(token);
      categories.assignAll(data);
      print('✅ Successfully loaded ${data.length} categories');
    } catch (e) {
      print('❌ Error fetching categories: $e');
      Get.snackbar(
        "Error", 
        "Gagal memuat kategori: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isCategoriesLoading(false);
    }
  }

  Future<void> createService() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final discountText = discountController.text.trim();
    final minOrderText = minOrderController.text.trim();
    final estimateNumberText = estimateNumberController.text.trim();
    final description = descriptionController.text.trim();

    // Validasi
    if (name.isEmpty) {
      Get.snackbar(
        "Validasi", 
        "Nama layanan wajib diisi",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    if (priceText.isEmpty) {
      Get.snackbar(
        "Validasi", 
        "Harga wajib diisi",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    // Parse dengan safe parsing
    final price = _parseDouble(priceText);
    if (price <= 0) {
      Get.snackbar(
        "Validasi", 
        "Harga harus lebih dari 0",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    final discount = _parseDouble(discountText, defaultValue: 0.0);
    final minOrder = _parseInt(minOrderText, defaultValue: 1);

    // Build estimate string
    String? estimate;
    if (estimateNumberText.isNotEmpty) {
      final estimateNumber = _parseInt(estimateNumberText, defaultValue: 0);
      if (estimateNumber > 0) {
        estimate = '$estimateNumber ${selectedEstimateUnit.value}';
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar(
        "Error", 
        "Token tidak ditemukan. Silakan login ulang.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isSubmitting(true);
    try {
      print('📤 Creating service: name=$name, price=$price, discount=$discount');
      
      final service = ServiceModel(
        name: name,
        categoryId: selectedCategory.value?.id != null 
            ? int.tryParse(selectedCategory.value!.id!) 
            : null,
        price: price,
        discount: discount,
        minOrder: minOrder,
        type: selectedCategory.value?.type,
        estimate: estimate,
        description: description.isEmpty ? null : description,
      );

      await _apiService.createService(service, token);
      print('✅ Service created successfully');
      
      // Refresh list dulu, baru back
      await fetchServices();
      
      // Tutup form
      Get.back();
      
      // Show success message
      Get.snackbar(
        "Sukses", 
        "Layanan berhasil ditambahkan", 
        backgroundColor: const Color.fromARGB(255, 14, 44, 75), 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error creating service: $e');
      Get.snackbar(
        "Error", 
        "Gagal menambahkan layanan: $e",
        backgroundColor: const Color.fromARGB(255, 42, 10, 5), 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> updateService(int id) async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final discountText = discountController.text.trim();
    final minOrderText = minOrderController.text.trim();
    final estimateNumberText = estimateNumberController.text.trim();
    final description = descriptionController.text.trim();

    // Validasi
    if (name.isEmpty) {
      Get.snackbar(
        "Validasi", 
        "Nama layanan wajib diisi",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    if (priceText.isEmpty) {
      Get.snackbar(
        "Validasi", 
        "Harga wajib diisi",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    // Parse dengan safe parsing
    final price = _parseDouble(priceText);
    if (price <= 0) {
      Get.snackbar(
        "Validasi", 
        "Harga harus lebih dari 0",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    final discount = _parseDouble(discountText, defaultValue: 0.0);
    final minOrder = _parseInt(minOrderText, defaultValue: 1);

    // Build estimate string
    String? estimate;
    if (estimateNumberText.isNotEmpty) {
      final estimateNumber = _parseInt(estimateNumberText, defaultValue: 0);
      if (estimateNumber > 0) {
        estimate = '$estimateNumber ${selectedEstimateUnit.value}';
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar(
        "Error", 
        "Token tidak ditemukan. Silakan login ulang.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isSubmitting(true);
    try {
      print('📤 Updating service ID=$id: name=$name, price=$price, discount=$discount');
      
      final service = ServiceModel(
        id: id,
        name: name,
        categoryId: selectedCategory.value?.id != null 
            ? int.tryParse(selectedCategory.value!.id!) 
            : null,
        price: price,
        discount: discount,
        minOrder: minOrder,
        type: selectedCategory.value?.type,
        estimate: estimate,
        description: description.isEmpty ? null : description,
      );

      await _apiService.updateService(service, token);
      print('✅ Service updated successfully');
      
      // Refresh list dulu, baru back
      await fetchServices();
      
      // Tutup form
      Get.back();
      
      // Show success message
      Get.snackbar(
        "Sukses", 
        "Layanan berhasil diperbarui", 
        backgroundColor: const Color.fromARGB(255, 14, 44, 75), 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error updating service: $e');
      Get.snackbar(
        "Error", 
        "Gagal memperbarui layanan: $e", 
        backgroundColor: const Color.fromARGB(255, 42, 10, 5), 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> deleteService(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      Get.snackbar(
        "Error", 
        "Token tidak ditemukan. Silakan login ulang.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      print('🗑️ Deleting service ID=$id');
      await _apiService.deleteService(id, token);
      print('✅ Service deleted successfully');
      
      // Tutup form dulu
      Get.back();
      
      // Refresh list
      await fetchServices();
      
      // Show success message
      Get.snackbar(
        "Berhasil", 
        "Layanan berhasil dihapus", 
        backgroundColor: const Color.fromARGB(255, 14, 44, 75), 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error deleting service: $e');
      Get.snackbar(
        "Error", 
        "Gagal menghapus layanan: $e", 
        backgroundColor: const Color.fromARGB(255, 42, 10, 5), 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Reset form
  void resetForm() {
    nameController.clear();
    priceController.clear();
    discountController.clear();
    minOrderController.clear();
    estimateNumberController.clear();
    descriptionController.clear();
    selectedCategory.value = null;
    selectedEstimateUnit.value = 'Hari';
    print('🔄 Form reset');
  }

  // Helper untuk set form dari service (mode edit)
  void setFormFromService(ServiceModel service) {
    print('📝 Setting form from service: ${service.name}');
    
    nameController.text = service.name;
    
    // Safe conversion untuk price
    if (service.price != null) {
      priceController.text = service.price.toStringAsFixed(0);
    }
    
    // Safe conversion untuk discount
    if (service.discount != null && service.discount! > 0) {
      discountController.text = service.discount!.toStringAsFixed(0);
    } else {
      discountController.clear();
    }
    
    // Safe conversion untuk minOrder
    if (service.minOrder != null) {
      minOrderController.text = service.minOrder.toString();
    } else {
      minOrderController.text = '1';
    }
    
    descriptionController.text = service.description ?? '';

    // Set category - PENTING: Pastikan category dari service di-set dengan benar
    if (service.category != null) {
      // Buat CategoryModel dari data service.category
      final categoryFromService = CategoryModel(
        id: service.category!.id?.toString(),
        name: service.category!.name,
        type: service.category!.type,
      );
      
      // Cari apakah category ini sudah ada di list categories
      final existingCategory = categories.firstWhereOrNull(
        (cat) => cat.id == categoryFromService.id
      );
      
      if (existingCategory != null) {
        // Jika ada, gunakan yang dari list
        selectedCategory.value = existingCategory;
      } else {
        // Jika tidak ada, tambahkan ke list dan gunakan
        categories.insert(0, categoryFromService);
        selectedCategory.value = categoryFromService;
      }
      
      print('✅ Category set: ${categoryFromService.name} (ID: ${categoryFromService.id})');
    } else {
      selectedCategory.value = null;
      print('⚠️ No category found in service');
    }

    // Parse estimate (misal: "2 Hari" atau "24 Jam")
    if (service.estimate != null && service.estimate!.isNotEmpty) {
      final parts = service.estimate!.split(' ');
      if (parts.length == 2) {
        estimateNumberController.text = parts[0];
        selectedEstimateUnit.value = parts[1];
        print('✅ Estimate set: ${parts[0]} ${parts[1]}');
      }
    } else {
      estimateNumberController.clear();
      selectedEstimateUnit.value = 'Hari';
    }
    
    print('✅ Form set successfully');
  }
}
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/customer_model.dart';
import '../model/service_model.dart';
import '../model/nota_service_item.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotaController extends GetxController {
  final ApiService _apiService = ApiService();

  var customers = <CustomerModel>[].obs;
  var services = <ServiceModel>[].obs;

  var isLoadingCustomers = false.obs;
  var isLoadingServices = false.obs;
  var isCreatingTransaction = false.obs;

  var selectedCustomer = CustomerModel().obs;
  var selectedServices = <NotaServiceItem>[].obs;
  var selectedDate = DateTime.now().obs;
  var paymentStatus = 'unpaid'.obs;

  final double biayaPenanganan = 10000.0;
  final double biayaKantong = 5000.0;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    fetchServices();
  }

  @override
  void onClose() {
    resetNota();
    super.onClose();
  }

  // ==================== FETCH DATA ====================
  Future<void> fetchCustomers() async {
    isLoadingCustomers(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) throw Exception("Token tidak ditemukan");

      final data = await _apiService.getCustomers(token);
      customers.assignAll(data);
    } catch (e) {
      Get.snackbar("Gagal", "Tidak bisa memuat data pelanggan",
        backgroundColor: Colors.red.shade700, colorText: Colors.white);
    } finally {
      isLoadingCustomers(false);
    }
  }

  Future<void> fetchServices() async {
    isLoadingServices(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) throw Exception("Token tidak ditemukan");

      final data = await _apiService.getServices(token);
      services.assignAll(data);
    } catch (e) {
      Get.snackbar("Gagal", "Tidak bisa memuat daftar paket",
        backgroundColor: Colors.red.shade700, colorText: Colors.white);
    } finally {
      isLoadingServices(false);
    }
  }

  // ==================== SERVICE & CUSTOMER ====================
  void addService(ServiceModel service) {
    final idx = selectedServices.indexWhere((s) => s.id == service.id);
    if (idx >= 0) {
      selectedServices[idx].quantity++;
    } else {
      selectedServices.add(NotaServiceItem.fromServiceModel(service));
    }
    selectedServices.refresh();
  }

  void removeService(String idStr) {
    final id = int.tryParse(idStr);
    if (id != null) {
      selectedServices.removeWhere((s) => s.id == id);
      selectedServices.refresh();
    }
  }

  void updateQuantity(String idStr, int qty) {
    final id = int.tryParse(idStr);
    if (id == null) return;
    final item = selectedServices.firstWhereOrNull((s) => s.id == id);
    if (item != null) {
      item.quantity = qty < item.minOrder ? item.minOrder : qty;
      selectedServices.refresh();
    }
  }

  void setSelectedCustomer(CustomerModel customer) {
    selectedCustomer.value = customer;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void setPaymentStatus(String status) {
    if (status == 'paid' || status == 'unpaid') paymentStatus.value = status;
  }

  void resetNota() {
    selectedCustomer.value = CustomerModel();
    selectedServices.clear();
    selectedDate.value = DateTime.now();
    paymentStatus.value = 'unpaid';
  }

  // ==================== HITUNG ====================
  double calculateSubtotal() =>
      selectedServices.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  double calculateTotal() =>
      calculateSubtotal() + biayaPenanganan + biayaKantong;

  bool get isFormValid => selectedCustomer.value.id != null && selectedServices.isNotEmpty;

  // ==================== BUAT TRANSAKSI ====================
  Future<bool> createTransaction() async {
    if (selectedCustomer.value.id == null) {
      Get.snackbar("Peringatan", "Silakan pilih pelanggan dulu");
      return false;
    }
    if (selectedServices.isEmpty) {
      Get.snackbar("Peringatan", "Belum ada paket yang dipilih");
      return false;
    }

    isCreatingTransaction(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final userId = prefs.getInt('user_id');
      if (token.isEmpty || userId == null) {
        throw Exception("Token/user ID tidak ditemukan");
      }

      final details = selectedServices.map((item) => item.toJson()).toList();
      final estimatedCompletion = selectedDate.value.add(const Duration(days: 2));

      final transactionData = {
        'user_id': userId,
        'customer_id': selectedCustomer.value.id,
        'transaction_date': selectedDate.value.toIso8601String().split('T')[0],
        'estimated_completion': estimatedCompletion.toIso8601String().split('T')[0],
        'payment_status': paymentStatus.value,
        'laundry_status': 'pending',
        'payment_method': paymentStatus.value == 'paid' ? 'cash' : null,
        'notes': null,
        'details': details,
      };

      await _apiService.createTransaction(transactionData, token);
      Get.snackbar("Berhasil", "Transaksi berhasil dibuat!");
      resetNota();
      return true;
    } catch (e) {
      Get.snackbar("Gagal", "Gagal membuat transaksi: ${e.toString()}");
      return false;
    } finally {
      isCreatingTransaction(false);
    }
  }
}

// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category_model.dart';
import '../model/service_model.dart';

class ApiService {
  final String _baseUrl = 'http://127.0.0.1:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Login gagal';
      throw Exception(message);
    }
  }

  Future<CategoryModel> createCategory(CategoryModel category, String token) async {
    final url = Uri.parse('$_baseUrl/categories');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CategoryModel.fromJson(data['data']);
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal membuat kategori';
      throw Exception(message);
    }
  }

  Future<List<CategoryModel>> getCategories(String token) async {
    final url = Uri.parse('$_baseUrl/categories');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> list = data['data'];
      return list.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil daftar kategori');
    }
  }

  // --- Metode update & delete tetap bisa dipakai nanti ---
  Future<void> updateCategory(CategoryModel category, String token) async {
    if (category.id == null) {
      throw Exception('ID kategori tidak boleh null saat update');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/categories/${category.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui kategori: ${response.statusCode}');
    }
  }
    // Tambahkan method ini di dalam class ApiService

  Future<void> deleteCategory(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/categories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus kategori: ${response.statusCode}');
    }
  }

// GET /api/services
  Future<List<ServiceModel>> getServices(String token) async {
    final url = Uri.parse('$_baseUrl/services');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Laravel pagination: data = { "data": [...] }
      final List<dynamic> list = data['data'] ?? data; // handle both paginated & non-paginated
      return list.map((item) => ServiceModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil daftar layanan');
    }
  }

  // POST /api/services
  Future<ServiceModel> createService(ServiceModel service, String token) async {
    final url = Uri.parse('$_baseUrl/services');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Laravel mengembalikan object langsung (bukan wrapped dalam "data")
      // Tapi sesuaikan dengan response Laravel kamu
      // Jika pakai resource: mungkin { "data": { ... } }
      // Jika tidak: langsung { ... }
      // Kita coba ambil langsung atau dari 'data'
      final jsonData = data is Map<String, dynamic> && data.containsKey('data')
          ? data['data']
          : data;
      return ServiceModel.fromJson(jsonData);
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal membuat layanan';
      throw Exception(message);
    }
  }

  // GET /api/services/{id}
  Future<ServiceModel> getService(int id, String token) async {
    final url = Uri.parse('$_baseUrl/services/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jsonData = data is Map<String, dynamic> && data.containsKey('data')
          ? data['data']
          : data;
      return ServiceModel.fromJson(jsonData);
    } else {
      throw Exception('Gagal mengambil detail layanan');
    }
  }

  // PUT /api/services/{id}
  Future<ServiceModel> updateService(ServiceModel service, String token) async {
    if (service.id == null) {
      throw Exception('ID layanan tidak boleh null saat update');
    }

    final url = Uri.parse('$_baseUrl/services/${service.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jsonData = data is Map<String, dynamic> && data.containsKey('data')
          ? data['data']
          : data;
      return ServiceModel.fromJson(jsonData);
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal memperbarui layanan';
      throw Exception(message);
    }
  }

  // DELETE /api/services/{id} (soft delete)
  Future<void> deleteService(int id, String token) async {
    final url = Uri.parse('$_baseUrl/services/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Gagal menghapus layanan: ${response.statusCode}');
    }
  }

}
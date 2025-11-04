// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category_model.dart';

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
  Future<CategoryModel> updateCategory(int id, CategoryModel category, String token) async {
    final url = Uri.parse('$_baseUrl/categories/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CategoryModel.fromJson(data['data']);
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal memperbarui kategori';
      throw Exception(message);
    }
  }

  Future<void> deleteCategory(int id, String token) async {
    final url = Uri.parse('$_baseUrl/categories/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal menghapus kategori';
      throw Exception(message);
    }
  }
}
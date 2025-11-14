// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category_model.dart';
import '../model/service_model.dart';
import '../model/customer_model.dart';

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

  Future<void> deleteCategory(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/categories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus kategori: ${response.statusCode}');
    }
  }

  // ✅ GET /api/services - Handle Laravel Pagination
  Future<List<ServiceModel>> getServices(String token) async {
    final url = Uri.parse('$_baseUrl/services');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      
      // Debug log
      print('🔍 Services API Response: $jsonData');
      
      // Handle Laravel pagination structure
      final List<dynamic> list;
      if (jsonData is Map<String, dynamic>) {
        if (jsonData.containsKey('data')) {
          // Pagination response: { "current_page": 1, "data": [...] }
          list = jsonData['data'] as List<dynamic>;
        } else if (jsonData.containsKey('success') && jsonData['data'] is List) {
          // Simple wrapper: { "success": true, "data": [...] }
          list = jsonData['data'] as List<dynamic>;
        } else {
          // Direct array (no wrapper)
          list = [jsonData];
        }
      } else if (jsonData is List) {
        // Direct array response
        list = jsonData;
      } else {
        throw Exception('Format response tidak dikenali');
      }

      print('✅ Parsing ${list.length} services');
      
      return list.map((item) {
        try {
          return ServiceModel.fromJson(item as Map<String, dynamic>);
        } catch (e) {
          print('❌ Error parsing service item: $e');
          print('   Item data: $item');
          rethrow;
        }
      }).toList();
      
    } else {
      throw Exception('Gagal mengambil daftar layanan: ${response.statusCode}');
    }
  }

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

  // ✅ GET /api/customers - Handle simple wrapper response
  Future<List<CustomerModel>> getCustomers(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/customers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      // Debug log
      print('🔍 Customers API Response: $jsonData');
      
      // Handle different response formats
      final List<dynamic> list;
      if (jsonData is Map<String, dynamic>) {
        if (jsonData.containsKey('data')) {
          // Wrapper: { "success": true, "data": [...] }
          list = jsonData['data'] as List<dynamic>;
        } else {
          // Single object wrapped
          list = [jsonData];
        }
      } else if (jsonData is List) {
        // Direct array
        list = jsonData;
      } else {
        throw Exception('Format response customers tidak dikenali');
      }

      print('✅ Parsing ${list.length} customers');
      
      return list.map((item) {
        try {
          return CustomerModel.fromJson(item as Map<String, dynamic>);
        } catch (e) {
          print('❌ Error parsing customer item: $e');
          print('   Item data: $item');
          rethrow;
        }
      }).toList();
      
    } else {
      throw Exception('Gagal memuat customer: ${response.statusCode}');
    }
  }

  Future<void> createCustomer(CustomerModel customer, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(customer.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan customer');
    }
  }

  Future<void> updateCustomer(CustomerModel customer, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/customers/${customer.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(customer.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui customer');
    }
  }

  Future<void> deleteCustomer(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/customers/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus customer');
    }
  }

  // POST /api/transactions
  Future<Map<String, dynamic>> createTransaction(
    Map<String, dynamic> transactionData, 
    String token
  ) async {
    final url = Uri.parse('$_baseUrl/transactions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transactionData),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal membuat transaksi';
      throw Exception(message);
    }
  }

  // GET /api/transactions
  Future<List<dynamic>> getTransactions(String token) async {
    final url = Uri.parse('$_baseUrl/transactions');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Gagal mengambil daftar transaksi');
    }
  }

  // GET /api/transactions/{id}
  Future<Map<String, dynamic>> getTransaction(int id, String token) async {
    final url = Uri.parse('$_baseUrl/transactions/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? data;
    } else {
      throw Exception('Gagal mengambil detail transaksi');
    }
  }

  // PUT /api/transactions/{id}
  Future<Map<String, dynamic>> updateTransaction(
    int id,
    Map<String, dynamic> transactionData,
    String token
  ) async {
    final url = Uri.parse('$_baseUrl/transactions/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transactionData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Gagal memperbarui transaksi';
      throw Exception(message);
    }
  }

  // DELETE /api/transactions/{id}
  Future<void> deleteTransaction(int id, String token) async {
    final url = Uri.parse('$_baseUrl/transactions/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus transaksi');
    }
  }
}

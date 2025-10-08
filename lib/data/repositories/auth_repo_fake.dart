import 'dart:async';
import '../../domain/entities/user.dart';

class AuthRepoFake {
  // daftar dummy user
  static const _users = [
    {'email': 'demo@laundry.app', 'password': '123456', 'name': 'Demo User', 'id': 'u1'},
    {'email': 'admin@laundry.app', 'password': 'admin',   'name': 'Admin',     'id': 'u2'},
  ];

  Future<(String token, User user)> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulasi network
    final u = _users.firstWhere(
      (e) => e['email'] == email && e['password'] == password,
      orElse: () => throw Exception('Email atau password salah'),
    );
    final user = User(id: u['id']!, email: u['email']!, name: u['name']!);
    final token = 'fake.${user.id}.${DateTime.now().millisecondsSinceEpoch}';
    return (token, user);
  }
}
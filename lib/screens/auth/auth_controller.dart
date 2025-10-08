// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/entities/user.dart';
// import '../../data/repositories/auth_repo_fake.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthState {
//   final AsyncValue<User?> user;
//   final String? token;
//   const AuthState({this.token, this.user = const AsyncValue.data(null)});
//   AuthState copyWith({AsyncValue<User?>? user, String? token}) =>
//       AuthState(user: user ?? this.user, token: token ?? this.token);
// }

// class AuthController extends StateNotifier<AuthState> {
//   final AuthRepoFake repo;
//   AuthController(this.repo) : super(const AuthState());

//   Future<void> login(String email, String pass) async {
//     state = state.copyWith(user: const AsyncValue.loading());
//     try {
//       final (token, user) = await repo.login(email, pass);
//       final sp = await SharedPreferences.getInstance();
//       await sp.setString('token', token);
//       await sp.setString('userEmail', user.email);
//       await sp.setString('userName', user.name);
//       await sp.setString('userId', user.id);
//       state = AuthState(token: token, user: AsyncValue.data(user));
//     } catch (e, st) {
//       state = AuthState(token: null, user: AsyncValue.error(e, st));
//     }
//   }

//   Future<void> loadSession() async {
//     final sp = await SharedPreferences.getInstance();
//     final tok = sp.getString('token');
//     if (tok == null) { state = const AuthState(); return; }
//     final user = User(
//       id: sp.getString('userId') ?? 'u?',
//       email: sp.getString('userEmail') ?? '',
//       name: sp.getString('userName') ?? '',
//     );
//     state = AuthState(token: tok, user: AsyncValue.data(user));
//   }

//   Future<void> logout() async {
//     final sp = await SharedPreferences.getInstance();
//     await sp.remove('token');
//     await sp.remove('userEmail');
//     await sp.remove('userName');
//     await sp.remove('userId');
//     state = const AuthState();
//   }
// }

// final authControllerProvider =
//     StateNotifierProvider<AuthController, AuthState>((ref) {
//   return AuthController(AuthRepoFake());
// });

// final isLoggedInProvider = Provider<bool>((ref) {
//   final s = ref.watch(authControllerProvider);
//   return s.token != null && s.user.value != null;
// });

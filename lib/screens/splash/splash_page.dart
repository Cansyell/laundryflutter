// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../auth/auth_controller.dart';
// import 'package:go_router/gorouter.dart';

// class SplashPage extends ConsumerWidget {
//   const SplashPage({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.read(authControllerProvider.notifier).loadSession().then(() {
//       final ok = ref.read(isLoggedInProvider);
//       context.go(ok ? '/home' : '/login');
//     });
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
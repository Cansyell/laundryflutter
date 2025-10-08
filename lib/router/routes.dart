// import 'package:go_router/go_router.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../screens/splash/splash_page.dart';
// import '../screens/auth/login_page.dart';
// import '../screens/home/home_screen.dart';
// import '../screens/auth/auth_controller.dart';

// GoRouter buildRouter(WidgetRef ref) {
//   return GoRouter(
//     initialLocation: '/',
//     refreshListenable: GoRouterRefreshStream(
//       ref.watch(authControllerProvider.notifier).stream,
//     ),
//     redirect: (ctx, state) {
//       final authed = ref.read(isLoggedInProvider);
//       final onLogin = state.subloc == '/login';
//       if (!authed && !onLogin) return '/login';
//       if (authed && onLogin) return '/home';
//       return null;
//     },
//     routes: [
//       GoRoute(path: '/', builder: (, ) => const SplashPage()),
//       GoRoute(path: '/login', builder: (_, ) => const LoginPage()),
//       GoRoute(path: '/home', builder: (_, __) => const HomePage()),
//     ],
//   );
// }
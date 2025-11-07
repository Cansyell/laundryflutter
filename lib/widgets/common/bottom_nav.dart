import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/detail/transaction_list_screen.dart';
import '../../screens/service/service_list_screen.dart';
import '../../screens/setting/setting_list_screen.dart';
import '../../controllers/service_controller.dart';
import 'package:get/get.dart';

enum NavTab { home, orders, services, settings }

class BottomNav extends StatelessWidget {
  final NavTab active;
  const BottomNav({super.key, required this.active});

  void _handleNavigation(BuildContext context, NavTab tab) {
    if (tab == active) return; // biar nggak reload halaman yang sama

    Widget target;
    switch (tab) {
      case NavTab.home:
        target = const HomeScreen();
        break;
      case NavTab.orders:
        target = const TransactionListScreen();
        break;
      case NavTab.services:
        target = const ServicePage();
        break;
      case NavTab.settings:
        target = const SettingsScreen();
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => target,
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.cardBackground,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavBtn(
              icon: Icons.home_rounded,
              label: 'Home',
              active: active == NavTab.home,
              onTap: () => _handleNavigation(context, NavTab.home),
            ),
            _NavBtn(
              icon: Icons.receipt_long,
              label: 'Pesanan',
              active: active == NavTab.orders,
              onTap: () => _handleNavigation(context, NavTab.orders),
            ),
            const SizedBox(width: 40),
            _NavBtn(
              icon: Icons.room_service,
              label: 'Layanan',
              active: active == NavTab.services,
              onTap:(){
                       if (!Get.isRegistered<ServiceController>(tag: 'service')) {
                        Get.put(ServiceController(), tag: 'service');
                      }

                      Get.to(const ServicePage());
                    },
            ),
            _NavBtn(
              icon: Icons.settings,
              label: 'Pengaturan',
              active: active == NavTab.settings,
              onTap: () => _handleNavigation(context, NavTab.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? AppColors.primary : Colors.transparent;
    final fg = active ? Colors.white : Colors.black54;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: fg),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 11, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

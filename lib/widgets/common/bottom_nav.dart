// widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

enum NavTab { home, orders, services, settings }

class BottomNav extends StatelessWidget {
  final NavTab active;
  final ValueChanged<NavTab>? onSelect;
  const BottomNav({super.key, required this.active, this.onSelect});

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
            _NavBtn(icon: Icons.home_rounded, label: 'Home',    tab: NavTab.home,     active: active == NavTab.home,    onTap: () => onSelect?.call(NavTab.home)),
            _NavBtn(icon: Icons.receipt_long, label: 'Pesanan',  tab: NavTab.orders,   active: active == NavTab.orders,  onTap: () => onSelect?.call(NavTab.orders)),
            const SizedBox(width: 40),
            _NavBtn(icon: Icons.room_service, label: 'Layanan',  tab: NavTab.services, active: active == NavTab.services,onTap: () => onSelect?.call(NavTab.services)),
            _NavBtn(icon: Icons.settings,     label: 'Pengaturan',tab: NavTab.settings,active: active == NavTab.settings,onTap: () => onSelect?.call(NavTab.settings)),
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
  final NavTab tab;
  final VoidCallback onTap;

  const _NavBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.tab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? AppColors.primary : Colors.transparent;
    final fg = active ? Colors.white : Colors.black54;

    final child = Container(
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
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

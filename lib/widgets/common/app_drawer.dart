// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 Tambahkan GetX untuk navigasi konsisten

import '../../config/app_colors.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/service_controller.dart';

// Import semua layar yang dibutuhkan — pastikan path benar
import '../../screens/categories/category_screen.dart';
import '../../screens/service/service_list_screen.dart';
import '../../screens/expenses/expenses_list_screen.dart';
import '../../screens/expenses/category_expenses_list_screen.dart';
import '../../screens/expenses/laporan_screen.dart';
import '../../screens/pegawai/pegawai_list_screen.dart';
import '../../screens/pelanggan/pelanggan_list_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateAndCloseDrawer(BuildContext context, Widget screen) {
    Navigator.pop(context); // Tutup drawer
    Get.to(screen); // Gunakan Get.to() untuk konsistensi dengan GetX
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            // Header Drawer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // PRODUK
                  const _SectionHeader(title: 'Produk'),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.grid_view_rounded,
                    title: 'Kategori',
                    onTap: () {
                      Navigator.pop(context); // Tutup drawer

                      // Pastikan controller tersedia sebelum navigasi
                      if (!Get.isRegistered<CategoryController>(tag: 'category')) {
                        Get.put(CategoryController(), tag: 'category');
                      }

                      Get.to(const KategoriPage());
                    },
                  ),
                  const SizedBox(height: 8),
                  _MenuItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'Paket',
                    onTap:(){
                       if (!Get.isRegistered<ServiceController>(tag: 'service')) {
                        Get.put(ServiceController(), tag: 'service');
                      }

                      Get.to(const ServicePage());
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // PENGELUARAN
                  const _SectionHeader(title: 'Pengeluaran'),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.attach_money_rounded,
                    title: 'Daftar Pengeluaran',
                    onTap: () => _navigateAndCloseDrawer(context, const ExpenseListScreen()),
                  ),
                  const SizedBox(height: 8),
                  _MenuItem(
                    icon: Icons.category_outlined,
                    title: 'Kategori Pengeluaran',
                    onTap: () => _navigateAndCloseDrawer(context, const CategoryExpensesListScreen()),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // LAPORAN
                  const _SectionHeader(title: 'Laporan'),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Pendapatan',
                    onTap: () => _navigateAndCloseDrawer(context, const LaporanScreen()),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // MASTER
                  const _SectionHeader(title: 'Master'),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Pegawai',
                    onTap: () => _navigateAndCloseDrawer(context, const PegawaiListScreen()),
                  ),
                  const SizedBox(height: 8),
                  _MenuItem(
                    icon: Icons.people_outline,
                    title: 'Pelanggan',
                    onTap: () => _navigateAndCloseDrawer(context, const PelangganListScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: Colors.white.withOpacity(0.3),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
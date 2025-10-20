import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/common/bottom_nav.dart';
import '../../widgets/common/app_drawer.dart';
import 'edit_package_screen.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Paket',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          // 🔍 Kotak Pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🧾 List Paket
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                _buildPackageCard(
                  context,
                  kategori: 'Kiloan',
                  nama: 'Cuci Kering + Strika',
                  estimasi: 'Estimasi 3 Hari',
                  harga: 'IDR 6.000',
                ),
                _buildPackageCard(
                  context,
                  kategori: 'Kiloan',
                  nama: 'Setrika Saja',
                  estimasi: 'Estimasi 3 Hari',
                  harga: 'IDR 5.000',
                ),
                _buildPackageCard(
                  context,
                  kategori: 'Satuan',
                  nama: 'Bed Cover',
                  estimasi: 'Estimasi 3 Hari',
                  harga: 'IDR 16.000',
                ),
              ],
            ),
          ),
        ],
      ),

      // ➕ Tombol Tambah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const PackageFormScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.textWhite),
        label: const Text(
          'Tambah',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const BottomNav(active: NavTab.services),
    );
  }

  // Widget builder untuk kartu paket
  Widget _buildPackageCard(
    BuildContext context, {
    required String kategori,
    required String nama,
    required String estimasi,
    required String harga,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const PackageFormScreen(isEdit: true),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kolom kiri
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kategori,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  estimasi,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            // Kolom kanan
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Min. Order 3 KG',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  harga,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

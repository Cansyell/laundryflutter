import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/common/bottom_nav.dart';
import '../../widgets/common/app_drawer.dart';
import 'expenses_form_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.filter_alt_outlined, size: 26),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F9FF),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // 💰 Total Pengeluaran
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total Pengeluaran',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Rp600.000',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 🧾 Daftar Pengeluaran
          _buildExpenseCard(
            context,
            kategori: 'Listrik & Air',
            judul: 'Pembayaran listrik',
            tanggal: '2025-10-01',
            nominal: 'Rp400.000',
            metode: 'Transfer Bank',
            deskripsi: 'Pembayaran listrik bulan Oktober 2025',
          ),
          _buildExpenseCard(
            context,
            kategori: 'Deterjen & Pewangi',
            judul: 'Pembelian pewangi pakaian',
            tanggal: '2025-10-03',
            nominal: 'Rp60.000',
            metode: 'Transfer Bank',
            deskripsi:
                'Pembelian pewangi pakaian 5 liter untuk kebutuhan laundry',
          ),
          _buildExpenseCard(
            context,
            kategori: 'Deterjen & Pewangi',
            judul: 'Pembelian deterjen',
            tanggal: '2025-10-05',
            nominal: 'Rp140.000',
            metode: 'Transfer Bank',
            deskripsi:
                'Pembelian deterjen 5 kg sebanyak 2 kemasan untuk kebutuhan operasional laundry',
          ),
        ],
      ),

      // ➕ Tombol Tambah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const ExpenseFormScreen(),
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
    );
  }

  // 🧱 Widget kartu pengeluaran
  Widget _buildExpenseCard(
    BuildContext context, {
    required String kategori,
    required String judul,
    required String tanggal,
    required String nominal,
    required String metode,
    required String deskripsi,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const ExpenseFormScreen(isEdit: true),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (kategori & tanggal)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kategori,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  tanggal,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Judul
            Text(
              judul,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),

            // Nominal dan metode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nominal,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  metode,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Deskripsi
            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

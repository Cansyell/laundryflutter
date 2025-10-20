import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'category_expenses_form_screen.dart';

class CategoryExpensesListScreen extends StatefulWidget {
  const CategoryExpensesListScreen({super.key});

  @override
  State<CategoryExpensesListScreen> createState() => _CategoryExpensesListScreenState();
}

class _CategoryExpensesListScreenState extends State<CategoryExpensesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> categories = [
    {
      'nama': 'Deterjen & Pewangi',
      'keterangan':
          'Pembelian deterjen, pewangi pakaian, dan bahan kimia lainnya yang digunakan untuk mencuci pakaian pelanggan'
    },
    {
      'nama': 'Listrik & Air',
      'keterangan':
          'Biaya tagihan listrik dan air yang digunakan untuk operasional mesin cuci, pengering, dan kegiatan mencuci lainnya'
    },
    {
      'nama': 'Plastik & Kemasan',
      'keterangan':
          'Biaya untuk membeli plastik laundry dan perlengkapan pengemasan pakaian pelanggan'
    },
    {
      'nama': 'Promosi',
      'keterangan':
          'Biaya untuk mencetak dan menyebarkan brosur sebagai media promosi usaha laundry'
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filtered = categories
        .where((cat) => cat['nama']!.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Pengeluaran'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📋 Daftar kategori
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final kategori = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📘 Nama dan keterangan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kategori['nama']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              kategori['keterangan']!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // ✏️ dan ❌ tombol
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => CategoryExpensesFormScreen(
                                    isEdit: true,
                                    namaAwal: kategori['nama']!,
                                    keteranganAwal: kategori['keterangan']!,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() => categories.removeAt(index));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Tombol tambah
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const CategoryExpensesFormScreen(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

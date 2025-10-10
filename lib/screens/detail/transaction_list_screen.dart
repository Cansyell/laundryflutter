import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../model/status_transaksi.dart';
import '../../widgets/common/txn_item.dart';
import '../home/home_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String selectedFilter = 'Semua';

  // Dummy data untuk contoh tampilan
  final List<Map<String, dynamic>> transactions = [
    {
      'kode': 'Washin - 25042216500',
      'tanggal': '2025-04-22 12:45',
      'nama': 'Budi Raharja',
      'nominal': 'IDR 50,000',
      'status': StatusTransaksi.antrian,
      'isLunas': false,
    },
    {
      'kode': 'Washin - 25042216501',
      'tanggal': '2025-04-22 12:45',
      'nama': 'Siti',
      'nominal': 'IDR 50,000',
      'status': StatusTransaksi.proses,
      'isLunas': true,
    },
    {
      'kode': 'Washin - 25042216502',
      'tanggal': '2025-04-22 12:45',
      'nama': 'Dona Bakti',
      'nominal': 'IDR 50,000',
      'status': StatusTransaksi.proses,
      'isLunas': true,
    },
    {
      'kode': 'Washin - 25042216503',
      'tanggal': '2025-04-22 12:45',
      'nama': 'Yoga Kukuh',
      'nominal': 'IDR 50,000',
      'status': StatusTransaksi.selesai,
      'isLunas': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🔍 Filter transaksi sesuai status
    List<Map<String, dynamic>> filteredTransactions =
        selectedFilter == 'Semua'
            ? transactions
            : transactions.where((txn) {
                switch (selectedFilter) {
                  case 'Antrian':
                    return txn['status'] == StatusTransaksi.antrian;
                  case 'Proses':
                    return txn['status'] == StatusTransaksi.proses;
                  case 'Selesai':
                    return txn['status'] == StatusTransaksi.selesai;
                  default:
                    return true;
                }
              }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        title: const Text(
          'Daftar Transaksi',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: const Duration(milliseconds: 250),
                transitionsBuilder: (_, animation, __, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () {},
        icon: const Icon(Icons.qr_code_2_rounded, color: Colors.white),
        label: const Text('Scan QR', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // 🔍 Search & Filter
          Container(
            color: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // 🔘 Filter buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterButton('Semua'),
                      _buildFilterButton('Antrian'),
                      _buildFilterButton('Proses'),
                      _buildFilterButton('Selesai'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🧾 Daftar transaksi
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTransactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final txn = filteredTransactions[index];
                return TxnItem(
                  kode: txn['kode'],
                  tanggal: txn['tanggal'],
                  nama: txn['nama'],
                  nominal: txn['nominal'],
                  status: _mapStatus(txn['status']),
                  isLunas: txn['isLunas'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔄 Mapping dari StatusTransaksi ke TxnStatus untuk widget TxnItem
  TxnStatus _mapStatus(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.antrian:
        return TxnStatus.waiting;
      case StatusTransaksi.proses:
        return TxnStatus.process;
      case StatusTransaksi.selesai:
        return TxnStatus.done;
    }
  }

  // 🧩 Tombol filter status
  Widget _buildFilterButton(String label) {
    final bool isSelected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E3A8A),
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF1E3A8A),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (_) {
          setState(() => selectedFilter = label);
        },
      ),
    );
  }
}

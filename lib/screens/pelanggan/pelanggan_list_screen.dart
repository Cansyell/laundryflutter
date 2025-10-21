import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'pelanggan_form_screen.dart';

class PelangganListScreen extends StatefulWidget {
  const PelangganListScreen({Key? key}) : super(key: key);

  @override
  State<PelangganListScreen> createState() => _PelangganListScreenState();
}

class _PelangganListScreenState extends State<PelangganListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Data Pelanggan (asli)
  final List<Map<String, String>> _pelangganList = [
    {
      'name': 'Lala',
      'phone': '08234567890',
      'alamat': 'Jl. Mawar No. 5, Purwokerto',
    },
    {
      'name': 'Lulu',
      'phone': '08122333456',
      'alamat': 'Jl. Melati No. 8, Purwokerto',
    },
    {
      'name': 'Budi',
      'phone': '085212345678',
      'alamat': 'Jl. Kenanga No. 2, Purwokerto',
    },
  ];

  // Data yang difilter berdasarkan pencarian
  List<Map<String, String>> _filteredPelangganList = [];

  @override
  void initState() {
    super.initState();
    _filteredPelangganList = List.from(_pelangganList);

    // setiap kali text berubah, update hasil pencarian
    _searchController.addListener(_filterPelanggan);
  }

  void _filterPelanggan() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPelangganList = _pelangganList.where((pelanggan) {
        final name = pelanggan['name']!.toLowerCase();
        final phone = pelanggan['phone']!.toLowerCase();
        final alamat = pelanggan['alamat']!.toLowerCase();
        return name.contains(query) || phone.contains(query) || alamat.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        title: const Text(
          'Daftar Pelanggan',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari nama, nomor, atau alamat',
                  hintStyle: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textGrey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // List of Pelanggan (hasil pencarian)
          Expanded(
            child: _filteredPelangganList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada data pelanggan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPelangganList.length,
                    itemBuilder: (context, index) {
                      final pelanggan = _filteredPelangganList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PelangganCard(
                          name: pelanggan['name']!,
                          phone: pelanggan['phone']!,
                          alamat: pelanggan['alamat']!,
                          onEdit: () async {
                            final updatedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TambahPelangganScreen(pelanggan: pelanggan),
                              ),
                            );
                            if (updatedData != null) {
                              setState(() {
                                final originalIndex =
                                    _pelangganList.indexOf(pelanggan);
                                _pelangganList[originalIndex] = updatedData;
                                _filterPelanggan(); // update tampilan
                              });
                            }
                          },
                          onDelete: () {
                            _showDeleteDialog(context, pelanggan['name']!);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newPelanggan = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahPelangganScreen(),
            ),
          );

          if (newPelanggan != null) {
            setState(() {
              _pelangganList.add(newPelanggan);
              _filterPelanggan(); // update hasil search juga
            });
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.textWhite),
        label: const Text(
          'Tambah',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Pelanggan'),
          content: Text('Apakah Anda yakin ingin menghapus $name?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pelangganList.removeWhere((p) => p['name'] == name);
                  _filterPelanggan();
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Pelanggan Card Widget
class PelangganCard extends StatelessWidget {
  final String name;
  final String phone;
  final String alamat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PelangganCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.alamat,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama
          Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: AppColors.textGrey),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Nomor Telepon
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 20, color: AppColors.textGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.labelSuccess.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.labelSuccess,
                  ),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Alamat
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 20, color: AppColors.textGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alamat,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.error,
                  ),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

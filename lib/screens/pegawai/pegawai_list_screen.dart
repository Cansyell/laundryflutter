import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'pegawai_form_screen.dart';

class PegawaiListScreen extends StatefulWidget {
  const PegawaiListScreen({Key? key}) : super(key: key);

  @override
  State<PegawaiListScreen> createState() => _PegawaiListScreenState();
}

class _PegawaiListScreenState extends State<PegawaiListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Data pegawai (asli)
  final List<Map<String, String>> _pegawaiList = [
    {
      'name': 'Lala',
      'phone': '08234567890',
      'email': 'Lalala@gmail.com',
    },
    {
      'name': 'Lulu',
      'phone': '08122333456',
      'email': 'Lululu@gmail.com',
    },
    {
      'name': 'Budi',
      'phone': '085212345678',
      'email': 'budi@gmail.com',
    },
  ];

  // Data yang difilter berdasarkan pencarian
  List<Map<String, String>> _filteredPegawaiList = [];

  @override
  void initState() {
    super.initState();
    _filteredPegawaiList = List.from(_pegawaiList);

    // setiap kali text berubah, update hasil pencarian
    _searchController.addListener(_filterPegawai);
  }

  void _filterPegawai() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPegawaiList = _pegawaiList.where((pegawai) {
        final name = pegawai['name']!.toLowerCase();
        final phone = pegawai['phone']!.toLowerCase();
        final email = pegawai['email']!.toLowerCase();
        return name.contains(query) || phone.contains(query) || email.contains(query);
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
          'Daftar Pegawai',
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
                  hintText: 'Cari nama, nomor, atau email',
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

          // List of Pegawai (hasil pencarian)
          Expanded(
            child: _filteredPegawaiList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada data pegawai',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPegawaiList.length,
                    itemBuilder: (context, index) {
                      final pegawai = _filteredPegawaiList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PegawaiCard(
                          name: pegawai['name']!,
                          phone: pegawai['phone']!,
                          email: pegawai['email']!,
                          onEdit: () async {
                            final updatedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TambahPegawaiScreen(pegawai: pegawai),
                              ),
                            );
                            if (updatedData != null) {
                              setState(() {
                                final originalIndex =
                                    _pegawaiList.indexOf(pegawai);
                                _pegawaiList[originalIndex] = updatedData;
                                _filterPegawai(); // update tampilan
                              });
                            }
                          },
                          onDelete: () {
                            _showDeleteDialog(context, pegawai['name']!);
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
          final newPegawai = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahPegawaiScreen(),
            ),
          );

          if (newPegawai != null) {
            setState(() {
              _pegawaiList.add(newPegawai);
              _filterPegawai(); // update hasil search juga
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
          title: const Text('Hapus Pegawai'),
          content: Text('Apakah Anda yakin ingin menghapus $name?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pegawaiList.removeWhere((p) => p['name'] == name);
                  _filterPegawai();
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

// Pegawai Card Widget
class PegawaiCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PegawaiCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
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
          Row(
            children: [
              Icon(Icons.email_outlined, size: 20, color: AppColors.textGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    decoration: TextDecoration.underline,
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

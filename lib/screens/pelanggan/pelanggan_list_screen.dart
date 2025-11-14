import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/customer_controller.dart';
import '../../model/customer_model.dart';
import 'pelanggan_form_screen.dart'; // Sesuaikan path

class PelangganListScreen extends StatelessWidget {
  const PelangganListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController()); // Pastikan controller aktif
    final searchController = TextEditingController();

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
          // 🔹 Search Bar — gunakan Obx untuk binding search
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Cari nama, nomor, atau alamat',
                  hintStyle: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Daftar Pelanggan — hanya gunakan Obx
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filtered = controller.filteredCustomers;

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.isNotEmpty
                        ? 'Tidak ada hasil untuk "${controller.searchQuery.value}"'
                        : 'Belum ada data pelanggan',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchCustomers,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final customer = filtered[index];
                    final id = customer.id ?? 'temp_${index}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PelangganCard(
                        key: ValueKey(id), // ✅ Aman karena id tidak null
                        name: customer.name,
                        phone: customer.phone ?? '-',
                        alamat: customer.address ?? '-',
                        onEdit: () {
                          Get.to(() => TambahPelangganScreen(customer: customer));
                        },
                        onDelete: () {
                          _showDeleteDialog(context, customer, controller);
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const TambahPelangganScreen());
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

  void _showDeleteDialog(
      BuildContext context, CustomerModel customer, CustomerController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: Text('Yakin hapus "${customer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // tutup dialog
              controller.deleteCustomer(customer.id!);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// 🔹 PelangganCard tetap sama — tidak perlu perubahan
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
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
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
              Icon(Icons.location_on_outlined, size: 20, color: AppColors.textGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alamat,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
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
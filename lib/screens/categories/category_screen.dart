// lib/screens/categories/category_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/category_controller.dart'; // Sesuaikan path
import 'category_form_screen.dart'; // Sesuaikan path
import '../../../config/app_colors.dart';


class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  late final CategoryController controller;

  @override
  void initState() {
    super.initState();
    // Ambil controller yang sudah di-put dari drawer
    controller = Get.find<CategoryController>(tag: 'category');
  }

  @override
  void dispose() {
    // Hapus controller saat halaman ditutup
    Get.delete<CategoryController>(tag: 'category');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Kategori', style: TextStyle(color: AppColors.textWhite)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kategori...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.textWhite,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = controller.categories;
                if (list.isEmpty) {
                  return const Center(child: Text('Belum ada kategori'));
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            item.type ?? '-',
                            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const CategoryFormScreen());
        },
        backgroundColor: AppColors.primary,
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textWhite),
        ),
        icon: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }
}
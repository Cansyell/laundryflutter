// lib/screens/categories/category_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import 'category_form_screen.dart'; // Sesuaikan path jika berbeda
import '../../config/app_colors.dart';
import '../../model/category_model.dart';

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
    // Ambil controller yang sudah di-put dari tempat lain (misal: drawer)
    // Pastikan controller sudah di-put sebelum ke halaman ini
    controller = Get.find<CategoryController>(tag: 'category');
  }

  // ❌ JANGAN hapus controller di sini karena form edit masih butuh
  // Karena form dan list berbagi controller yang sama
  @override
  void dispose() {
    // Get.delete<CategoryController>(tag: 'category'); // <-- DIHAPUS / DIBERI KOMENTAR
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
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.textWhite,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              // Optional: tambahkan logika pencarian jika diperlukan
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = controller.categories;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada kategori',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return GestureDetector(
                      onTap: () {
                        // Buka form dalam mode EDIT
                        Get.to(() => CategoryFormScreen(category: item));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item.type ?? '-',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
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
          // Buka form dalam mode TAMBAH
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
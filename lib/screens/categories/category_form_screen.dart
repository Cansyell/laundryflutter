// lib/pages/category_form_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/category_controller.dart';
import '../../model/category_model.dart'; // Pastikan path ini benar

class CategoryFormScreen extends StatefulWidget {
  // Parameter opsional: jika null → mode tambah, jika ada → mode edit
  final CategoryModel? category;

  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  late final CategoryController _controller;
  final List<String> _units = ['PCS', 'KG', 'METER', 'LOAD'];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CategoryController>(tag: 'category');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.category != null) {
        // Mode edit
        _controller.nameController.text = widget.category!.name;
        _controller.selectedUnit.value = widget.category!.type ?? '';
      } else {
        // Mode tambah
        _controller.resetForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.category == null ? 'Tambah Kategori' : 'Edit Kategori',
          style: const TextStyle(color: AppColors.textWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Kategori',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller.nameController,
              decoration: InputDecoration(
                hintText: 'Nama Kategori',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.list_alt_rounded, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Satuan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _controller.selectedUnit.value.isEmpty
                        ? null
                        : _controller.selectedUnit.value,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Pilih Satuan',
                      hintStyle: TextStyle(color: AppColors.textGrey),
                    ),
                    items: _units
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(
                                unit,
                                style: const TextStyle(color: AppColors.textPrimary),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _controller.selectedUnit.value = value;
                      }
                    },
                  ),
                )),
            const Spacer(),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                    onPressed: _controller.isSubmitting.value
                        ? null
                        : widget.category == null
                            ? _controller.createCategory
                            : () => _controller.updateCategory(widget.category!.id!),
                    child: _controller.isSubmitting.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            widget.category == null ? 'Simpan' : 'Perbarui',
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                )),
            // 👇 Tombol HAPUS - hanya muncul di mode edit
            if (widget.category != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _controller.isSubmitting.value
                      ? null
                      : () async {
                          // Konfirmasi hapus
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Konfirmasi Hapus"),
                              content: Text("Yakin ingin menghapus kategori '${widget.category!.name}'?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            _controller.deleteCategory(widget.category!.id!);
                          }
                        },
                  child: const Text(
                    "Hapus",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

 

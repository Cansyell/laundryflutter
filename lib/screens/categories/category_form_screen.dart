// lib/pages/category_form_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/category_controller.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  late final CategoryController _controller;

  // Satuan tetap di controller, tapi bisa juga diambil dari sini
  final List<String> _units = ['PCS', 'KG', 'METER', 'LOAD'];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CategoryController>(tag: 'category');

    // Reset form saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Tambah Kategori',
          style: TextStyle(color: AppColors.textWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
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
                          : _controller.createCategory,
                      child: _controller.isSubmitting.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
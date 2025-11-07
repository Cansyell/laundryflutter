// lib/pages/service_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/service_controller.dart';
import '../../model/service_model.dart';
import '../../model/category_model.dart';

class ServiceFormScreen extends StatefulWidget {
  final ServiceModel? service;

  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  late final ServiceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ServiceController>(tag: 'service');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.service != null) {
        // Mode edit - set form dari service
        _controller.setFormFromService(widget.service!);
      } else {
        // Mode tambah - reset form
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
          widget.service == null ? 'Tambah Layanan' : 'Edit Layanan',
          style: const TextStyle(color: AppColors.textWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Layanan
            _buildLabel('Nama Layanan *'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller.nameController,
              decoration: InputDecoration(
                hintText: 'Contoh: Cuci Setrika Express',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.local_laundry_service, color: AppColors.textSecondary),
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

            // Kategori (Dropdown Searchable)
            _buildLabel('Kategori'),
            const SizedBox(height: 8),
            Obx(() {
              // Cek apakah categories sudah dimuat
              if (_controller.isCategoriesLoading.value) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Memuat kategori...', style: TextStyle(color: AppColors.textGrey)),
                    ],
                  ),
                );
              }

              // Jika mode edit dan category sudah ada, pastikan ada di list
              CategoryModel? selectedValue = _controller.selectedCategory.value;
              
              // Validasi: pastikan selectedValue ada di dalam categories list
              if (selectedValue != null) {
                bool categoryExists = _controller.categories.any(
                  (cat) => cat.id == selectedValue.id
                );
                
                if (!categoryExists) {
                  // Jika category tidak ada di list, tambahkan
                  _controller.categories.insert(0, selectedValue);
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<CategoryModel>(
                  value: selectedValue,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Pilih Kategori',
                    hintStyle: TextStyle(color: AppColors.textGrey),
                    prefixIcon: Icon(Icons.category, color: AppColors.textSecondary),
                  ),
                  items: _controller.categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              '${category.name} (${category.type ?? '-'})',
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _controller.selectedCategory.value = value;
                  },
                  isExpanded: true,
                ),
              );
            }),
            const SizedBox(height: 20),

            // Harga
            _buildLabel('Harga *'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller.priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.attach_money, color: AppColors.textSecondary),
                prefixText: 'Rp ',
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

            // Diskon
            _buildLabel('Diskon'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller.discountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.discount, color: AppColors.textSecondary),
                prefixText: 'Rp ',
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

            // Min Order
            _buildLabel('Minimum Order'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller.minOrderController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '1',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                prefixIcon: const Icon(Icons.shopping_cart, color: AppColors.textSecondary),
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

            // Estimasi (Number + Unit)
            _buildLabel('Estimasi Pengerjaan'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _controller.estimateNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: const TextStyle(color: AppColors.textGrey),
                      prefixIcon: const Icon(Icons.timer, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _controller.selectedEstimateUnit.value,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: _controller.estimateUnits
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
                              _controller.selectedEstimateUnit.value = value;
                            }
                          },
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Deskripsi
            _buildLabel('Deskripsi'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Deskripsi layanan (opsional)',
                hintStyle: const TextStyle(color: AppColors.textGrey),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan/Perbarui
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
                        : () async {
                            if (widget.service == null) {
                              await _controller.createService();
                            } else {
                              await _controller.updateService(widget.service!.id!);
                            }
                          },
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
                            widget.service == null ? 'Simpan' : 'Perbarui',
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                )),

            // Tombol Hapus (hanya di mode edit)
            if (widget.service != null) ...[
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
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Konfirmasi Hapus"),
                              content: Text(
                                  "Yakin ingin menghapus layanan '${widget.service!.name}'?"),
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
                            await _controller.deleteService(widget.service!.id!);
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
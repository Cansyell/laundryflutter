import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/customer_controller.dart';
import '../../model/customer_model.dart';

class TambahPelangganScreen extends StatefulWidget {
  final CustomerModel? customer;

  const TambahPelangganScreen({Key? key, this.customer}) : super(key: key);

  @override
  State<TambahPelangganScreen> createState() => _TambahPelangganScreenState();
}

class _TambahPelangganScreenState extends State<TambahPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  late final CustomerController _controller;

  bool get isEditMode => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CustomerController>();
    _controller.resetForm();

    if (isEditMode && widget.customer != null) {
      // Delay sedikit untuk hindari conflict controller
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.nameController.text = widget.customer!.name;
        _controller.phoneController.text = widget.customer!.phone ?? '';
        _controller.addressController.text = widget.customer!.address ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEditMode ? 'Edit Pelanggan' : 'Tambah Pelanggan',
          style: const TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nama Pelanggan
            _buildLabel('Nama Pelanggan', isRequired: true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.nameController,
              hintText: 'Nama Pelanggan',
              prefixIcon: Icons.person_outline,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Nama pelanggan harus diisi'
                  : null,
            ),
            const SizedBox(height: 16),

            // No. Telp / WA
            _buildLabel('No. Telp / WA', isRequired: false),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.phoneController,
              hintText: 'No. Telp / WA',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            const Text(
              'No. Telp harus diawali dengan angka 0',
              style: TextStyle(fontSize: 12, color: AppColors.info),
            ),
            const SizedBox(height: 16),

            // Alamat
            _buildLabel('Alamat', isRequired: false),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _controller.addressController,
              hintText: 'Alamat lengkap pelanggan',
              prefixIcon: Icons.location_on_outlined,
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Tombol Simpan / Perbarui
            Obx(() => SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _controller.isSubmitting.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              if (isEditMode && widget.customer != null) {
                                _controller.updateCustomer(widget.customer!.id!);
                              } else {
                                _controller.createCustomer();
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      disabledBackgroundColor:
                          AppColors.primary.withOpacity(0.6),
                    ),
                    child: _controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.textWhite,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEditMode ? 'Perbarui' : 'Simpan',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textWhite,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: '*',
              style: TextStyle(color: AppColors.error),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: AppColors.textGrey, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
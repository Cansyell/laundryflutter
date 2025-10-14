import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

// ============ REUSABLE FORM SCREEN ============
class PackageFormScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initialData;

  const PackageFormScreen({
    super.key,
    this.isEdit = false,
    this.initialData,
  });

  @override
  State<PackageFormScreen> createState() => _PackageFormScreenState();
}

class _PackageFormScreenState extends State<PackageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _minOrderController;
  late TextEditingController _unitController;
  late TextEditingController _estimationController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initialData or empty string
    _nameController = TextEditingController(
        text: widget.initialData?['name'] ?? '');
    _categoryController = TextEditingController(
        text: widget.initialData?['category'] ?? '');
    _minOrderController = TextEditingController(
        // Using .toString() handles cases where minOrder might be passed as an int/double
        text: widget.initialData?['minOrder']?.toString() ?? ''); 
    _unitController = TextEditingController(
        text: widget.initialData?['unit'] ?? '');
    _estimationController = TextEditingController(
        text: widget.initialData?['estimation'] ?? '');
    _priceController = TextEditingController(
        text: widget.initialData?['price']?.toString() ?? '');
    _discountController = TextEditingController(
        text: widget.initialData?['discount']?.toString() ?? '');
    _descriptionController = TextEditingController(
        text: widget.initialData?['description'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _minOrderController.dispose();
    _unitController.dispose();
    _estimationController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Validate the form before saving
    if (_formKey.currentState!.validate()) {
      // Collect data from controllers
      final data = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'minOrder': _minOrderController.text,
        'unit': _unitController.text,
        'estimation': _estimationController.text,
        'price': _priceController.text,
        'discount': _discountController.text,
        'description': _descriptionController.text,
      };
      
      // Pass the data back to the previous screen
      Navigator.pop(context, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure scaffold background uses defined color
      backgroundColor: AppColors.homeBackground, 
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Ubah Paket' : 'Tambah Paket',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Paket (Diberi validasi contoh)
                    CustomFormField(
                      label: 'Nama Paket',
                      controller: _nameController,
                      icon: Icons.article_outlined,
                      hintText: 'Cuci Kering + Setrika',
                      // Simple mandatory validation for demonstration
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama paket wajib diisi';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Pilih Kategori
                    const FormLabel(label: 'Pilih Kategori'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _categoryController,
                            hintText: 'Pilih Kategori',
                            readOnly: true,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textGrey,
                            ),
                            onTap: () {
                              // TODO: Implement category picker dialog
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.textWhite),
                            onPressed: () {
                              // TODO: Implement edit category action
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Min Order & Satuan
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomFormField(
                            label: 'Min. Order',
                            controller: _minOrderController,
                            icon: Icons.shopping_basket_outlined,
                            hintText: '3',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: CustomFormField(
                            label: 'Satuan',
                            controller: _unitController,
                            icon: Icons.scale_outlined,
                            hintText: 'KG',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Estimasi
                    CustomFormField(
                      label: 'Estimasi',
                      controller: _estimationController,
                      icon: Icons.access_time_outlined,
                      hintText: '3 Hari',
                    ),

                    const SizedBox(height: 16),

                    // Harga
                    CustomFormField(
                      label: 'Harga',
                      controller: _priceController,
                      icon: Icons.sell_outlined,
                      hintText: '6000',
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // Diskon
                    CustomFormField(
                      label: 'Diskon (Rp)',
                      controller: _discountController,
                      icon: Icons.local_offer_outlined, // Icon updated
                      hintText: 'Diskon (IDR)',
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // Keterangan
                    CustomFormField(
                      label: 'Keterangan',
                      controller: _descriptionController,
                      icon: Icons.description_outlined, // Icon updated
                      hintText: 'Tulis keterangan tambahan di sini...',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Tombol Simpan
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground, // Use specific color for background
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ REUSABLE COMPONENTS ============

// Label untuk form field
class FormLabel extends StatelessWidget {
  final String label;

  const FormLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// Custom Form Field dengan label
class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: label),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          icon: icon,
          hintText: hintText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          suffixIcon: suffixIcon,
          validator: validator,
        ),
      ],
    );
  }
}

// Custom Text Field (tanpa label)
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.icon,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      // If validator is null, use a default validator that always returns null (valid)
      validator: validator, 
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.textGrey, size: 20)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5), // Increased opacity for focus
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.textDanger, width: 1.0), // Using corrected color
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.textDanger, width: 1.5), // Using corrected color
        ),
      ),
    );
  }
}

// ============ CARA PENGGUNAAN (Contoh) ============
/*
// Untuk Edit Package:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => PackageFormScreen(
//       isEdit: true,
//       initialData: {
//         'name': 'Cuci Kering + Setrika',
//         'category': 'Kiloan',
//         'minOrder': 3,
//         'unit': 'KG',
//         'estimation': '3 Hari',
//         'price': 6000,
//         'discount': 500,
//         'description': 'Layanan standar untuk pakaian harian, sudah termasuk lipat dan kemas.'
//       },
//     ),
//   ),
// );
//
// Untuk Tambah Package:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => const PackageFormScreen(),
//   ),
// );
*/
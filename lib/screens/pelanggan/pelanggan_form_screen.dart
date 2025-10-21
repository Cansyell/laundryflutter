import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class TambahPelangganScreen extends StatefulWidget {
  final Map<String, String>? pelanggan; // null → tambah, ada data → edit

  const TambahPelangganScreen({Key? key, this.pelanggan}) : super(key: key);

  @override
  State<TambahPelangganScreen> createState() => _TambahPelangganScreenState();
}

class _TambahPelangganScreenState extends State<TambahPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool get isEditMode => widget.pelanggan != null;

  @override
  void initState() {
    super.initState();
    // Isi form kalau mode edit
    if (isEditMode) {
      _nameController.text = widget.pelanggan!['name'] ?? '';
      _phoneController.text = widget.pelanggan!['phone'] ?? '';
      // 🔧 Perbaikan di sini → ganti 'address' jadi 'alamat'
      _addressController.text = widget.pelanggan!['alamat'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
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
              controller: _nameController,
              hintText: 'Nama Pelanggan',
              prefixIcon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Nama pelanggan harus diisi' : null,
            ),
            const SizedBox(height: 16),

            // No. Telp / WA
            _buildLabel('No. Telp / WA', isRequired: true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _phoneController,
              hintText: 'No. Telp / WA',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'No. Telp / WA harus diisi' : null,
            ),
            const SizedBox(height: 8),
            const Text(
              'No. Telp harus diawali dengan angka 0',
              style: TextStyle(fontSize: 12, color: AppColors.info),
            ),
            const SizedBox(height: 16),

            // Alamat
            _buildLabel('Alamat', isRequired: true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _addressController,
              hintText: 'Alamat lengkap pelanggan',
              prefixIcon: Icons.location_on_outlined,
              keyboardType: TextInputType.streetAddress,
              validator: (v) => v!.isEmpty ? 'Alamat harus diisi' : null,
            ),
            const SizedBox(height: 24),

            // Tombol Simpan / Perbarui
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newData = {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      // 🔧 Ganti key di sini juga agar konsisten
                      'alamat': _addressController.text,
                    };

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditMode
                              ? 'Data pelanggan berhasil diperbarui'
                              : 'Data pelanggan berhasil disimpan',
                        ),
                        backgroundColor: AppColors.labelSuccess,
                      ),
                    );

                    Navigator.pop(context, newData);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isEditMode ? 'Perbarui' : 'Simpan',
                  style: const TextStyle(
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
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

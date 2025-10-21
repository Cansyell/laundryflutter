import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class TambahPegawaiScreen extends StatefulWidget {
  final Map<String, String>? pegawai; // null → tambah, ada data → edit

  const TambahPegawaiScreen({Key? key, this.pegawai}) : super(key: key);

  @override
  State<TambahPegawaiScreen> createState() => _TambahPegawaiScreenState();
}

class _TambahPegawaiScreenState extends State<TambahPegawaiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool get isEditMode => widget.pegawai != null;

  @override
  void initState() {
    super.initState();
    // Isi form kalau mode edit
    if (isEditMode) {
      _nameController.text = widget.pegawai!['name'] ?? '';
      _phoneController.text = widget.pegawai!['phone'] ?? '';
      _emailController.text = widget.pegawai!['email'] ?? '';
      // Password tidak diisi saat edit demi keamanan
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          isEditMode ? 'Edit Pegawai' : 'Tambah Pegawai',
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
            // Nama Pegawai
            _buildLabel('Nama Pegawai', isRequired: true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              hintText: 'Nama Pegawai',
              prefixIcon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Nama pegawai harus diisi' : null,
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

            // Email
            _buildLabel('Email', isRequired: true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email harus diisi';
                if (!v.contains('@')) return 'Email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password hanya muncul di mode tambah
            if (!isEditMode) ...[
              _buildLabel('Password', isRequired: true),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password harus diisi';
                  if (v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ] else
              const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newData = {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'email': _emailController.text,
                    };
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditMode
                            ? 'Data pegawai berhasil diperbarui'
                            : 'Data pegawai berhasil disimpan'),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

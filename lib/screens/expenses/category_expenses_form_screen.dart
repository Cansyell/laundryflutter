import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class CategoryExpensesFormScreen extends StatefulWidget {
  final bool isEdit;
  final String? namaAwal;
  final String? keteranganAwal;

  const CategoryExpensesFormScreen({
    super.key,
    this.isEdit = false,
    this.namaAwal,
    this.keteranganAwal,
  });

  @override
  State<CategoryExpensesFormScreen> createState() => _CategoryExpensesFormScreenState();
}

class _CategoryExpensesFormScreenState extends State<CategoryExpensesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _keteranganController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaAwal ?? '');
    _keteranganController = TextEditingController(text: widget.keteranganAwal ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Kategori Pengeluaran' : 'Tambah Kategori Pengeluaran'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F9FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Kategori', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Nama Kategori',
                  prefixIcon: const Icon(Icons.list_alt_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              const Text('Keterangan', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _keteranganController,
                maxLines: 4,
                maxLength: 150,
                decoration: InputDecoration(
                  hintText: 'Keterangan',
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 💾 Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, {
                        'nama': _namaController.text,
                        'keterangan': _keteranganController.text,
                      });
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

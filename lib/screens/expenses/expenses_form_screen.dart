import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class ExpenseFormScreen extends StatefulWidget {
  final bool isEdit;

  const ExpenseFormScreen({super.key, this.isEdit = false});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final TextEditingController _pengeluaranController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  String? _selectedMetode;
  String? _selectedKategori;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.isEdit ? 'Edit Pengeluaran' : 'Tambah Pengeluaran'),
      ),
      backgroundColor: const Color(0xFFF5F9FF),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🗓️ Tanggal Pengeluaran
            const Text(
              'Tanggal Pengeluaran',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _buildDatePicker(),

            const SizedBox(height: 16),

            // 💳 Metode Pembayaran
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _buildDropdown(
              hint: 'Pilih Metode Pembayaran',
              value: _selectedMetode,
              items: const ['Transfer Bank', 'QRIS', 'Tunai'],
              onChanged: (value) => setState(() => _selectedMetode = value),
            ),

            const SizedBox(height: 16),

            // 🏷️ Kategori
            const Text(
              'Pilih Kategori',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _buildDropdown(
              hint: 'Pilih Kategori',
              value: _selectedKategori,
              items: const [
                'Listrik & Air',
                'Deterjen & Pewangi',
                'Perlengkapan Laundry',
                'Lainnya'
              ],
              onChanged: (value) => setState(() => _selectedKategori = value),
            ),

            const SizedBox(height: 16),

            // 🧾 Pengeluaran
            const Text(
              'Pengeluaran',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: _pengeluaranController,
              hint: 'Pengeluaran',
              icon: Icons.payments_outlined,
            ),

            const SizedBox(height: 16),

            // 💰 Jumlah
            const Text(
              'Jumlah',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: _jumlahController,
              hint: 'Jumlah',
              icon: Icons.receipt_long_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // 📝 Keterangan
            const Text(
              'Keterangan',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: _keteranganController,
              hint: 'Keterangan',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            // 💾 Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📅 Date Picker Field
  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          setState(() => _selectedDate = pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.grey),
            const SizedBox(width: 10),
            Text(
              _selectedDate == null
                  ? 'Pilih Tanggal'
                  : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: _selectedDate == null ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔽 Dropdown Widget
  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: Text(hint, style: const TextStyle(color: Colors.grey)),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // 🧠 Reusable Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

// lib/widgets/dialogs/tambah_pelanggan_dialog.dart
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class TambahPelangganDialog extends StatefulWidget {
  const TambahPelangganDialog({Key? key}) : super(key: key);

  @override
  State<TambahPelangganDialog> createState() => _TambahPelangganDialogState();
}

class _TambahPelangganDialogState extends State<TambahPelangganDialog> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    noTelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Title
            const Text(
              'Tambah Pelanggan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Input Nama
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: 'Nama',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Input Alamat
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: alamatController,
                decoration: InputDecoration(
                  hintText: 'Alamat',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Input No Telp
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: noTelpController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'No Telp',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validasi input
                      if (namaController.text.isEmpty ||
                          alamatController.text.isEmpty ||
                          noTelpController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mohon isi semua field'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      // Return data pelanggan
                      Navigator.pop(context, {
                        'nama': namaController.text,
                        'alamat': alamatController.text,
                        'noTelp': noTelpController.text,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Function helper untuk menampilkan dialog
Future<Map<String, String>?> showTambahPelangganDialog(BuildContext context) {
  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const TambahPelangganDialog();
    },
  );
}
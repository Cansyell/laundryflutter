// lib/widgets/dialogs/konfirmasi_pesanan_dialog.dart
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

enum TipeKonfirmasi {
  proses,
  selesai,
  ambil,
  hapus,
  transaksi,
}

class KonfirmasiPesananDialog extends StatelessWidget {
  final TipeKonfirmasi tipe;
  final VoidCallback? onKonfirmasi;

  const KonfirmasiPesananDialog({
    Key? key,
    required this.tipe,
    this.onKonfirmasi,
  }) : super(key: key);

  String _getTitle() {
    switch (tipe) {
      case TipeKonfirmasi.proses:
        return 'Konfirmasi Pesanan';
      case TipeKonfirmasi.selesai:
        return 'Konfirmasi Pesanan';
      case TipeKonfirmasi.ambil:
        return 'Konfirmasi Pesanan';
      case TipeKonfirmasi.hapus:
        return 'Konfirmasi Pesanan';
      case TipeKonfirmasi.transaksi:
        return 'Konfirmasi Transaksi';
    }
  }

  String _getMessage() {
    switch (tipe) {
      case TipeKonfirmasi.proses:
        return 'Apakah Anda yakin ingin memproses pesanan?';
      case TipeKonfirmasi.selesai:
        return 'Apakah Anda yakin ingin menyelesaikan pesanan?';
      case TipeKonfirmasi.ambil:
        return 'Apakah Anda yakin ingin pesanan diambil?';
      case TipeKonfirmasi.hapus:
        return 'Apakah Anda yakin ingin menghapus pesanan?';
      case TipeKonfirmasi.transaksi:
        return 'Apakah Anda yakin ingin melanjutkan transaksi?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              _getTitle(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Warning Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 3,
                ),
              ),
              child: const Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Message
            Text(
              _getMessage(),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Buttons
            Row(
              children: [
                // Batal Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Konfirmasi Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onKonfirmasi?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C6FD8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 15,
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

// Helper function untuk menampilkan dialog
Future<bool?> showKonfirmasiPesananDialog(
  BuildContext context, {
  required TipeKonfirmasi tipe,
  VoidCallback? onKonfirmasi,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return KonfirmasiPesananDialog(
        tipe: tipe,
        onKonfirmasi: onKonfirmasi,
      );
    },
  );
}
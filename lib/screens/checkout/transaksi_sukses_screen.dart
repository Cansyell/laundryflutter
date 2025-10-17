import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/dialogs/nota_pembayaran.dart';
import '../detail/detail_screen.dart';
import '../../model/status_transaksi.dart';

class TransaksiSuksesScreen extends StatelessWidget {
  final String orderId;
  final String namaPelanggan;
  final String tanggalTransaksi;
  final String perkiraanSelesai;
  final String totalAmount;

  const TransaksiSuksesScreen({
    Key? key,
    required this.orderId,
    required this.namaPelanggan,
    required this.tanggalTransaksi,
    required this.perkiraanSelesai,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textWhite,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Illustration
                  Image.asset(
                    'assets/images/sukses.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),

                  // Success Message
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                      children: [
                        const TextSpan(text: 'Horee, Transaksi '),
                        TextSpan(
                          text: totalAmount,
                          style: const TextStyle(
                            color: AppColors.textSuccess,
                          ),
                        ),
                        const TextSpan(text: ' Berhasil'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Order Details Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Order ID', orderId),
                        const SizedBox(height: 16),
                        _buildDetailRow('Nama Pelanggan', namaPelanggan),
                        const SizedBox(height: 16),
                        _buildDetailRow('Tanggal Transaksi', tanggalTransaksi),
                        const SizedBox(height: 16),
                        _buildDetailRow('Perkiraan Selesai', perkiraanSelesai),
                        const SizedBox(height: 24),

                        // Tombol Cetak Nota
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => NotaPembayaranWidget(
                                  items: [
                                    {"nama": "Bed Cover", "qty": 1, "harga": "16.000"},
                                    {"nama": "Cuci Kering + Lipat", "qty": 4, "harga": "40.000"},
                                    {"nama": "Kantong Laundry", "qty": 1, "harga": "5.000"},
                                    {"nama": "Penanganan Khusus", "qty": 1, "harga": "10.000"},
                                  ],
                                  total: "71.000",
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.labelSuccess,
                              foregroundColor: AppColors.textWhite,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Cetak Nota',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tombol ke Halaman Detail
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailTransaksiScreen(
                                    kodeTransaksi: orderId,
                                    tanggalTransaksi: tanggalTransaksi,
                                    namaCustomer: namaPelanggan,
                                    alamatCustomer: 'Jl. Makadari Blok ABC',
                                    nomorHp: '08123456789',
                                    statusAwal: StatusTransaksi.antrian,
                                    statusPembayaran: 'Bayar Nanti',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              foregroundColor: AppColors.textWhite,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Ke Halaman Detail',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tombol Buat Nota Baru
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Buat Nota Baru',
                      style: TextStyle(
                        color: AppColors.btnWarning,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.btnWarning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

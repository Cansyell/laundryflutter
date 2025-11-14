import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../model/customer_model.dart';
import '../../model/service_model.dart';
import '../../model/nota_service_item.dart';
import '../../widgets/dialogs/nota_pembayaran.dart';
import '../detail/detail_screen.dart';
import '../../model/status_transaksi.dart';

class TransaksiSuksesScreen extends StatelessWidget {
  final String transactionId;
  final CustomerModel customer;
  final DateTime transactionDate;
  final DateTime estimatedCompletion;
  final double totalAmount;
  final List<NotaServiceItem> services;
  final double biayaPenanganan;
  final double biayaKantong;
  final String statusPembayaran;

  const TransaksiSuksesScreen({
    Key? key,
    required this.transactionId,
    required this.customer,
    required this.transactionDate,
    required this.estimatedCompletion,
    required this.totalAmount,
    required this.services,
    required this.biayaPenanganan,
    required this.biayaKantong,
    required this.statusPembayaran,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      final formatter = DateFormat('dd MMM yyyy', 'id_ID');
      return formatter.format(date);
    }

    final List<Map<String, dynamic>> notaItems = [
      ...services.map((item) => {
            "nama": item.name,
            "qty": item.quantity,
            "harga": (item.price * item.quantity).toInt(),
            "satuan": item.type,
          }),
      if (biayaPenanganan > 0)
        {
          "nama": "Biaya Penanganan",
          "qty": 1,
          "harga": biayaPenanganan.toInt(),
        },
      if (biayaKantong > 0)
        {
          "nama": "Biaya Kantong",
          "qty": 1,
          "harga": biayaKantong.toInt(),
        },
    ];

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
                  Image.asset(
                    'assets/images/sukses.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),

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
                          text: _formatIDR(totalAmount.toInt()),
                          style: const TextStyle(
                            color: AppColors.textSuccess,
                          ),
                        ),
                        const TextSpan(text: ' Berhasil!'),
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
                        _buildDetailRow('Order ID', transactionId),
                        const SizedBox(height: 16),
                        _buildDetailRow('Nama Pelanggan', customer.name),
                        if (customer.phone != null) ...[
                          const SizedBox(height: 16),
                          _buildDetailRow('No. HP', customer.phone!),
                        ],
                        const SizedBox(height: 16),
                        _buildDetailRow('Tanggal Transaksi', formatDate(transactionDate)),
                        const SizedBox(height: 16),
                        _buildDetailRow('Estimasi Selesai', formatDate(estimatedCompletion)),
                        const SizedBox(height: 24),

                        // Tombol Cetak Nota
                        if (services.isNotEmpty || biayaPenanganan > 0 || biayaKantong > 0)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => NotaPembayaranWidget(
                                    items: notaItems,
                                    total: _formatIDR(totalAmount.toInt()),
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
                        if (services.isEmpty && biayaPenanganan == 0 && biayaKantong == 0)
                          const Text(
                            "Tidak ada layanan.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
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
                                    kodeTransaksi: transactionId,
                                    tanggalTransaksi: formatDate(transactionDate),
                                    namaCustomer: customer.name,
                                    alamatCustomer: customer.address ?? '-',
                                    nomorHp: customer.phone ?? '-',
                                    statusAwal: StatusTransaksi.antrian,
                                    statusPembayaran: statusPembayaran == 'paid'
                                        ? 'Lunas'
                                        : 'Bayar Nanti',
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
                      Navigator.popUntil(context, (route) => route.isFirst);
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
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatIDR(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }
}

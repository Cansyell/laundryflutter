import 'package:flutter/material.dart';
import '../../model/status_transaksi.dart';

class DetailTransaksiScreen extends StatefulWidget {
  final String kodeTransaksi;
  final String tanggalTransaksi;
  final String namaCustomer;
  final String alamatCustomer;
  final String nomorHp;
  final StatusTransaksi statusAwal;
  final String statusPembayaran;

  const DetailTransaksiScreen({
    super.key,
    required this.kodeTransaksi,
    required this.tanggalTransaksi,
    required this.namaCustomer,
    required this.alamatCustomer,
    required this.nomorHp,
    required this.statusAwal,
    required this.statusPembayaran,
  });

  @override
  State<DetailTransaksiScreen> createState() => _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  late StatusTransaksi currentStatus;
  bool showAdditionalFees = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.statusAwal;
  }

  void _updateStatus(StatusTransaksi newStatus) {
    setState(() {
      currentStatus = newStatus;
      if (newStatus == StatusTransaksi.selesai) {
        showAdditionalFees = true;
      }
    });
  }

  Color _getStatusColor(StatusTransaksi status) {
    if (currentStatus.index >= status.index) {
      return const Color(0xFF4CAF50);
    }
    return Colors.grey.shade400;
  }

  String _getStatusLabel() {
    switch (currentStatus) {
      case StatusTransaksi.antrian:
        return 'Antrian';
      case StatusTransaksi.proses:
        return 'Proses';
      case StatusTransaksi.selesai:
        return 'Selesai';
    }
  }

  Color _getStatusBadgeColor() {
    switch (currentStatus) {
      case StatusTransaksi.antrian:
        return const Color(0xFFFFF3E0);
      case StatusTransaksi.proses:
        return const Color(0xFFE3F2FD);
      case StatusTransaksi.selesai:
        return const Color(0xFFE8F5E9);
    }
  }

  Color _getStatusTextColor() {
    switch (currentStatus) {
      case StatusTransaksi.antrian:
        return const Color(0xFFF57C00);
      case StatusTransaksi.proses:
        return const Color(0xFF1976D2);
      case StatusTransaksi.selesai:
        return const Color(0xFF4CAF50);
    }
  }

  Widget _buildActionButton() {
    switch (currentStatus) {
      case StatusTransaksi.antrian:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _updateStatus(StatusTransaksi.proses),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA726),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Proses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        );
      case StatusTransaksi.proses:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _updateStatus(StatusTransaksi.selesai),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Selesai',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        );
      case StatusTransaksi.selesai:
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesanan telah diambil')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Diambil',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifikasi telah dikirim')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2196F3), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ingatkan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2196F3)),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildProgressItem(StatusTransaksi status, String label) {
    final isActive = currentStatus.index >= status.index;
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: _getStatusColor(status), shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildItemRow(String item, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSubPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A99),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {}, // TODO: print nota
            icon: const Icon(Icons.print, color: Colors.white, size: 20),
            label: const Text('Print', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.kodeTransaksi,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E4A99)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: _getStatusBadgeColor(), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Icon(
                              currentStatus == StatusTransaksi.antrian
                                  ? Icons.access_time
                                  : currentStatus == StatusTransaksi.proses
                                      ? Icons.autorenew
                                      : Icons.check_circle,
                              size: 16,
                              color: _getStatusTextColor(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getStatusLabel(),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _getStatusTextColor()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tanggal Transaksi', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      Text(widget.tanggalTransaksi, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status Pembayaran', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      Text(
                        widget.statusPembayaran,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: widget.statusPembayaran.toLowerCase() == 'lunas'
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF57C00),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress Tracker
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  _buildProgressItem(StatusTransaksi.antrian, 'Antrian'),
                  Expanded(child: Container(height: 2, color: _getStatusColor(StatusTransaksi.proses))),
                  _buildProgressItem(StatusTransaksi.proses, 'Proses'),
                  Expanded(child: Container(height: 2, color: _getStatusColor(StatusTransaksi.selesai))),
                  _buildProgressItem(StatusTransaksi.selesai, 'Selesai'),
                ],
              ),
            ),

            // Info Pelanggan
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Info Pelanggan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E4A99))),
                  const SizedBox(height: 12),
                  _buildInfoRow('Nama', widget.namaCustomer),
                  const SizedBox(height: 8),
                  _buildInfoRow('Alamat', widget.alamatCustomer),
                  const SizedBox(height: 8),
                  _buildInfoRow('No Hp', widget.nomorHp),
                ],
              ),
            ),

            // Detail Transaksi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Transaksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E4A99))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        // TODO: mapping dari data asli item transaksi
                        _buildItemRow('Bed Cover x1 (PCS)', 'IDR 16.000'),
                        const SizedBox(height: 8),
                        _buildItemRow('Cuci Kering + Lipat x4 (KG)', 'IDR 40.000'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info Pembayaran
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Info Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E4A99))),
                  const SizedBox(height: 12),
                  _buildPaymentRow('Metode Pembayaran', 'Cash'),
                  const SizedBox(height: 8),
                  _buildPaymentRow('Sub Total', 'IDR 56.000'),
                  const SizedBox(height: 8),
                  _buildPaymentRow('Biaya Lain Lain', 'IDR 15.000'),
                  if (showAdditionalFees) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          _buildSubPaymentRow('+ Kantong Laundry x1', 'IDR 5.000'),
                          const SizedBox(height: 4),
                          _buildSubPaymentRow('+ Penanganan Khusus x1', 'IDR 10.000'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action Button
            Padding(padding: const EdgeInsets.all(16), child: _buildActionButton()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

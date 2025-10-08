import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

enum TxnStatus { waiting, process, done }

class TxnItem extends StatelessWidget {
  final String kode, tanggal, nama, nominal;
  final TxnStatus status;
  final bool isLunas;
  final VoidCallback? onTap;

  const TxnItem({
    super.key,
    required this.kode,
    required this.tanggal,
    required this.nama,
    required this.nominal,
    required this.status,
    required this.isLunas,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // kartu
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header: kode | tanggal
          Row(children: [
            Expanded(
              child: Text(
                kode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            Text(
              tanggal,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ]),
          const SizedBox(height: 8),

          // PERBAIKAN: Nama pelanggan dan nominal sejajar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                nominal,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          // PERBAIKAN: Tambah garis pembatas (divider)
          const SizedBox(height: 10),
          Divider(
            color: Colors.black.withOpacity(0.1),
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 10),

          // footer: chip status dengan icon | status lunas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Chip(
                text: status == TxnStatus.waiting
                    ? 'Antrian'
                    : status == TxnStatus.process
                        ? 'Proses'
                        : 'Selesai',
                icon: status == TxnStatus.waiting
                    ? Icons.access_time
                    : status == TxnStatus.process
                        ? Icons.local_laundry_service
                        : Icons.check_circle,
                bg: status == TxnStatus.waiting
                    ? const Color(0xFFFFF4DB)
                    : status == TxnStatus.process
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFE8F5E9),
                fg: status == TxnStatus.waiting
                    ? const Color(0xFFB7791F)
                    : status == TxnStatus.process
                        ? const Color(0xFF1976D2)
                        : const Color(0xFF2E7D32),
              ),
              Text(
                isLunas ? 'Lunas' : 'Belum Lunas',
                style: TextStyle(
                  color: isLunas ? AppColors.income : const Color(0xFFE53935),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // optional ripple tanpa ubah layout
    return onTap == null
        ? card
        : Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: card,
            ),
          );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color bg, fg;
  
  const _Chip({
    required this.text,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/common/balance_card.dart';
import '../../widgets/common/info_card.dart';
import '../../widgets/common/txn_item.dart';
import '../../widgets/common/bottom_nav.dart';
import '../../widgets/common/app_drawer.dart';
import '../detail/detail_screen.dart';
import '../../model/status_transaksi.dart';
import '../detail/transaction_list_screen.dart';
import '../service/service_list_screen.dart';
import '../setting/setting_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Builder(
                  builder: (ctx) => IconButton(
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                    icon: const Icon(Icons.menu, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lala Laundry', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      SizedBox(height: 2),
                      Text('adminlala', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceCard(
              dateText: '2025-04-22',
              balance: 'IDR 500,000',
              todayIncome: 'IDR 100,000',
              totalNota: '2',
              pemasukan: 'IDR 900,000',
              pengeluaran: 'IDR 400,000',
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: InfoCard(title: 'Pesanan Aktif', value: '1')),
                SizedBox(width: 12),
                Expanded(child: InfoCard(title: 'Lunas', value: '20')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transaksi Terkini', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Row(
                  children: [
                    Text('Selengkapnya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // list transaksi
            ListView.separated(
              itemCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final kode = i == 0 ? 'WASHIN-25042216500' : 'WASHIN-26042216500';
                final tanggal = i == 0 ? '2025-04-22 12:45' : '2025-07-25 15:02';
                final nama = i == 0 ? 'Budi Raharja' : 'Lilis';
                final nominal = i == 0 ? 'IDR 50,000' : 'IDR 70,000';
                final status = i == 0 ? TxnStatus.waiting : TxnStatus.process;
                final isLunas = i != 0;

                return TxnItem(
                  kode: kode.replaceAll('-', ' - '),
                  tanggal: tanggal,
                  nama: nama,
                  nominal: nominal,
                  status: status,
                  isLunas: isLunas,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailTransaksiScreen(
                          kodeTransaksi: kode,
                          tanggalTransaksi: i == 0 ? '22 April 2025, 12:45' : '05 Juli 2025, 15:02',
                          namaCustomer: nama,
                          alamatCustomer: 'JL.Makadari.Blok ABC',
                          nomorHp: '0890898989',
                          statusAwal: i == 0 ? StatusTransaksi.antrian : StatusTransaksi.proses,
                          statusPembayaran: isLunas ? 'Lunas' : 'Belum Lunas',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.btnWarning,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 40, color: AppColors.primaryDark),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNav(active: NavTab.home),

      backgroundColor: AppColors.homeBackground,
    );
  }
}

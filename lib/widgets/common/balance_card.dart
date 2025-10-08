import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class BalanceCard extends StatelessWidget {
  final String dateText, balance, todayIncome, totalNota, pemasukan, pengeluaran;
  const BalanceCard({
    super.key,
    required this.dateText,
    required this.balance,
    required this.todayIncome,
    required this.totalNota,
    required this.pemasukan,
    required this.pengeluaran,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBlueCard, // kartu biru tua sesuai desain
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Total Saldo', style: TextStyle(color: Colors.white70)),
            const Spacer(),
            const Icon(Icons.calendar_month, size: 16, color: Colors.white70),
            const SizedBox(width: 6),
            Text(dateText, style: const TextStyle(color: Colors.white70)),
          ]),
          const SizedBox(height: 8),
          Text(balance,
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _StatBox(title: 'Pendapatan Hari Ini', value: todayIncome)),
              const SizedBox(width: 12),
              Expanded(child: _StatBox(title: 'Total Nota', value: totalNota)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  title: 'Pemasukan',
                  value: pemasukan,
                  icon: Icons.add,
                  valueColor: AppColors.income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  title: 'Pengeluaran',
                  value: pengeluaran,
                  icon: Icons.remove,
                  valueColor: AppColors.expense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title, value;
  final IconData? icon;
  final Color? valueColor;
  const _StatBox({required this.title, required this.value, this.icon, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        Row(children: [
          if (icon != null) Icon(icon, size: 16, color: valueColor ?? Colors.white),
          if (icon != null) const SizedBox(width: 6),
          Expanded(
            child: Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ]),
      ]),
    );
  }
}

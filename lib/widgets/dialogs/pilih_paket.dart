import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

// Model untuk Service Item
class ServiceItem {
  final String id;
  final String name;
  final String price;
  final String unit;
  final int minOrder;
  int quantity; // <- mutable biar bisa diubah di BuatNotaScreen

  ServiceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.minOrder,
    this.quantity = 1,
  });

  ServiceItem copyWith({
    String? id,
    String? name,
    String? price,
    String? unit,
    int? minOrder,
    int? quantity,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      minOrder: minOrder ?? this.minOrder,
      quantity: quantity ?? this.quantity,
    );
  }
}

// Main Dialog Function
Future<List<ServiceItem>?> showPilihPaketDialog(
  BuildContext context, {
  required String kategori, // 'Satuan', 'Kiloan', 'Meter', 'Load'
}) async {
  return await showDialog<List<ServiceItem>>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return PilihPaketDialog(kategori: kategori);
    },
  );
}

class PilihPaketDialog extends StatefulWidget {
  final String kategori;

  const PilihPaketDialog({
    super.key,
    required this.kategori,
  });

  @override
  State<PilihPaketDialog> createState() => _PilihPaketDialogState();
}

class _PilihPaketDialogState extends State<PilihPaketDialog> {
  final List<ServiceItem> selectedServices = [];

  // Data dummy untuk setiap kategori
  List<ServiceItem> _getServicesByKategori() {
    switch (widget.kategori) {
      case 'Satuan':
        return [
          ServiceItem(id: '1', name: 'Bed Cover', price: 'IDR 16.000', unit: 'PCS', minOrder: 1, quantity: 1),
          ServiceItem(id: '2', name: 'Seprai', price: 'IDR 11.000', unit: 'PCS', minOrder: 1, quantity: 1),
          ServiceItem(id: '3', name: 'Karpet', price: 'IDR 100.000', unit: 'PCS', minOrder: 1, quantity: 1),
          ServiceItem(id: '4', name: 'Boneka', price: 'IDR 15.000', unit: 'PCS', minOrder: 1, quantity: 1),
          ServiceItem(id: '5', name: 'Tas', price: 'IDR 20.000', unit: 'PCS', minOrder: 1, quantity: 1),
        ];
      case 'Kiloan':
        return [
          ServiceItem(id: '6', name: 'Cuci Kering + Setrika', price: 'IDR 6.000', unit: 'KG', minOrder: 3),
          ServiceItem(id: '7', name: 'Cuci Kering + Lipat', price: 'IDR 5.000', unit: 'KG', minOrder: 3),
          ServiceItem(id: '8', name: 'Cuci Basah', price: 'IDR 4.000', unit: 'KG', minOrder: 3),
          ServiceItem(id: '9', name: 'Setrika Only', price: 'IDR 3.500', unit: 'KG', minOrder: 3),
        ];
      case 'Meter':
        return [
          ServiceItem(id: '10', name: 'Gordyn Tebal', price: 'IDR 12.000', unit: 'Meter', minOrder: 1),
          ServiceItem(id: '11', name: 'Gordyn Tipis', price: 'IDR 8.000', unit: 'Meter', minOrder: 1),
          ServiceItem(id: '12', name: 'Vitrase', price: 'IDR 6.000', unit: 'Meter', minOrder: 1),
        ];
      case 'Load':
        return [
          ServiceItem(id: '13', name: 'Cuci Express (1 Hari)', price: 'IDR 35.000', unit: 'LOAD', minOrder: 1),
          ServiceItem(id: '14', name: 'Cuci Regular (3 Hari)', price: 'IDR 25.000', unit: 'LOAD', minOrder: 1),
        ];
      default:
        return [];
    }
  }

  void _toggleService(ServiceItem service) {
    setState(() {
      final idx = selectedServices.indexWhere((s) => s.id == service.id);
      if (idx >= 0) {
        selectedServices.removeAt(idx);
      } else {
        // clone biar state di list utama aman
        selectedServices.add(service.copyWith());
      }
    });
  }

  bool _isSelected(ServiceItem service) {
    return selectedServices.any((s) => s.id == service.id);
  }

  @override
  Widget build(BuildContext context) {
    final services = _getServicesByKategori();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pilih Paket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red, width: 2)),
                      child: const Icon(Icons.close, color: Colors.red, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Service List
            Flexible(
              child: services.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Tidak ada paket tersedia', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      itemCount: services.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        final isSelected = _isSelected(service);

                        return InkWell(
                          onTap: () => _toggleService(service),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Icon Service
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getServiceIcon(widget.kategori),
                                    color: isSelected ? AppColors.primary : Colors.grey[600],
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Service Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? AppColors.primary : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.sell_outlined, size: 14, color: AppColors.primary),
                                          const SizedBox(width: 4),
                                          Text(
                                            service.price,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Min Order Badge
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.primary : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Min. ${service.minOrder} ${service.unit}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(height: 8),
                                      const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Footer - Tombol Konfirmasi
            if (services.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
                ),
                child: Column(
                  children: [
                    if (selectedServices.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${selectedServices.length} Paket Dipilih',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedServices.isEmpty ? null : () => Navigator.pop(context, selectedServices),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey[300],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Text(
                          selectedServices.isEmpty ? 'Pilih Paket' : 'Tambahkan ${selectedServices.length} Paket',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

  IconData _getServiceIcon(String kategori) {
    switch (kategori) {
      case 'Satuan':
        return Icons.checkroom_outlined;
      case 'Kiloan':
        return Icons.scale_outlined;
      case 'Meter':
        return Icons.straighten_outlined;
      case 'Load':
        return Icons.local_laundry_service_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}

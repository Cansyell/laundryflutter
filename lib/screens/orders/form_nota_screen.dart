import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../controllers/nota_controller.dart';
import '../../model/customer_model.dart';
import '../../model/service_model.dart';
import '../../model/nota_service_item.dart';
import '../../widgets/form/nota_form_fields.dart';
import '../checkout/transaksi_sukses_screen.dart';

class BuatNotaScreen extends StatefulWidget {
  const BuatNotaScreen({Key? key}) : super(key: key);

  @override
  State<BuatNotaScreen> createState() => _BuatNotaScreenState();
}

class _BuatNotaScreenState extends State<BuatNotaScreen> {
  late final NotaController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NotaController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Buat Nota',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingCustomers.value || controller.isLoadingServices.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildDateSection(),
              _buildPelangganSection(),
              _buildPaketSection(),
              _buildPembayaranSection(),
              _buildRingkasanSection(),
              _buildKonfirmasiButton(),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  // ─── SECTION: TANGGAL ───────────────────────────────────────────────
  Widget _buildDateSection() {
    return Obx(() {
      final date = controller.selectedDate.value;
      final formatted = "${date.day} ${_getMonthName(date.month)} ${date.year}";

      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: AppColors.primary),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) controller.setSelectedDate(picked);
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tanggal Transaksi', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(formatted, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  // ─── SECTION: PELANGGAN ─────────────────────────────────────────────
  Widget _buildPelangganSection() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pelanggan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            SearchableCustomerDropdown(
              label: '',
              hint: 'Pilih Pelanggan',
              selectedCustomer: controller.selectedCustomer.value.id != null 
                  ? controller.selectedCustomer.value 
                  : null,
              customers: controller.customers,
              onChanged: (customer) {
                if (customer != null) {
                  controller.setSelectedCustomer(customer);
                }
              },
            ),
          ],
        ),
      );
    });
  }

  // ─── SECTION: PAKET/LAYANAN (UPDATED WITH DYNAMIC CATEGORIES) ───────
  Widget _buildPaketSection() {
    return Obx(() {
      final selectedServices = controller.selectedServices;
      
      // Ambil kategori unik dari services
      final uniqueTypes = controller.services
          .where((s) => s.type != null)
          .map((s) => s.type!)
          .toSet()
          .toList();

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Paket Layanan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
                TextButton.icon(
                  onPressed: _showServicePicker,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Tambah'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 8)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Dynamic category chips dari API
            if (uniqueTypes.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: uniqueTypes.map((type) {
                  return _buildCategoryChip(type, _getUnitLabel(type), () => _showServicePicker(type: type));
                }).toList(),
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            if (selectedServices.isEmpty)
              _buildPlaceholder('Belum ada paket yang dipilih')
            else
              ...selectedServices.map((service) => _buildServiceItem(service)).toList(),
          ],
        ),
      );
    });
  }

  // Helper untuk mendapatkan label unit
  String _getUnitLabel(String type) {
    switch (type.toUpperCase()) {
      case 'PCS':
        return 'PCS';
      case 'KG':
        return 'KG';
      case 'METER':
        return 'Mtr';
      case 'LOAD':
        return 'LOAD';
      default:
        return type;
    }
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String unit, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 13)),
              TextSpan(text: '($unit)', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── UPDATED SERVICE ITEM WITH REACTIVE QUANTITY ────────────────────
  Widget _buildServiceItem(NotaServiceItem service) {
    return Obx(() {
      // Force rebuild when selectedServices changes
      final currentService = controller.selectedServices.firstWhereOrNull(
        (s) => s.id == service.id
      );
      
      if (currentService == null) return const SizedBox.shrink();
      
      // Get full service data
      final fullService = controller.services.firstWhereOrNull(
        (s) => s.id == currentService.id
      );
      
      final totalPrice = currentService.price * currentService.quantity;

      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentService.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      if (fullService?.category != null) ...[
                        Row(
                          children: [
                            Icon(Icons.category, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              fullService!.category!.name,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                      ],
                      
                      if (fullService?.estimate != null) ...[
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Estimasi: ${fullService!.estimate}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      
                      Text(
                        _formatIDR(currentService.price.toInt()),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      
                      if (currentService.type != null)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            currentService.type!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildQuantityButtons(currentService),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => controller.removeService(currentService.id?.toString() ?? ''),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Hapus', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Text(
                  _formatIDR(totalPrice.toInt()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showServicePicker({String? type}) {
    final services = type == null
        ? controller.services
        : controller.services.where((s) => s.type?.toUpperCase() == type.toUpperCase()).toList();

    if (services.isEmpty) {
      Get.snackbar("ℹ️ Info", "Tidak ada layanan ${type ?? ''} tersedia");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type == null ? 'Pilih Layanan' : 'Layanan $type',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        
                        return Obx(() {
                          final isSelected = controller.selectedServices
                              .any((s) => s.id == service.id);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: isSelected ? 2 : 0,
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                service.name,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  
                                  Text(
                                    _formatIDR(service.price.toInt()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  
                                  if (service.category != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category_outlined,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          service.category!.name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  
                                  if (service.estimate != null) ...[
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Estimasi: ${service.estimate}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (service.type != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            service.type!,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (service.minOrder != null)
                                        Text(
                                          'Min: ${service.minOrder}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                              onTap: () => controller.addService(service),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── UPDATED QUANTITY BUTTONS (REACTIVE) ────────────────────────────
  Widget _buildQuantityButtons(NotaServiceItem service) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (service.quantity > service.minOrder) {
              controller.updateQuantity(service.id?.toString() ?? '', service.quantity - 1);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: service.quantity > service.minOrder ? Colors.red.shade50 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.remove,
              size: 18,
              color: service.quantity > service.minOrder ? Colors.red : Colors.grey,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text('${service.quantity}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        InkWell(
          onTap: () => controller.updateQuantity(service.id?.toString() ?? '', service.quantity + 1),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.add, size: 18, color: Colors.green),
          ),
        ),
      ],
    );
  }

  // ─── SECTION: PEMBAYARAN ────────────────────────────────────────────
  Widget _buildPembayaranSection() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status Pembayaran', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildPaymentOption('Bayar Sekarang', 'paid', Icons.check_circle, Icons.check_circle_outline),
                const SizedBox(width: 12),
                _buildPaymentOption('Bayar Nanti', 'unpaid', Icons.schedule, Icons.schedule_outlined),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaymentOption(String label, String value, IconData activeIcon, IconData inactiveIcon) {
    final isActive = controller.paymentStatus.value == value;
    final bgColor = isActive ? (value == 'paid' ? AppColors.primary : const Color(0xFF8FA8E8)) : Colors.white;
    final iconColor = isActive ? Colors.white : Colors.grey;
    final textColor = isActive ? Colors.white : Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => controller.setPaymentStatus(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? bgColor : Colors.grey.shade300,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isActive ? activeIcon : inactiveIcon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SECTION: RINGKASAN ──────────────────────────────────────────────
  Widget _buildRingkasanSection() {
    return Obx(() {
      final subtotal = controller.calculateSubtotal().toInt();
      final biayaPenanganan = controller.biayaPenanganan.toInt();
      final biayaKantong = controller.biayaKantong.toInt();
      final total = controller.calculateTotal().toInt();

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan Biaya', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 16),
            _buildPriceRow('Subtotal Layanan', subtotal),
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Penanganan', biayaPenanganan, isSubItem: true),
            const SizedBox(height: 8),
            _buildPriceRow('Biaya Kantong', biayaKantong, isSubItem: true),
            const Divider(height: 24),
            _buildPriceRow('Total Bayar', total, isTotal: true),
          ],
        ),
      );
    });
  }

  Widget _buildPriceRow(String label, int amount, {bool isSubItem = false, bool isTotal = false}) {
    final color = isTotal ? AppColors.primary : isSubItem ? Colors.grey[600] : Colors.black;
    final fontWeight = isTotal ? FontWeight.bold : FontWeight.normal;
    final fontSize = isTotal ? 16.0 : 14.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color)),
        Text(_formatIDR(amount), style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color)),
      ],
    );
  }

  // ─── BUTTON: KONFIRMASI ──────────────────────────────────────────────
  Widget _buildKonfirmasiButton() {
    return Obx(() {
      final canSubmit = controller.isFormValid;
      final isProcessing = controller.isCreatingTransaction.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: canSubmit && !isProcessing
              ? () async {
                  final success = await controller.createTransaction();
                  if (success) {
                    Get.offAll(
                      () => TransaksiSuksesScreen(
                        transactionId: "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
                        customer: controller.selectedCustomer.value,
                        transactionDate: controller.selectedDate.value,
                        estimatedCompletion: controller.selectedDate.value.add(const Duration(days: 2)),
                        totalAmount: controller.calculateTotal(),
                        services: controller.selectedServices.toList(),
                        biayaPenanganan: controller.biayaPenanganan,
                        biayaKantong: controller.biayaKantong,
                        statusPembayaran: controller.paymentStatus.value,
                      ),
                    );
                  }
                }
              : null,

            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit ? AppColors.primary : Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isProcessing
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Buat Nota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      );
    });
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────
  String _formatIDR(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  String _getMonthName(int month) {
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }
}
// lib/widgets/common/ios_date_picker.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class IOSDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) async {
    DateTime selectedDate = initialDate ?? DateTime.now();

    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header with action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Batal button
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    // OK button
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context, selectedDate),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Pilih Tanggal Saat Ini',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              // Date Picker
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
              
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}

// Contoh penggunaan dalam widget
class DatePickerExample extends StatefulWidget {
  const DatePickerExample({Key? key}) : super(key: key);

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime selectedDate = DateTime.now();
  
  String formatDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await IOSDatePicker.show(
            context,
            initialDate: selectedDate,
            minimumDate: DateTime(2020),
            maximumDate: DateTime(2030),
          );
          
          if (picked != null && picked != selectedDate) {
            setState(() {
              selectedDate = picked;
            });
          }
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatDate(selectedDate),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
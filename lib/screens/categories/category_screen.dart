import 'package:flutter/material.dart';
import '/config/app_colors.dart';
import 'category_form_screen.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'name': 'Satuan', 'unit': 'PCS'},
      {'name': 'Kiloan', 'unit': 'KG'},
      {'name': 'Meter', 'unit': 'METER'},
      {'name': 'Load', 'unit': 'LOAD'},
    ];

    return Scaffold(
      backgroundColor:AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Kategori', style: TextStyle(color: AppColors.textWhite)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.textWhite,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // List of categories
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['name']!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(item['unit']!,
                            style: const TextStyle(
                                fontSize: 15, color: AppColors.textPrimary)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CategoryFormScreen(),
            ),
           );
        },
        backgroundColor: AppColors.primary,
        label: const Text('Tambah',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textWhite)),
        icon: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }
}

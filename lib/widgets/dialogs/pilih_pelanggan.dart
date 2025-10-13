import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

Future<Map<String, String>?> showPilihPelangganDialog(BuildContext context) async {
  final TextEditingController searchController = TextEditingController();

  // Data dummy pelanggan
  final List<Map<String, String>> pelangganList = [
    {
      'nama': 'Budi Raharja',
      'alamat': 'Jl. Kebijakan IDN No 43, Jawa Utara',
      'noTelp': '081313130978',
    },
    {
      'nama': 'Sumala Sari',
      'alamat': 'Jl. Dukunawar Blok A No 4, Jawa Utara',
      'noTelp': '081815432978',
    },
    {
      'nama': 'Lilis Handayani',
      'alamat': 'Jl. Mawar No 12, Jawa Tengah',
      'noTelp': '081234567890',
    },
  ];

  return showDialog<Map<String, String>?>(
    context: context,
    builder: (context) {
      List<Map<String, String>> filteredList = List.from(pelangganList);

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search Field
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Cari Nama Pelanggan',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onChanged: (value) {
                            setState(() {
                              filteredList = pelangganList
                                  .where((pelanggan) => pelanggan['nama']!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List Pelanggan
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final pelanggan = filteredList[index];
                        return InkWell(
                          onTap: () => Navigator.pop(context, pelanggan),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline,
                                        size: 18, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      pelanggan['nama']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        pelanggan['noTelp']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        pelanggan['alamat']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

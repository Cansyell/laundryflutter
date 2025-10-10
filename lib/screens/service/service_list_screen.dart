import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/bottom_nav.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

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
                const Text(
                  'Daftar Layanan',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text('Layanan ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Deskripsi singkat layanan'),
              trailing: const Text('Rp 25.000',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Klik layanan ${index + 1}'),
                  duration: const Duration(seconds: 1),
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.btnWarning,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 36, color: AppColors.primaryDark),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     bottomNavigationBar: const BottomNav(active: NavTab.services),

      backgroundColor: AppColors.homeBackground,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tugas_akhir/presentation/admin/home/admin_home_screen.dart';
import 'package:tugas_akhir/presentation/admin/main/widgets/my_bottom_nav_bar.dart'; // Ensure this import path is correct
import 'package:tugas_akhir/presentation/admin/pengeluaran/pages/pengeluaran_page.dart';
import 'package:tugas_akhir/presentation/admin/profile/widget/admin_profile_screen.dart';

class MainAdminScreen extends StatefulWidget {
  const MainAdminScreen({super.key});

  @override
  State<MainAdminScreen> createState() => _MainAdminScreenState();
}

class _MainAdminScreenState extends State<MainAdminScreen> {
  int _selectedIndex = 0; // 0: Home, 1: Profil, 2: Pengeluaran

  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const AdminProfileScreen(),
    const PengeluaranPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for allowing the body to extend behind the floating bar
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding( // Add Padding to make the bar "float"
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), // Adjust these values for desired spacing
        child: MyBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}